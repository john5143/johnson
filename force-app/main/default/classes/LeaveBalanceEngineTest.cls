/*****************************************************************
Name:          LeaveBalanceEngineTest
================================================================
Purpose:       End-to-end tests for the Employee Leave Balance
               Engine via the trigger -> handler -> rollup path.
               No SeeAllData; all Users / Entitlements / Leaves are
               created explicitly. Mixed DML is handled by creating
               Users inside System.runAs.
================================================================
*****************************************************************/
@isTest
private class LeaveBalanceEngineTest {

    // ---- data factory -------------------------------------------------
    private static Integer counter = 0;

    private static User makeUser(String lastName) {
        counter++;
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        String uniq = 'lve' + counter + System.now().getTime() + '@example.com.invalid';
        return new User(
            FirstName = 'Test', LastName = lastName, Alias = ('u' + counter).left(8),
            Email = uniq, Username = uniq, ProfileId = p.Id,
            TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US'
        );
    }

    private static Leave_Entitlement__c ent(Id emp, String type, Integer yr,
                                            Decimal entitled, Decimal carry) {
        return new Leave_Entitlement__c(
            Employee__c = emp, Leave_Type__c = type, Year__c = yr,
            Entitled_Days__c = entitled, Carry_Forward_Days__c = carry,
            Used_Days__c = 0, Pending_Days__c = 0,
            Unique_Key__c = emp + '-' + type + '-' + yr
        );
    }

    private static Employee_Leave__c leave(Id emp, String type, String status,
                                           Date startDate, Integer days) {
        return new Employee_Leave__c(
            Employee__c = emp, Leave_Type__c = type, Status__c = status,
            Start_Date__c = startDate, End_Date__c = startDate.addDays(days - 1),
            Total_Days__c = days
        );
    }

    private static User getUser(String lastName) {
        return [SELECT Id FROM User WHERE LastName = :lastName LIMIT 1];
    }

    private static Leave_Entitlement__c getEnt(Id emp, String type, Integer yr) {
        return [SELECT Id, Entitled_Days__c, Carry_Forward_Days__c,
                       Used_Days__c, Pending_Days__c, Available_Days__c
                FROM Leave_Entitlement__c
                WHERE Employee__c = :emp AND Leave_Type__c = :type AND Year__c = :yr
                LIMIT 1];
    }

    @TestSetup
    static void setup() {
        List<User> users = new List<User>{
            makeUser('EmpOne'), makeUser('EmpTwo'), makeUser('EmpThree')
        };
        System.runAs(new User(Id = UserInfo.getUserId())) {
            insert users;   // setup-object DML isolated to avoid Mixed DML
        }
        Id e1 = users[0].Id, e2 = users[1].Id, e3 = users[2].Id;
        insert new List<Leave_Entitlement__c>{
            ent(e1, 'Vacation', 2026, 20, 5),
            ent(e1, 'Sick', 2026, 10, 0),
            ent(e1, 'Vacation', 2025, 15, 0),
            ent(e2, 'Vacation', 2026, 20, 0),
            ent(e3, 'Vacation', 2026, 20, 0)
        };
    }

    // ---- 1. single Pending -------------------------------------------
    @isTest static void testSinglePending() {
        Id e = getUser('EmpOne').Id;
        Test.startTest();
        insert leave(e, 'Vacation', 'Pending', Date.newInstance(2026, 2, 1), 3);
        Test.stopTest();
        Leave_Entitlement__c en = getEnt(e, 'Vacation', 2026);
        System.assertEquals(0, en.Used_Days__c, 'Pending -> no used');
        System.assertEquals(3, en.Pending_Days__c, 'Pending -> pending 3');
    }

    // ---- 2. single Approved ------------------------------------------
    @isTest static void testSingleApproved() {
        Id e = getUser('EmpOne').Id;
        Test.startTest();
        insert leave(e, 'Vacation', 'Approved', Date.newInstance(2026, 2, 1), 4);
        Test.stopTest();
        Leave_Entitlement__c en = getEnt(e, 'Vacation', 2026);
        System.assertEquals(4, en.Used_Days__c, 'Approved -> used 4');
        System.assertEquals(0, en.Pending_Days__c, 'Approved -> no pending');
    }

    // ---- 3. Rejected --------------------------------------------------
    @isTest static void testRejected() {
        Id e = getUser('EmpOne').Id;
        Test.startTest();
        insert leave(e, 'Vacation', 'Rejected', Date.newInstance(2026, 2, 1), 5);
        Test.stopTest();
        Leave_Entitlement__c en = getEnt(e, 'Vacation', 2026);
        System.assertEquals(0, en.Used_Days__c, 'Rejected -> zero used');
        System.assertEquals(0, en.Pending_Days__c, 'Rejected -> zero pending');
    }

    // ---- 4. Cancelled -------------------------------------------------
    @isTest static void testCancelled() {
        Id e = getUser('EmpOne').Id;
        Test.startTest();
        insert leave(e, 'Vacation', 'Cancelled', Date.newInstance(2026, 2, 1), 5);
        Test.stopTest();
        Leave_Entitlement__c en = getEnt(e, 'Vacation', 2026);
        System.assertEquals(0, en.Used_Days__c, 'Cancelled -> zero used');
        System.assertEquals(0, en.Pending_Days__c, 'Cancelled -> zero pending');
    }

    // ---- 5. multiple records, same bucket ----------------------------
    @isTest static void testMultipleSameKey() {
        Id e = getUser('EmpOne').Id;
        Test.startTest();
        insert new List<Employee_Leave__c>{
            leave(e, 'Vacation', 'Approved', Date.newInstance(2026, 1, 5), 2),
            leave(e, 'Vacation', 'Approved', Date.newInstance(2026, 3, 5), 3),
            leave(e, 'Vacation', 'Pending', Date.newInstance(2026, 4, 5), 4)
        };
        Test.stopTest();
        Leave_Entitlement__c en = getEnt(e, 'Vacation', 2026);
        System.assertEquals(5, en.Used_Days__c, 'Approved 2+3');
        System.assertEquals(4, en.Pending_Days__c, 'Pending 4');
    }

    // ---- 6. multiple leave types -------------------------------------
    @isTest static void testMultipleLeaveTypes() {
        Id e = getUser('EmpOne').Id;
        Test.startTest();
        insert new List<Employee_Leave__c>{
            leave(e, 'Vacation', 'Approved', Date.newInstance(2026, 1, 5), 3),
            leave(e, 'Sick', 'Approved', Date.newInstance(2026, 2, 5), 2)
        };
        Test.stopTest();
        System.assertEquals(3, getEnt(e, 'Vacation', 2026).Used_Days__c, 'Vacation 3');
        System.assertEquals(2, getEnt(e, 'Sick', 2026).Used_Days__c, 'Sick 2');
    }

    // ---- 7. multiple employees ---------------------------------------
    @isTest static void testMultipleEmployees() {
        Id e1 = getUser('EmpOne').Id, e2 = getUser('EmpTwo').Id;
        Test.startTest();
        insert new List<Employee_Leave__c>{
            leave(e1, 'Vacation', 'Approved', Date.newInstance(2026, 1, 5), 3),
            leave(e2, 'Vacation', 'Approved', Date.newInstance(2026, 2, 5), 4)
        };
        Test.stopTest();
        System.assertEquals(3, getEnt(e1, 'Vacation', 2026).Used_Days__c, 'emp1 3');
        System.assertEquals(4, getEnt(e2, 'Vacation', 2026).Used_Days__c, 'emp2 4');
    }

    // ---- 8. Pending -> Approved --------------------------------------
    @isTest static void testPendingToApproved() {
        Id e = getUser('EmpOne').Id;
        Employee_Leave__c l = leave(e, 'Vacation', 'Pending', Date.newInstance(2026, 2, 1), 3);
        insert l;
        System.assertEquals(3, getEnt(e, 'Vacation', 2026).Pending_Days__c, 'pending 3');
        Test.startTest();
        l.Status__c = 'Approved';
        update l;
        Test.stopTest();
        Leave_Entitlement__c en = getEnt(e, 'Vacation', 2026);
        System.assertEquals(3, en.Used_Days__c, 'now used 3');
        System.assertEquals(0, en.Pending_Days__c, 'pending cleared');
    }

    // ---- 9. Approved -> Pending --------------------------------------
    @isTest static void testApprovedToPending() {
        Id e = getUser('EmpOne').Id;
        Employee_Leave__c l = leave(e, 'Vacation', 'Approved', Date.newInstance(2026, 2, 1), 3);
        insert l;
        System.assertEquals(3, getEnt(e, 'Vacation', 2026).Used_Days__c, 'used 3');
        Test.startTest();
        l.Status__c = 'Pending';
        update l;
        Test.stopTest();
        Leave_Entitlement__c en = getEnt(e, 'Vacation', 2026);
        System.assertEquals(0, en.Used_Days__c, 'used cleared');
        System.assertEquals(3, en.Pending_Days__c, 'now pending 3');
    }

    // ---- 10. Total_Days__c update ------------------------------------
    @isTest static void testTotalDaysUpdate() {
        Id e = getUser('EmpOne').Id;
        Employee_Leave__c l = leave(e, 'Vacation', 'Approved', Date.newInstance(2026, 2, 1), 3);
        insert l;
        Test.startTest();
        l.Total_Days__c = 5;
        l.End_Date__c = Date.newInstance(2026, 2, 5);
        update l;
        Test.stopTest();
        System.assertEquals(5, getEnt(e, 'Vacation', 2026).Used_Days__c, 'used now 5');
    }

    // ---- 11. Leave_Type__c update ------------------------------------
    @isTest static void testLeaveTypeUpdate() {
        Id e = getUser('EmpOne').Id;
        Employee_Leave__c l = leave(e, 'Vacation', 'Approved', Date.newInstance(2026, 2, 1), 3);
        insert l;
        Test.startTest();
        l.Leave_Type__c = 'Sick';
        update l;
        Test.stopTest();
        System.assertEquals(0, getEnt(e, 'Vacation', 2026).Used_Days__c, 'vacation cleared');
        System.assertEquals(3, getEnt(e, 'Sick', 2026).Used_Days__c, 'sick now 3');
    }

    // ---- 12. Employee__c update --------------------------------------
    @isTest static void testEmployeeUpdate() {
        Id e1 = getUser('EmpOne').Id, e2 = getUser('EmpTwo').Id;
        Employee_Leave__c l = leave(e1, 'Vacation', 'Approved', Date.newInstance(2026, 2, 1), 3);
        insert l;
        Test.startTest();
        l.Employee__c = e2;
        update l;
        Test.stopTest();
        System.assertEquals(0, getEnt(e1, 'Vacation', 2026).Used_Days__c, 'emp1 cleared');
        System.assertEquals(3, getEnt(e2, 'Vacation', 2026).Used_Days__c, 'emp2 now 3');
    }

    // ---- 13. Start_Date year update ----------------------------------
    @isTest static void testStartDateYearUpdate() {
        Id e = getUser('EmpOne').Id;
        Employee_Leave__c l = leave(e, 'Vacation', 'Approved', Date.newInstance(2026, 2, 1), 3);
        insert l;
        Test.startTest();
        l.Start_Date__c = Date.newInstance(2025, 2, 1);
        l.End_Date__c = Date.newInstance(2025, 2, 3);
        update l;
        Test.stopTest();
        System.assertEquals(0, getEnt(e, 'Vacation', 2026).Used_Days__c, '2026 cleared');
        System.assertEquals(3, getEnt(e, 'Vacation', 2025).Used_Days__c, '2025 now 3');
    }

    // ---- 14. delete ---------------------------------------------------
    @isTest static void testDelete() {
        Id e = getUser('EmpOne').Id;
        Employee_Leave__c l = leave(e, 'Vacation', 'Approved', Date.newInstance(2026, 2, 1), 3);
        insert l;
        System.assertEquals(3, getEnt(e, 'Vacation', 2026).Used_Days__c, 'used 3');
        Test.startTest();
        delete l;
        Test.stopTest();
        System.assertEquals(0, getEnt(e, 'Vacation', 2026).Used_Days__c, 'used cleared on delete');
    }

    // ---- 15. undelete -------------------------------------------------
    @isTest static void testUndelete() {
        Id e = getUser('EmpOne').Id;
        Employee_Leave__c l = leave(e, 'Vacation', 'Approved', Date.newInstance(2026, 2, 1), 3);
        insert l;
        delete l;
        System.assertEquals(0, getEnt(e, 'Vacation', 2026).Used_Days__c, 'cleared after delete');
        Test.startTest();
        undelete l;
        Test.stopTest();
        System.assertEquals(3, getEnt(e, 'Vacation', 2026).Used_Days__c, 'restored to 3');
    }

    // ---- 16. missing entitlement -> no auto-create -------------------
    @isTest static void testMissingEntitlement() {
        Id e = getUser('EmpOne').Id;
        Test.startTest();
        insert leave(e, 'Personal', 'Approved', Date.newInstance(2026, 2, 1), 3);
        Test.stopTest();
        Integer cnt = [SELECT COUNT() FROM Leave_Entitlement__c
                       WHERE Employee__c = :e AND Leave_Type__c = 'Personal'];
        System.assertEquals(0, cnt, 'No entitlement should be auto-created');
    }

    // ---- 17 + 20. bulk insert (200) + governor headroom --------------
    @isTest static void testBulkInsert() {
        Id e = getUser('EmpOne').Id;
        List<Employee_Leave__c> batch = new List<Employee_Leave__c>();
        for (Integer i = 0; i < 200; i++) {
            batch.add(leave(e, 'Vacation', 'Approved', Date.newInstance(2026, 1, 1), 1));
        }
        Test.startTest();
        insert batch;
        System.assert(Limits.getQueries() <= 10, 'bulk-safe: few SOQL, got ' + Limits.getQueries());
        System.assert(Limits.getDmlStatements() <= 5,
            'bulk-safe: few DML, got ' + Limits.getDmlStatements());
        Test.stopTest();
        System.assertEquals(200, getEnt(e, 'Vacation', 2026).Used_Days__c, '200 approved days');
    }

    // ---- 18. bulk update ---------------------------------------------
    @isTest static void testBulkUpdate() {
        Id e = getUser('EmpOne').Id;
        List<Employee_Leave__c> batch = new List<Employee_Leave__c>();
        for (Integer i = 0; i < 200; i++) {
            batch.add(leave(e, 'Vacation', 'Pending', Date.newInstance(2026, 1, 1), 1));
        }
        insert batch;
        System.assertEquals(200, getEnt(e, 'Vacation', 2026).Pending_Days__c, 'pending 200');
        Test.startTest();
        for (Employee_Leave__c l : batch) {
            l.Status__c = 'Approved';
        }
        update batch;
        Test.stopTest();
        Leave_Entitlement__c en = getEnt(e, 'Vacation', 2026);
        System.assertEquals(200, en.Used_Days__c, 'used 200 after bulk approve');
        System.assertEquals(0, en.Pending_Days__c, 'pending cleared');
    }

    // ---- 19. bulk delete ---------------------------------------------
    @isTest static void testBulkDelete() {
        Id e = getUser('EmpOne').Id;
        List<Employee_Leave__c> batch = new List<Employee_Leave__c>();
        for (Integer i = 0; i < 200; i++) {
            batch.add(leave(e, 'Vacation', 'Approved', Date.newInstance(2026, 1, 1), 1));
        }
        insert batch;
        System.assertEquals(200, getEnt(e, 'Vacation', 2026).Used_Days__c, 'used 200');
        Test.startTest();
        delete batch;
        Test.stopTest();
        System.assertEquals(0, getEnt(e, 'Vacation', 2026).Used_Days__c, 'cleared after bulk delete');
    }

    // ---- 21. Available_Days__c formula -------------------------------
    @isTest static void testAvailableDaysFormula() {
        Id e = getUser('EmpOne').Id; // Vacation 2026: Entitled 20, Carry 5
        Test.startTest();
        insert new List<Employee_Leave__c>{
            leave(e, 'Vacation', 'Approved', Date.newInstance(2026, 1, 5), 3),
            leave(e, 'Vacation', 'Pending', Date.newInstance(2026, 2, 5), 2)
        };
        Test.stopTest();
        Leave_Entitlement__c en = getEnt(e, 'Vacation', 2026);
        // Available = Entitled 20 + Carry 5 - Used 3 - Pending 2 = 20
        System.assertEquals(20, en.Available_Days__c, 'formula 20+5-3-2');
        System.assertEquals(
            en.Entitled_Days__c + en.Carry_Forward_Days__c - en.Used_Days__c - en.Pending_Days__c,
            en.Available_Days__c, 'formula identity');
    }

    // ---- 22. existing Employee Leave functionality intact ------------
    @isTest static void testExistingFunctionalityIntact() {
        Id e = getUser('EmpOne').Id;
        Employee_Leave__c l = leave(e, 'Vacation', 'Approved', Date.newInstance(2026, 2, 1), 3);
        Test.startTest();
        insert l;
        Test.stopTest();
        Employee_Leave__c saved = [SELECT Status__c, Total_Days__c, Leave_Type__c, Employee__c
                                   FROM Employee_Leave__c WHERE Id = :l.Id];
        System.assertEquals('Approved', saved.Status__c, 'status persisted');
        System.assertEquals(3, saved.Total_Days__c, 'total unchanged');
        System.assertEquals('Vacation', saved.Leave_Type__c, 'type persisted');
        System.assertEquals(e, saved.Employee__c, 'employee persisted');
    }
}
