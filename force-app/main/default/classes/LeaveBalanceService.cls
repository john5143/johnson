/*****************************************************************
Name:          LeaveBalanceService
================================================================
Purpose:       Read / compute layer for the Employee Leave
               Balance Engine (Sprint 2). Runs with sharing and
               performs all reads in USER_MODE (plus
               Security.stripInaccessible for record reads) so it
               is safe for future user-context consumers.
               Home of the typed BalanceKey abstraction.

               ASSUMPTION (documented): a leave row with a null
               Employee__c or null Start_Date__c cannot be mapped
               to an entitlement bucket, so keyFor() returns null
               and such incomplete rows are skipped by callers.
================================================================
History
-------
VERSION  AUTHOR              DATE         DETAIL    DESCRIPTION
1.0      Revecast Orch.      2026-09-30   Created   Sprint 2 Leave Balance Engine
*****************************************************************/
public with sharing class LeaveBalanceService {

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
            String lt = (leaveType == null) ? '' : leaveType.toLowerCase();
            return String.valueOf(employeeId) + '|' + lt + '|' + String.valueOf(year);
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
     * Null-safe factory. Returns null (skip signal) when the row lacks the
     * Employee__c or Start_Date__c needed to identify a bucket.
     */
    public static BalanceKey keyFor(Employee_Leave__c rec) {
        if (rec == null || rec.Employee__c == null || rec.Start_Date__c == null) {
            return null;
        }
        return new BalanceKey(rec.Employee__c, rec.Leave_Type__c, rec.Start_Date__c.year());
    }

    /**
     * Aggregate Approved -> used and Pending -> pending day totals for the
     * given buckets. Single aggregate SOQL, USER_MODE, no SOQL in loops.
     * Rejected / Cancelled are excluded by the WHERE clause (contribute zero).
     */
    public Map<BalanceKey, BalanceTotals> computeTotals(Set<BalanceKey> keys) {
        Map<BalanceKey, BalanceTotals> result = new Map<BalanceKey, BalanceTotals>();
        if (keys == null || keys.isEmpty()) {
            return result;
        }

        Set<Id> empIds = new Set<Id>();
        Set<String> types = new Set<String>();
        Set<Integer> years = new Set<Integer>();
        for (BalanceKey k : keys) {
            if (k == null) {
                continue;
            }
            empIds.add(k.employeeId);
            types.add(k.leaveType);
            years.add(k.year);
        }
        years.remove(null);

        List<AggregateResult> rows = [
            SELECT Employee__c emp, Leave_Type__c lt,
                   CALENDAR_YEAR(Start_Date__c) yr, Status__c st,
                   SUM(Total_Days__c) total
            FROM Employee_Leave__c
            WHERE Employee__c IN :empIds
              AND Leave_Type__c IN :types
              AND CALENDAR_YEAR(Start_Date__c) IN :years
              AND Status__c IN ('Approved', 'Pending')
            WITH USER_MODE
            GROUP BY Employee__c, Leave_Type__c, CALENDAR_YEAR(Start_Date__c), Status__c
        ];

        for (AggregateResult ar : rows) {
            Id emp = (Id) ar.get('emp');
            String lt = (String) ar.get('lt');
            Integer yr = (Integer) ar.get('yr');
            String st = (String) ar.get('st');
            Decimal total = (Decimal) ar.get('total');
            if (total == null) {
                total = 0;
            }

            BalanceKey k = new BalanceKey(emp, lt, yr);
            if (!keys.contains(k)) {
                continue;
            }
            BalanceTotals t = result.get(k);
            if (t == null) {
                t = new BalanceTotals();
                result.put(k, t);
            }
            if (st == 'Approved') {
                t.usedDays = total;
            } else if (st == 'Pending') {
                t.pendingDays = total;
            }
        }
        return result;
    }

    /**
     * User-context read of the entitlement records for the given buckets,
     * enforced with USER_MODE and Security.stripInaccessible. Provided as a
     * safe read API for future user-facing consumers; NOT used on the
     * authoritative write path (that is the without-sharing rollup service).
     */
    public Map<BalanceKey, Leave_Entitlement__c> getEntitlementSnapshot(Set<BalanceKey> keys) {
        Map<BalanceKey, Leave_Entitlement__c> result = new Map<BalanceKey, Leave_Entitlement__c>();
        if (keys == null || keys.isEmpty()) {
            return result;
        }

        Set<Id> empIds = new Set<Id>();
        Set<String> types = new Set<String>();
        Set<Decimal> years = new Set<Decimal>();
        for (BalanceKey k : keys) {
            if (k == null) {
                continue;
            }
            empIds.add(k.employeeId);
            types.add(k.leaveType);
            if (k.year != null) {
                years.add((Decimal) k.year);
            }
        }

        List<Leave_Entitlement__c> rows = [
            SELECT Id, Employee__c, Leave_Type__c, Year__c, Entitled_Days__c,
                   Carry_Forward_Days__c, Used_Days__c, Pending_Days__c
            FROM Leave_Entitlement__c
            WHERE Employee__c IN :empIds
              AND Leave_Type__c IN :types
              AND Year__c IN :years
            WITH USER_MODE
        ];

        SObjectAccessDecision decision =
            Security.stripInaccessible(AccessType.READABLE, rows);
        for (SObject so : decision.getRecords()) {
            Leave_Entitlement__c e = (Leave_Entitlement__c) so;
            Integer yr = (e.Year__c == null) ? null : e.Year__c.intValue();
            BalanceKey k = new BalanceKey(e.Employee__c, e.Leave_Type__c, yr);
            if (keys.contains(k)) {
                result.put(k, e);
            }
        }
        return result;
    }
}
