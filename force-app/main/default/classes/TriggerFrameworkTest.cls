@IsTest
public class TriggerFrameworkTest {
    public class TestHandler extends TriggerHandler {
    }

    static TriggerFramework.TriggerWrapper getTestTriggerWrapper(
        String operationName
    ) {
        TriggerFramework.TriggerWrapper result = new TriggerFramework.TriggerWrapper();
        result.currentSObjectType = Account.SObjectType;
        result.newRecordItems = new List<Account>{ new Account(Name = 'test') };
        result.oldRecordItems = new List<Account>{ new Account(Name = 'test') };
        result.operationName = operationName;
        result.getCurrentSObjectType();
        return result;
    }

    static List<TriggerHandler__mdt> getTestTriggerHandlerNames() {
        return new List<TriggerHandler__mdt>{
            new TriggerHandler__mdt(
                DeveloperName = 'TriggerFrameworkTest.TestHandler'
            )
        };
    }

    @IsTest
    static void test_beforeInsert() {
        TriggerFramework.isTriggerFrameworkTest = true;
        TriggerFramework.testTriggerWrapper = getTestTriggerWrapper(
            'BEFORE_INSERT'
        );
        TriggerFramework.testTriggerHandlerRecords = getTestTriggerHandlerNames();
        TriggerFramework.handleRecords();
    }

    @IsTest
    static void test_beforeUpdate() {
        TriggerFramework.isTriggerFrameworkTest = true;
        TriggerFramework.testTriggerWrapper = getTestTriggerWrapper(
            'BEFORE_UPDATE'
        );
        TriggerFramework.testTriggerHandlerRecords = getTestTriggerHandlerNames();
        TriggerFramework.handleRecords();
    }

    @IsTest
    static void test_beforeDelete() {
        TriggerFramework.isTriggerFrameworkTest = true;
        TriggerFramework.testTriggerWrapper = getTestTriggerWrapper(
            'BEFORE_DELETE'
        );
        TriggerFramework.testTriggerHandlerRecords = getTestTriggerHandlerNames();
        TriggerFramework.handleRecords();
    }

    @IsTest
    static void test_afterInsert() {
        TriggerFramework.isTriggerFrameworkTest = true;
        TriggerFramework.testTriggerWrapper = getTestTriggerWrapper(
            'AFTER_INSERT'
        );
        TriggerFramework.testTriggerHandlerRecords = getTestTriggerHandlerNames();
        TriggerFramework.handleRecords();
    }

    @IsTest
    static void test_afterUpdate() {
        TriggerFramework.isTriggerFrameworkTest = true;
        TriggerFramework.testTriggerWrapper = getTestTriggerWrapper(
            'AFTER_UPDATE'
        );
        TriggerFramework.testTriggerHandlerRecords = getTestTriggerHandlerNames();
        TriggerFramework.handleRecords();
    }

    @IsTest
    static void test_afterDelete() {
        TriggerFramework.isTriggerFrameworkTest = true;
        TriggerFramework.testTriggerWrapper = getTestTriggerWrapper(
            'AFTER_DELETE'
        );
        TriggerFramework.testTriggerHandlerRecords = getTestTriggerHandlerNames();
        TriggerFramework.handleRecords();
    }

    @IsTest
    static void test_afterUndelete() {
        TriggerFramework.isTriggerFrameworkTest = true;
        TriggerFramework.testTriggerWrapper = getTestTriggerWrapper(
            'AFTER_UNDELETE'
        );
        TriggerFramework.testTriggerHandlerRecords = getTestTriggerHandlerNames();
        TriggerFramework.handleRecords();
    }
}
