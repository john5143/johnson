/*****************************************************************
Name:          EmployeeLeave_TriggerHandler
================================================================
Purpose:       Orchestration for EmployeeLeaveTrigger (Sprint 2).
               Reads trigger context, builds the set of affected
               BalanceKeys, applies the kill-switch + recursion
               guard, and calls the rollup service exactly once.
               Contains NO aggregation and NO DML of its own.

Recursion / kill-switch:
   - bypass       : @TestVisible static kill-switch; when true the
                    handler is fully disabled (CRM standard: a trigger
                    must be disable-able). No custom metadata required.
   - isProcessing : @TestVisible transaction-scoped in-progress flag
                    preventing re-entrant execution within the same
                    transaction. A boolean (not a Set<Id>) is used so a
                    legitimate insert->update->delete sequence on the
                    SAME records in one transaction is NOT wrongly
                    skipped.

ASSUMPTION (documented): rows whose keyFor() is null (null
   Employee__c or Start_Date__c) are skipped.
================================================================
History
-------
VERSION  AUTHOR              DATE         DETAIL    DESCRIPTION
1.0      Revecast Orch.      2026-09-30   Created   Sprint 2 Leave Balance Engine
*****************************************************************/
public with sharing class EmployeeLeave_TriggerHandler {

    @TestVisible private static Boolean bypass = false;
    @TestVisible private static Boolean isProcessing = false;

    /** Entry point invoked by the logic-less trigger. */
    public void run() {
        if (bypass || isProcessing) {
            return;
        }
        isProcessing = true;
        try {
            Set<LeaveBalanceService.BalanceKey> keys =
                new Set<LeaveBalanceService.BalanceKey>();

            if (Trigger.isInsert || Trigger.isUndelete) {
                // New / restored rows -> recalc the new bucket.
                for (Employee_Leave__c r : (List<Employee_Leave__c>) Trigger.new) {
                    keys.add(LeaveBalanceService.keyFor(r));
                }
            } else if (Trigger.isDelete) {
                // Removed rows -> recalc the bucket they left.
                for (Employee_Leave__c r : (List<Employee_Leave__c>) Trigger.old) {
                    keys.add(LeaveBalanceService.keyFor(r));
                }
            } else if (Trigger.isUpdate) {
                Map<Id, Employee_Leave__c> oldMap =
                    (Map<Id, Employee_Leave__c>) Trigger.oldMap;
                for (Employee_Leave__c n : (List<Employee_Leave__c>) Trigger.new) {
                    // Always recalc the new bucket (covers Status / Total_Days change).
                    keys.add(LeaveBalanceService.keyFor(n));
                    // Also recalc the OLD bucket when the record moved buckets.
                    Employee_Leave__c o = oldMap.get(n.Id);
                    if (o != null && bucketChanged(o, n)) {
                        keys.add(LeaveBalanceService.keyFor(o));
                    }
                }
            }

            keys.remove(null); // drop skipped/incomplete rows
            if (!keys.isEmpty()) {
                LeaveBalanceRollupService.recalculate(keys);
            }
        } finally {
            isProcessing = false;
        }
    }

    /** True when Employee, Leave Type, or Start_Date calendar-year changed. */
    private Boolean bucketChanged(Employee_Leave__c o, Employee_Leave__c n) {
        return o.Employee__c != n.Employee__c
            || o.Leave_Type__c != n.Leave_Type__c
            || yearOf(o) != yearOf(n);
    }

    private Integer yearOf(Employee_Leave__c r) {
        return (r.Start_Date__c == null) ? null : r.Start_Date__c.year();
    }
}
