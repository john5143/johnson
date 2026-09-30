/*****************************************************************
Name:          LeaveBalanceRollupService
================================================================
Purpose:       Authoritative entitlement writer for the Employee
               Leave Balance Engine (Sprint 2). Given a set of
               BalanceKeys, it obtains Approved/Pending totals from
               LeaveBalanceService (user-mode aggregate) and writes
               Used_Days__c / Pending_Days__c back to the matching
               Leave_Entitlement__c rows in ONE DML statement.

WHY without sharing (documented, narrow):
               An employee editing their OWN Employee_Leave__c
               typically has no edit access to the admin-owned
               Leave_Entitlement__c balance record. The balance must
               still reconcile regardless of the submitter's sharing,
               so this single service runs "without sharing" and loads
               entitlements WITH SYSTEM_MODE. Its surface is limited to
               loading + updating entitlements for keys DERIVED FROM
               TRIGGER DATA only; it accepts no caller-supplied UserIds
               and no dynamic SOQL, so there is no privilege-escalation
               surface.

               Never inserts Leave_Entitlement__c: a bucket with no
               existing entitlement is simply skipped. Available_Days__c
               is a formula and is never written.
================================================================
History
-------
VERSION  AUTHOR              DATE         DETAIL    DESCRIPTION
1.0      Revecast Orch.      2026-09-30   Created   Sprint 2 Leave Balance Engine
*****************************************************************/
public without sharing class LeaveBalanceRollupService {

    /**
     * Recalculate and persist Used/Pending days for every supplied bucket
     * that has an existing entitlement. Two SOQL (aggregate via service +
     * entitlement load here), exactly one DML. No SOQL / DML in loops.
     */
    public static void recalculate(Set<LeaveBalanceService.BalanceKey> keys) {
        if (keys == null) {
            return;
        }
        keys.remove(null);
        if (keys.isEmpty()) {
            return;
        }

        // 1. Approved/Pending totals per bucket (user-mode aggregate).
        LeaveBalanceService service = new LeaveBalanceService();
        Map<LeaveBalanceService.BalanceKey, LeaveBalanceService.BalanceTotals> totals =
            service.computeTotals(keys);

        // 2. Load the matching entitlements authoritatively (system mode).
        Set<Id> empIds = new Set<Id>();
        Set<String> types = new Set<String>();
        Set<Decimal> years = new Set<Decimal>();
        for (LeaveBalanceService.BalanceKey k : keys) {
            empIds.add(k.employeeId);
            types.add(k.leaveType);
            if (k.year != null) {
                years.add((Decimal) k.year);
            }
        }

        List<Leave_Entitlement__c> entitlements = [
            SELECT Id, Employee__c, Leave_Type__c, Year__c, Used_Days__c, Pending_Days__c
            FROM Leave_Entitlement__c
            WHERE Employee__c IN :empIds
              AND Leave_Type__c IN :types
              AND Year__c IN :years
            WITH SYSTEM_MODE
        ];

        // 3. Apply totals; only for buckets that were actually requested.
        List<Leave_Entitlement__c> toUpdate = new List<Leave_Entitlement__c>();
        for (Leave_Entitlement__c e : entitlements) {
            Integer yr = (e.Year__c == null) ? null : e.Year__c.intValue();
            LeaveBalanceService.BalanceKey k =
                new LeaveBalanceService.BalanceKey(e.Employee__c, e.Leave_Type__c, yr);
            if (!keys.contains(k)) {
                continue;
            }
            LeaveBalanceService.BalanceTotals t = totals.get(k);
            Decimal used = (t == null) ? 0 : t.usedDays;
            Decimal pending = (t == null) ? 0 : t.pendingDays;

            if (e.Used_Days__c != used || e.Pending_Days__c != pending) {
                e.Used_Days__c = used;
                e.Pending_Days__c = pending;
                toUpdate.add(e);
            }
        }

        // 4. Single authoritative DML. Available_Days__c recomputes as a formula.
        if (!toUpdate.isEmpty()) {
            update toUpdate;
        }
    }
}
