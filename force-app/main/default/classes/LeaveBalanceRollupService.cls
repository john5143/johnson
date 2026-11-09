/*****************************************************************
Name:          LeaveBalanceRollupService
================================================================
Purpose:       Authoritative entitlement writer for the Employee
               Leave Balance Engine (Sprint 2). For the buckets
               touched by a leave save it (1) locks the matching
               Leave_Entitlement__c rows, (2) totals EVERY Approved
               and Pending leave row in the bucket in SYSTEM MODE,
               and (3) writes Used_Days__c / Pending_Days__c back in
               ONE system-mode DML statement.

WHY system mode for the totals (the Sprint 2 fix):
               The balance is a property of the employee, not of
               the person saving. Totalling through the user-mode
               LeaveBalanceService.computeTotals() counted only the
               rows the saver could see, so a saver with restricted
               leave visibility (external users, or a tightened
               sharing model) would silently undercount the balance.
               The aggregate here ignores sharing and FLS.

WHY system mode for the write:
               An employee saving their OWN leave usually has only
               read access to the admin-owned balance record. A
               plain update failed with "DML operation UPDATE not
               allowed on Leave_Entitlement__c" and rolled back the
               leave save; "update as system" removes that coupling.

WHY FOR UPDATE:
               Two concurrent saves for the same bucket could each
               compute totals and overwrite each other. Locking the
               balance rows first serialises them; the second save
               recomputes after the first commits.

SAFETY:        Keys are derived from trigger data only; no caller-
               supplied Ids and no dynamic SOQL, so there is no
               privilege-escalation surface. Never inserts a
               Leave_Entitlement__c (a bucket without one is
               skipped) and never writes the Available_Days__c
               formula.
================================================================
History
-------
VERSION  AUTHOR              DATE         DETAIL    DESCRIPTION
1.0      Revecast Orch.      2026-09-30   Created   Sprint 2 Leave Balance Engine
1.1      Revecast Orch.      2026-11-09   Modified  System-mode totals, row lock,
                                                    system-mode update
*****************************************************************/
public without sharing class LeaveBalanceRollupService {

    /**
     * Recalculate and persist Used/Pending days for every supplied bucket that
     * has an existing entitlement. At most two SOQL (lock + aggregate) and one
     * DML, whatever the batch size. No SOQL / DML in loops.
     */
    public static void recalculate(Set<LeaveBalanceService.BalanceKey> keys) {
        if (keys == null) {
            return;
        }
        keys.remove(null);
        if (keys.isEmpty()) {
            return;
        }

        LeaveBalanceService.KeyComponents parts = new LeaveBalanceService.KeyComponents(keys);
        Set<Id> employeeIds = parts.employeeIds;
        Set<String> leaveTypes = parts.leaveTypes;
        Set<Integer> years = parts.years;
        Set<Decimal> yearsAsDecimal = parts.yearsAsDecimal;

        // 1. Lock the matching balances first so concurrent saves serialise.
        List<Leave_Entitlement__c> entitlements = [
            SELECT Id, Employee__c, Leave_Type__c, Year__c, Used_Days__c, Pending_Days__c
            FROM Leave_Entitlement__c
            WHERE Employee__c IN :employeeIds
              AND Leave_Type__c IN :leaveTypes
              AND Year__c IN :yearsAsDecimal
            WITH SYSTEM_MODE
            FOR UPDATE
        ];
        // No balance to maintain: skip the aggregate query entirely.
        if (entitlements.isEmpty()) {
            return;
        }

        // 2. Total every Approved / Pending row in system mode (no sharing, no FLS).
        List<AggregateResult> rows = [
            SELECT Employee__c emp, Leave_Type__c lt,
                   CALENDAR_YEAR(Start_Date__c) yr, Status__c st,
                   SUM(Total_Days__c) total
            FROM Employee_Leave__c
            WHERE Employee__c IN :employeeIds
              AND Leave_Type__c IN :leaveTypes
              AND CALENDAR_YEAR(Start_Date__c) IN :years
              AND Status__c IN ('Approved', 'Pending')
            WITH SYSTEM_MODE
            GROUP BY Employee__c, Leave_Type__c, CALENDAR_YEAR(Start_Date__c), Status__c
        ];
        Map<LeaveBalanceService.BalanceKey, LeaveBalanceService.BalanceTotals> totals =
            LeaveBalanceService.buildTotals(rows, keys);

        // 3. Apply totals to requested buckets; collect only rows that changed.
        List<Leave_Entitlement__c> toUpdate = new List<Leave_Entitlement__c>();
        for (Leave_Entitlement__c entitlement : entitlements) {
            LeaveBalanceService.BalanceKey key = new LeaveBalanceService.BalanceKey(
                entitlement.Employee__c, entitlement.Leave_Type__c,
                entitlement.Year__c.intValue());
            if (!keys.contains(key)) {
                continue;
            }
            // A bucket with no Approved/Pending rows resets to zero.
            LeaveBalanceService.BalanceTotals bucket = totals.get(key);
            Decimal used = (bucket == null) ? 0 : bucket.usedDays;
            Decimal pending = (bucket == null) ? 0 : bucket.pendingDays;

            if (entitlement.Used_Days__c != used || entitlement.Pending_Days__c != pending) {
                entitlement.Used_Days__c = used;
                entitlement.Pending_Days__c = pending;
                toUpdate.add(entitlement);
            }
        }

        // 4. Single system-mode DML. Available_Days__c recomputes as a formula.
        if (!toUpdate.isEmpty()) {
            update as system toUpdate;
        }
    }
}
