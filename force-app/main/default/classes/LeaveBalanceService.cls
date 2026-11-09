/*****************************************************************
Name:          LeaveBalanceService
================================================================
Purpose:       Read / compute layer for the Employee Leave
               Balance Engine (Sprint 2). Home of the typed
               BalanceKey abstraction and of the shared helpers
               (KeyComponents, buildTotals) used by both the
               user-mode read methods here and the system-mode
               rollup writer (LeaveBalanceRollupService).

READ-ONLY CONTRACT (important):
               computeTotals() and getEntitlementSnapshot() run
               WITH USER_MODE under "with sharing". They return
               only what the CURRENT USER can see, so they are for
               screens and user-facing consumers ONLY. They must
               NEVER feed a write to Leave_Entitlement__c: a total
               built from a sharing-restricted view undercounts the
               balance. The authoritative write path aggregates in
               system mode inside LeaveBalanceRollupService.

ASSUMPTIONS (documented):
   - A leave row with a null Employee__c or null Start_Date__c
     cannot be mapped to a bucket; keyFor() returns null and
     callers skip it.
   - START-YEAR ALLOCATION RULE: a leave that crosses a calendar
     year boundary counts ENTIRELY against the year of its
     Start_Date__c. Preserved as-is until the business confirms
     the cross-year rule; do not split days across years here
     without that decision.
================================================================
History
-------
VERSION  AUTHOR              DATE         DETAIL    DESCRIPTION
1.0      Revecast Orch.      2026-09-30   Created   Sprint 2 Leave Balance Engine
1.1      Revecast Orch.      2026-11-09   Modified  Shared KeyComponents/buildTotals
                                                    helpers; read-only contract
*****************************************************************/
public with sharing class LeaveBalanceService {

    /** Status value that counts towards Used_Days__c. */
    public static final String STATUS_APPROVED = 'Approved';

    /** Status value that counts towards Pending_Days__c. */
    public static final String STATUS_PENDING = 'Pending';

    /**
     * Typed, value-based key identifying one entitlement bucket:
     * Employee (User) + Leave Type (picklist string) + calendar Year.
     * Implements equals/hashCode so it is safe in Sets and as a Map key.
     */
    public class BalanceKey {
        public final Id employeeId;
        public final String leaveType;
        public final Integer year;

        public BalanceKey(Id employeeId, String leaveType, Integer year) {
            this.employeeId = employeeId;
            this.leaveType = leaveType;
            this.year = year;
        }

        // Case-insensitive, null-safe canonical string used by equals + hashCode
        // so the two contracts never disagree.
        private String canonical() {
            String typeText = (leaveType == null) ? '' : leaveType.toLowerCase();
            return String.valueOf(employeeId) + '|' + typeText + '|' + String.valueOf(year);
        }

        public Boolean equals(Object obj) {
            if (!(obj instanceof BalanceKey)) {
                return false;
            }
            BalanceKey other = (BalanceKey) obj;
            return this.canonical() == other.canonical();
        }

        public Integer hashCode() {
            return canonical().hashCode();
        }

        public override String toString() {
            return 'BalanceKey[' + canonical() + ']';
        }
    }

    /** Simple holder for the Approved (used) and Pending totals of one bucket. */
    public class BalanceTotals {
        public Decimal usedDays = 0;
        public Decimal pendingDays = 0;
    }

    /**
     * The distinct filter values (employees, leave types, years) of a key set,
     * used as bind variables in the IN clauses of the bucket queries. Years are
     * kept as Integer (for CALENDAR_YEAR) and as Decimal (for Year__c).
     */
    public class KeyComponents {
        public Set<Id> employeeIds = new Set<Id>();
        public Set<String> leaveTypes = new Set<String>();
        public Set<Integer> years = new Set<Integer>();
        public Set<Decimal> yearsAsDecimal = new Set<Decimal>();

        public KeyComponents(Set<BalanceKey> keys) {
            for (BalanceKey key : keys) {
                // Null keys are the "skip" signal from keyFor(); ignore them.
                if (key == null) {
                    continue;
                }
                employeeIds.add(key.employeeId);
                leaveTypes.add(key.leaveType);
                if (key.year != null) {
                    years.add(key.year);
                    yearsAsDecimal.add((Decimal) key.year);
                }
            }
        }
    }

    /**
     * Null-safe factory. Returns null (skip signal) when the row lacks the
     * Employee__c or Start_Date__c needed to identify a bucket. The bucket year
     * is the START year (see START-YEAR ALLOCATION RULE in the header).
     */
    public static BalanceKey keyFor(Employee_Leave__c rec) {
        if (rec == null || rec.Employee__c == null || rec.Start_Date__c == null) {
            return null;
        }
        return new BalanceKey(rec.Employee__c, rec.Leave_Type__c, rec.Start_Date__c.year());
    }

    /**
     * Turn aggregate rows (aliases emp, lt, yr, st, total) into per-bucket totals,
     * keeping only the buckets that were requested. The IN-clause filters are a
     * cross product of the key components, so rows for unrequested combinations
     * can come back and are dropped here. Shared by the user-mode read below and
     * the system-mode rollup so both apply identical status logic.
     */
    public static Map<BalanceKey, BalanceTotals> buildTotals(
            List<AggregateResult> rows, Set<BalanceKey> keys) {
        Map<BalanceKey, BalanceTotals> result = new Map<BalanceKey, BalanceTotals>();
        for (AggregateResult row : rows) {
            BalanceKey key = new BalanceKey(
                (Id) row.get('emp'), (String) row.get('lt'), (Integer) row.get('yr'));
            if (!keys.contains(key)) {
                continue;
            }
            // SUM over rows whose Total_Days__c are all blank returns null.
            Decimal total = (Decimal) row.get('total');
            total = (total == null) ? 0 : total;

            BalanceTotals totals = result.get(key);
            if (totals == null) {
                totals = new BalanceTotals();
                result.put(key, totals);
            }
            String status = (String) row.get('st');
            if (status == STATUS_APPROVED) {
                totals.usedDays = total;
            } else if (status == STATUS_PENDING) {
                totals.pendingDays = total;
            }
        }
        return result;
    }

    /**
     * READ-ONLY, user-visible totals: Approved -> used and Pending -> pending
     * for the given buckets, as seen by the CURRENT USER (USER_MODE, sharing).
     * Never use the result to write Leave_Entitlement__c (see header).
     * Rejected / Cancelled are excluded by the WHERE clause (contribute zero).
     */
    public Map<BalanceKey, BalanceTotals> computeTotals(Set<BalanceKey> keys) {
        if (keys == null || keys.isEmpty()) {
            return new Map<BalanceKey, BalanceTotals>();
        }
        KeyComponents parts = new KeyComponents(keys);
        Set<Id> employeeIds = parts.employeeIds;
        Set<String> leaveTypes = parts.leaveTypes;
        Set<Integer> years = parts.years;

        List<AggregateResult> rows = [
            SELECT Employee__c emp, Leave_Type__c lt,
                   CALENDAR_YEAR(Start_Date__c) yr, Status__c st,
                   SUM(Total_Days__c) total
            FROM Employee_Leave__c
            WHERE Employee__c IN :employeeIds
              AND Leave_Type__c IN :leaveTypes
              AND CALENDAR_YEAR(Start_Date__c) IN :years
              AND Status__c IN ('Approved', 'Pending')
            WITH USER_MODE
            GROUP BY Employee__c, Leave_Type__c, CALENDAR_YEAR(Start_Date__c), Status__c
        ];
        return buildTotals(rows, keys);
    }

    /**
     * READ-ONLY, user-visible read of the entitlement records for the given
     * buckets, enforced with USER_MODE and Security.stripInaccessible. For
     * user-facing consumers only; NOT used on the write path.
     */
    public Map<BalanceKey, Leave_Entitlement__c> getEntitlementSnapshot(Set<BalanceKey> keys) {
        Map<BalanceKey, Leave_Entitlement__c> result = new Map<BalanceKey, Leave_Entitlement__c>();
        if (keys == null || keys.isEmpty()) {
            return result;
        }
        KeyComponents parts = new KeyComponents(keys);
        Set<Id> employeeIds = parts.employeeIds;
        Set<String> leaveTypes = parts.leaveTypes;
        Set<Decimal> years = parts.yearsAsDecimal;

        List<Leave_Entitlement__c> rows = [
            SELECT Id, Employee__c, Leave_Type__c, Year__c, Entitled_Days__c,
                   Carry_Forward_Days__c, Used_Days__c, Pending_Days__c
            FROM Leave_Entitlement__c
            WHERE Employee__c IN :employeeIds
              AND Leave_Type__c IN :leaveTypes
              AND Year__c IN :years
            WITH USER_MODE
        ];

        // Defence in depth: drop any field the user cannot read.
        SObjectAccessDecision decision =
            Security.stripInaccessible(AccessType.READABLE, rows);
        for (SObject record : decision.getRecords()) {
            Leave_Entitlement__c entitlement = (Leave_Entitlement__c) record;
            BalanceKey key = new BalanceKey(entitlement.Employee__c,
                entitlement.Leave_Type__c, entitlement.Year__c.intValue());
            if (keys.contains(key)) {
                result.put(key, entitlement);
            }
        }
        return result;
    }
}
