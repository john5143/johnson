/*****************************************************************
Name:          EmployeeLeaveTrigger
================================================================
Purpose:       Single, logic-less trigger on Employee_Leave__c
               for the Leave Balance Engine (Sprint 2). Delegates
               all work to EmployeeLeave_TriggerHandler.
================================================================
*****************************************************************/
trigger EmployeeLeaveTrigger on Employee_Leave__c (
        after insert, after update, after delete, after undelete) {
    new EmployeeLeave_TriggerHandler().run();
}
