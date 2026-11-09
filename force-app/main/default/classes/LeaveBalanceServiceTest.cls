/*****************************************************************
Name:          LeaveBalanceServiceTest
================================================================
Purpose:       Unit tests for LeaveBalanceService (keys, totals,
               user-mode read methods) and LeaveBalanceRollupService
               (system-mode rollup), plus the trigger handler's
               kill-switch and re-run guard.

Test data:     No SeeAllData. Users, a TEST-ONLY permission set and
               all records are created here. The permission set
               exists only inside the test transaction (rolled back
               afterwards) and does not touch any org permission
               set. It grants a "restricted saver": full access to
               Employee_Leave__c, READ-ONLY access to
               Leave_Entitlement__c.

Note on the undercount scenario:
               In this org Employee_Leave__c is Public Read/Write
               for internal users, so no internal user can be made
               blind to another user's leave rows and the sharing
               undercount cannot be reproduced in a test. The fix
               (system-mode totals in the rollup) closes it by
               design; these tests prove the rollup is correct for
               a restricted saver and that the user-mode read
               methods DO respect sharing (so they must never feed
               a write).
================================================================
History
-------
VERSION  AUTHOR              DATE         DETAIL    DESCRIPTION
1.0      Revecast Orch.      2026-11-09   Created   Sprint 2 Leave Balance Engine
*****************************************************************/
@isTest
private class LeaveBalanceServiceTest {

    private static final String RESTRICTED_LAST_NAME = 'LbsRestricted';
    private static final String OWNER_LAST_NAME = 'LbsOwner';
    private static final String OTHER_LAST_NAME = 'LbsOther';

    private static Integer counter = 0;

    // ---- data factory -------------------------------------------------

    /** Build (not insert) a Standard User with a unique username. */
    private static User makeUser(String lastName) {
        counter++;
        Profile standardProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        String uniqueName = 'lbs' + counter + System.now().getTime() + '@example.com.invalid';
        return new User(
            FirstName = 'Test', LastName = lastName, Alias = ('lbs' + counter).left(8),
            Email = uniqueName, Username = uniqueName, ProfileId = standardProfile.Id,
            TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US'
        );
    }

    /** Field permission row for the test-only permission set. */
    private static FieldPermissions fieldAccess(Id permSetId, String objectName,
                                                String fieldName, Boolean canEdit) {
        return new FieldPermissions(
            ParentId = permSetId, SobjectType = objectName,
            Field = objectName + '.' + fieldName,
            PermissionsRead = true, PermissionsEdit = canEdit
        );
    }

    /** Test-only permission set: full leave access, read-only balances. */
    private static PermissionSet createRestrictedSaverPermissionSet() {
        PermissionSet permSet = new PermissionSet(
            Name = 'LBS_Test_Restricted_Saver', Label = 'LBS Test Restricted Saver');
        insert permSet;

        insert new List<ObjectPermissions>{
            new ObjectPermissions(ParentId = permSet.Id, SobjectType = 'Employee_Leave__c',
                PermissionsRead = true, PermissionsCreate = true,
                PermissionsEdit = true, PermissionsDelete = true),
            new ObjectPermissions(ParentId = permSet.Id, SobjectType = 'Leave_Entitlement__c',
                PermissionsRead = true)
        };

        List<FieldPermissions> fields = new List<FieldPermissions>();
        for (String field : new List<String>{ 'Employee__c', 'Leave_Type__c', 'Status__c',
                'Start_Date__c', 'End_Date__c', 'Total_Days__c', 'Reason__c' }) {
            fields.add(fieldAccess(permSet.Id, 'Employee_Leave__c', field, true));
        }
        for (String field : new List<String>{ 'Employee__c', 'Leave_Type__c', 'Year__c',
                'Entitled_Days__c', 'Carry_Forward_Days__c', 'Used_Days__c',
                'Pending_Days__c', 'Unique_Key__c' }) {
            fields.add(fieldAccess(permSet.Id, 'Leave_Entitlement__c', field, false));
        }
        insert fields;
        return permSet;
    }

    private static Leave_Entitlement__c entitlement(Id employeeId, String leaveType, Integer year,
                                                    Decimal used, Decimal pending) {
        return new Leave_Entitlement__c(
            Employee__c = employeeId, Leave_Type__c = leaveType, Year__c = year,
            Entitled_Days__c = 20, Carry_Forward_Days__c = 0,
            Used_Days__c = used, Pending_Days__c = pending,
            Unique_Key__c = employeeId + '-' + leaveType + '-' + year
        );
    }

    private static Employee_Leave__c leave(Id employeeId, String leaveType, String status,
                                           Date startDate, Decimal days) {
        return new Employee_Leave__c(
            Employee__c = employeeId, Leave_Type__c = leaveType, Status__c = status,
            Start_Date__c = startDate, End_Date__c = startDate.addDays(1),
            Total_Days__c = days
        );
    }

    private static User getUser(String lastName) {
        return [SELECT Id FROM User WHERE LastName = :lastName LIMIT 1];
    }

    private static Leave_Entitlement__c getEnt(Id employeeId, String leaveType, Integer year) {
        return [SELECT Id, Used_Days__c, Pending_Days__c FROM Leave_Entitlement__c
                WHERE Employee__c = :employeeId AND Leave_Type__c = :leaveType
                  AND Year__c = :year LIMIT 1];
    }

    /** Insert leave rows with the trigger switched off (raw test data). */
    private static void insertWithoutRollup(List<Employee_Leave__c> rows) {
        EmployeeLeave_TriggerHandler.bypass = true;
        insert rows;
        EmployeeLeave_TriggerHandler.bypass = false;
    }

    @TestSetup
    static void setup() {
        User restricted = makeUser(RESTRICTED_LAST_NAME);
        User owner = makeUser(OWNER_LAST_NAME);
        User other = makeUser(OTHER_LAST_NAME);
        // Setup-object DML isolated in runAs to avoid Mixed DML.
        System.runAs(new User(Id = UserInfo.getUserId())) {
            insert new List<User>{ restricted, owner, other };
            PermissionSet permSet = createRestrictedSaverPermissionSet();
            insert new PermissionSetAssignment(AssigneeId = restricted.Id,
                                               PermissionSetId = permSet.Id);
        }
        // Balances are owned by the running admin: Private OWD means the
        // restricted saver can read none of them through sharing.
        insert new List<Leave_Entitlement__c>{
            entitlement(restricted.Id, 'Vacation', 2026, 0, 0),
            entitlement(owner.Id, 'Vacation', 2026, 0, 0),
            entitlement(owner.Id, 'Sick', 2026, 0, 0),
            entitlement(other.Id, 'Vacation', 2026, 0, 0)
        };
    }

    // ---- BalanceKey / keyFor -----------------------------------------

    // Expect: a null record cannot be keyed.
    @isTest static void testKeyForNullRecord() {
        System.assertEquals(null, LeaveBalanceService.keyFor(null), 'null record -> null key');
    }

    // Expect: rows missing Employee__c or Start_Date__c are skipped (null key).
    @isTest static void testKeyForIncompleteRows() {
        Id employeeId = getUser(OWNER_LAST_NAME).Id;
        Employee_Leave__c noEmployee = new Employee_Leave__c(
            Leave_Type__c = 'Vacation', Start_Date__c = Date.newInstance(2026, 1, 1));
        Employee_Leave__c noStart = new Employee_Leave__c(
            Employee__c = employeeId, Leave_Type__c = 'Vacation');
        System.assertEquals(null, LeaveBalanceService.keyFor(noEmployee), 'no employee -> null');
        System.assertEquals(null, LeaveBalanceService.keyFor(noStart), 'no start date -> null');
    }

    // Expect: the key uses the START year, even for leave ending next year.
    @isTest static void testKeyForUsesStartYear() {
        Id employeeId = getUser(OWNER_LAST_NAME).Id;
        Employee_Leave__c crossYear = new Employee_Leave__c(
            Employee__c = employeeId, Leave_Type__c = 'Vacation',
            Start_Date__c = Date.newInstance(2025, 12, 30),
            End_Date__c = Date.newInstance(2026, 1, 3));
        LeaveBalanceService.BalanceKey key = LeaveBalanceService.keyFor(crossYear);
        System.assertEquals(employeeId, key.employeeId, 'employee carried');
        System.assertEquals('Vacation', key.leaveType, 'type carried');
        System.assertEquals(2025, key.year, 'start-year allocation rule');
    }

    // Expect: keys compare case-insensitively on type and hash consistently.
    @isTest static void testBalanceKeyEqualityAndHash() {
        Id employeeId = getUser(OWNER_LAST_NAME).Id;
        LeaveBalanceService.BalanceKey lower =
            new LeaveBalanceService.BalanceKey(employeeId, 'vacation', 2026);
        LeaveBalanceService.BalanceKey upper =
            new LeaveBalanceService.BalanceKey(employeeId, 'VACATION', 2026);
        LeaveBalanceService.BalanceKey otherYear =
            new LeaveBalanceService.BalanceKey(employeeId, 'Vacation', 2025);
        System.assert(lower.equals(upper), 'case-insensitive equality');
        System.assertEquals(lower.hashCode(), upper.hashCode(), 'equal keys hash equally');
        System.assert(!lower.equals(otherYear), 'different year -> different key');
        System.assert(!lower.equals('not a key'), 'non-key object -> not equal');
        Set<LeaveBalanceService.BalanceKey> keys =
            new Set<LeaveBalanceService.BalanceKey>{ lower, upper };
        System.assertEquals(1, keys.size(), 'set de-duplicates equal keys');
    }

    // Expect: null leave type and null year are handled without errors.
    @isTest static void testBalanceKeyNullParts() {
        LeaveBalanceService.BalanceKey first = new LeaveBalanceService.BalanceKey(null, null, null);
        LeaveBalanceService.BalanceKey second = new LeaveBalanceService.BalanceKey(null, null, null);
        System.assert(first.equals(second), 'null parts compare equal');
        System.assert(first.toString().startsWith('BalanceKey['), 'readable toString');
    }

    // Expect: KeyComponents skips null keys and null years.
    @isTest static void testKeyComponents() {
        Id employeeId = getUser(OWNER_LAST_NAME).Id;
        Set<LeaveBalanceService.BalanceKey> keys = new Set<LeaveBalanceService.BalanceKey>{
            new LeaveBalanceService.BalanceKey(employeeId, 'Vacation', 2026),
            new LeaveBalanceService.BalanceKey(employeeId, 'Sick', null),
            null
        };
        LeaveBalanceService.KeyComponents parts = new LeaveBalanceService.KeyComponents(keys);
        System.assertEquals(1, parts.employeeIds.size(), 'one employee');
        System.assertEquals(2, parts.leaveTypes.size(), 'two types');
        System.assertEquals(new Set<Integer>{ 2026 }, parts.years, 'null year dropped');
        System.assertEquals(new Set<Decimal>{ 2026 }, parts.yearsAsDecimal, 'decimal years match');
    }

    // ---- computeTotals (user-mode, read-only) ------------------------

    // Expect: null or empty input returns an empty map.
    @isTest static void testComputeTotalsEmptyInput() {
        LeaveBalanceService service = new LeaveBalanceService();
        System.assert(service.computeTotals(null).isEmpty(), 'null -> empty');
        System.assert(service.computeTotals(new Set<LeaveBalanceService.BalanceKey>()).isEmpty(),
            'empty -> empty');
    }

    // Expect: Approved -> used, Pending -> pending, Rejected/Cancelled ignored,
    // and unrequested cross-product buckets dropped.
    @isTest static void testComputeTotalsByStatusAndRequestedOnly() {
        Id owner = getUser(OWNER_LAST_NAME).Id;
        Id other = getUser(OTHER_LAST_NAME).Id;
        Date day = Date.newInstance(2026, 3, 2);
        insertWithoutRollup(new List<Employee_Leave__c>{
            leave(owner, 'Vacation', 'Approved', day, 2),
            leave(owner, 'Vacation', 'Approved', day, 3),
            leave(owner, 'Vacation', 'Pending', day, 4),
            leave(owner, 'Vacation', 'Rejected', day, 7),
            leave(owner, 'Vacation', 'Cancelled', day, 9),
            leave(owner, 'Sick', 'Approved', day, 1),   // owner + Sick is NOT requested
            leave(other, 'Sick', 'Approved', day, 6)
        });
        LeaveBalanceService.BalanceKey ownerVacation =
            new LeaveBalanceService.BalanceKey(owner, 'Vacation', 2026);
        LeaveBalanceService.BalanceKey otherSick =
            new LeaveBalanceService.BalanceKey(other, 'Sick', 2026);

        Test.startTest();
        Map<LeaveBalanceService.BalanceKey, LeaveBalanceService.BalanceTotals> totals =
            new LeaveBalanceService().computeTotals(
                new Set<LeaveBalanceService.BalanceKey>{ ownerVacation, otherSick });
        Test.stopTest();

        System.assertEquals(2, totals.size(), 'only the two requested buckets');
        System.assertEquals(5, totals.get(ownerVacation).usedDays, 'approved 2 + 3');
        System.assertEquals(4, totals.get(ownerVacation).pendingDays, 'pending 4');
        System.assertEquals(6, totals.get(otherSick).usedDays, 'other sick 6');
        System.assert(!totals.containsKey(new LeaveBalanceService.BalanceKey(owner, 'Sick', 2026)),
            'unrequested bucket dropped');
    }

    // Expect: rows with blank Total_Days__c sum to zero, not null.
    @isTest static void testComputeTotalsBlankDays() {
        Id owner = getUser(OWNER_LAST_NAME).Id;
        insertWithoutRollup(new List<Employee_Leave__c>{
            leave(owner, 'Vacation', 'Pending', Date.newInstance(2026, 5, 4), null)
        });
        LeaveBalanceService.BalanceKey key =
            new LeaveBalanceService.BalanceKey(owner, 'Vacation', 2026);
        Map<LeaveBalanceService.BalanceKey, LeaveBalanceService.BalanceTotals> totals =
            new LeaveBalanceService().computeTotals(new Set<LeaveBalanceService.BalanceKey>{ key });
        System.assertEquals(0, totals.get(key).pendingDays, 'blank days count as 0');
    }

    // ---- getEntitlementSnapshot (user-mode, read-only) ---------------

    // Expect: null or empty input returns an empty map.
    @isTest static void testSnapshotEmptyInput() {
        LeaveBalanceService service = new LeaveBalanceService();
        System.assert(service.getEntitlementSnapshot(null).isEmpty(), 'null -> empty');
        System.assert(
            service.getEntitlementSnapshot(new Set<LeaveBalanceService.BalanceKey>()).isEmpty(),
            'empty -> empty');
    }

    // Expect: the admin sees exactly the requested balances.
    @isTest static void testSnapshotReturnsRequestedOnly() {
        Id owner = getUser(OWNER_LAST_NAME).Id;
        Id other = getUser(OTHER_LAST_NAME).Id;
        LeaveBalanceService.BalanceKey ownerSick =
            new LeaveBalanceService.BalanceKey(owner, 'Sick', 2026);
        LeaveBalanceService.BalanceKey otherVacation =
            new LeaveBalanceService.BalanceKey(other, 'Vacation', 2026);
        Map<LeaveBalanceService.BalanceKey, Leave_Entitlement__c> snapshot =
            new LeaveBalanceService().getEntitlementSnapshot(
                new Set<LeaveBalanceService.BalanceKey>{ ownerSick, otherVacation });
        System.assertEquals(2, snapshot.size(), 'owner Vacation (cross product) excluded');
        System.assert(snapshot.containsKey(ownerSick), 'owner sick returned');
        System.assert(snapshot.containsKey(otherVacation), 'other vacation returned');
    }

    // Expect: the snapshot respects sharing - the restricted user cannot see
    // admin-owned balances (Private OWD), proving it is unfit for writes.
    @isTest static void testSnapshotRespectsSharing() {
        User restricted = getUser(RESTRICTED_LAST_NAME);
        LeaveBalanceService.BalanceKey ownBalance =
            new LeaveBalanceService.BalanceKey(restricted.Id, 'Vacation', 2026);
        Map<LeaveBalanceService.BalanceKey, Leave_Entitlement__c> snapshot;
        Test.startTest();
        System.runAs(restricted) {
            snapshot = new LeaveBalanceService().getEntitlementSnapshot(
                new Set<LeaveBalanceService.BalanceKey>{ ownBalance });
        }
        Test.stopTest();
        System.assert(snapshot.isEmpty(), 'sharing hides the admin-owned balance');
    }

    // ---- LeaveBalanceRollupService (system mode) ---------------------

    // Expect: null, empty and all-null inputs are safe no-ops.
    @isTest static void testRollupNullAndEmptyInput() {
        Integer queriesBefore = Limits.getQueries();
        LeaveBalanceRollupService.recalculate(null);
        LeaveBalanceRollupService.recalculate(new Set<LeaveBalanceService.BalanceKey>());
        LeaveBalanceRollupService.recalculate(new Set<LeaveBalanceService.BalanceKey>{ null });
        System.assertEquals(queriesBefore, Limits.getQueries(), 'no query for empty input');
    }

    // Expect: a bucket with no balance record costs one query and no DML,
    // and no balance is auto-created.
    @isTest static void testRollupSkipsMissingBalance() {
        Id owner = getUser(OWNER_LAST_NAME).Id;
        Integer queriesBefore = Limits.getQueries();
        Integer dmlBefore = Limits.getDmlStatements();
        LeaveBalanceRollupService.recalculate(new Set<LeaveBalanceService.BalanceKey>{
            new LeaveBalanceService.BalanceKey(owner, 'Personal', 2026)
        });
        System.assertEquals(queriesBefore + 1, Limits.getQueries(),
            'lock query only, aggregate skipped');
        System.assertEquals(dmlBefore, Limits.getDmlStatements(), 'no DML');
        System.assertEquals(0, [SELECT COUNT() FROM Leave_Entitlement__c
                                WHERE Employee__c = :owner AND Leave_Type__c = 'Personal'],
            'no balance auto-created');
    }

    // Expect: a drifted balance is corrected to the true totals.
    @isTest static void testRollupCorrectsDriftedBalance() {
        Id owner = getUser(OWNER_LAST_NAME).Id;
        insertWithoutRollup(new List<Employee_Leave__c>{
            leave(owner, 'Vacation', 'Approved', Date.newInstance(2026, 6, 1), 3)
        });
        Leave_Entitlement__c drifted = getEnt(owner, 'Vacation', 2026);
        drifted.Used_Days__c = 99;
        drifted.Pending_Days__c = 42;
        update drifted;

        Test.startTest();
        LeaveBalanceRollupService.recalculate(new Set<LeaveBalanceService.BalanceKey>{
            new LeaveBalanceService.BalanceKey(owner, 'Vacation', 2026)
        });
        Test.stopTest();

        Leave_Entitlement__c fixed = getEnt(owner, 'Vacation', 2026);
        System.assertEquals(3, fixed.Used_Days__c, 'used corrected to 3');
        System.assertEquals(0, fixed.Pending_Days__c, 'pending reset to 0');
    }

    // Expect: an already-correct balance is not rewritten (no DML).
    @isTest static void testRollupNoChangeNoDml() {
        Id owner = getUser(OWNER_LAST_NAME).Id;
        Integer dmlBefore = Limits.getDmlStatements();
        LeaveBalanceRollupService.recalculate(new Set<LeaveBalanceService.BalanceKey>{
            new LeaveBalanceService.BalanceKey(owner, 'Vacation', 2026)
        });
        System.assertEquals(dmlBefore, Limits.getDmlStatements(), 'no DML when values match');
    }

    // Expect: only requested buckets are written, even when the lock query
    // returns cross-product balances.
    @isTest static void testRollupWritesRequestedBucketsOnly() {
        Id owner = getUser(OWNER_LAST_NAME).Id;
        Id other = getUser(OTHER_LAST_NAME).Id;
        Leave_Entitlement__c ownerVacation = getEnt(owner, 'Vacation', 2026);
        ownerVacation.Used_Days__c = 11;   // drift on an UNREQUESTED bucket
        update ownerVacation;

        Test.startTest();
        LeaveBalanceRollupService.recalculate(new Set<LeaveBalanceService.BalanceKey>{
            new LeaveBalanceService.BalanceKey(owner, 'Sick', 2026),
            new LeaveBalanceService.BalanceKey(other, 'Vacation', 2026)
        });
        Test.stopTest();

        System.assertEquals(11, getEnt(owner, 'Vacation', 2026).Used_Days__c,
            'unrequested bucket left untouched');
    }

    // ---- restricted saver (read-only balance access) -----------------

    // Expect: an employee with READ-ONLY balance access can save their own
    // leave, and the balance still updates (system-mode rollup write).
    @isTest static void testRestrictedSaverCanSaveLeave() {
        User restricted = getUser(RESTRICTED_LAST_NAME);
        Test.startTest();
        System.runAs(restricted) {
            insert leave(restricted.Id, 'Vacation', 'Pending', Date.newInstance(2026, 7, 6), 2);
        }
        Test.stopTest();
        Leave_Entitlement__c balance = getEnt(restricted.Id, 'Vacation', 2026);
        System.assertEquals(2, balance.Pending_Days__c, 'balance updated despite read-only access');
    }

    // Expect: the restricted saver's totals include leave rows created by
    // someone else (system-mode totals, not the saver's own view).
    @isTest static void testRestrictedSaverTotalsIncludeOthersRows() {
        User restricted = getUser(RESTRICTED_LAST_NAME);
        // Admin-created approved leave for the same employee + bucket.
        insertWithoutRollup(new List<Employee_Leave__c>{
            leave(restricted.Id, 'Vacation', 'Approved', Date.newInstance(2026, 1, 12), 5)
        });
        Test.startTest();
        System.runAs(restricted) {
            insert leave(restricted.Id, 'Vacation', 'Approved', Date.newInstance(2026, 8, 3), 1);
        }
        Test.stopTest();
        System.assertEquals(6, getEnt(restricted.Id, 'Vacation', 2026).Used_Days__c,
            'admin 5 + own 1');
    }

    // Expect: a 200-row save by the restricted saver stays within limits.
    @isTest static void testRestrictedSaverBulk() {
        User restricted = getUser(RESTRICTED_LAST_NAME);
        List<Employee_Leave__c> batch = new List<Employee_Leave__c>();
        for (Integer i = 0; i < 200; i++) {
            batch.add(leave(restricted.Id, 'Vacation', 'Approved', Date.newInstance(2026, 9, 1), 1));
        }
        Test.startTest();
        System.runAs(restricted) {
            insert batch;
            System.assert(Limits.getQueries() <= 10, 'bulk-safe SOQL, got ' + Limits.getQueries());
        }
        Test.stopTest();
        System.assertEquals(200, getEnt(restricted.Id, 'Vacation', 2026).Used_Days__c, '200 used');
    }

    // ---- trigger handler switches ------------------------------------

    // Expect: the kill-switch disables the rollup entirely.
    @isTest static void testBypassSkipsRollup() {
        Id owner = getUser(OWNER_LAST_NAME).Id;
        Test.startTest();
        EmployeeLeave_TriggerHandler.bypass = true;
        insert leave(owner, 'Vacation', 'Approved', Date.newInstance(2026, 2, 2), 4);
        EmployeeLeave_TriggerHandler.bypass = false;
        Test.stopTest();
        System.assertEquals(0, getEnt(owner, 'Vacation', 2026).Used_Days__c, 'bypassed: no rollup');
    }

    // Expect: the re-run guard blocks re-entrant execution.
    @isTest static void testReentryGuardSkipsRollup() {
        Id owner = getUser(OWNER_LAST_NAME).Id;
        Test.startTest();
        EmployeeLeave_TriggerHandler.isProcessing = true;
        insert leave(owner, 'Vacation', 'Approved', Date.newInstance(2026, 2, 2), 4);
        EmployeeLeave_TriggerHandler.isProcessing = false;
        Test.stopTest();
        System.assertEquals(0, getEnt(owner, 'Vacation', 2026).Used_Days__c, 'guarded: no rollup');
    }
}
