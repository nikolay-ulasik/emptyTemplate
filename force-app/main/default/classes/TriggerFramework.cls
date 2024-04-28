public with sharing class TriggerFramework {
    private static final Set<String> DELETE_TRIGGER_OPERATION_NAMES = new Set<String>{
        'AFTER_DELETE',
        'BEFORE_DELETE'
    };

    @TestVisible
    private static Boolean isTriggerFrameworkTest = false;

    private static Boolean isRunningTest {
        get {
            return Test.isRunningTest() && isTriggerFrameworkTest;
        }
    }

    @TestVisible
    private static TriggerWrapper testTriggerWrapper;

    @TestVisible
    private static List<TriggerHandler__mdt> testTriggerHandlerRecords;

    @TestVisible
    private class TriggerWrapper {
        public List<SObject> newRecordItems;
        public List<SObject> oldRecordItems;
        public Map<Id, SObject> newRecordMap;
        public Map<Id, SObject> oldRecordMap;

        public SObjectType currentSObjectType;
        public String operationName;

        public TriggerWrapper() {
            this.newRecordItems = Trigger.isExecuting ? Trigger.new : null;
            this.oldRecordItems = Trigger.isExecuting ? Trigger.old : null;
            this.newRecordMap = Trigger.isExecuting ? Trigger.newMap : null;
            this.oldRecordMap = Trigger.isExecuting ? Trigger.oldMap : null;
            this.operationName = Trigger.isExecuting
                ? Trigger.operationType.name()
                : null;
            this.currentSObjectType = getCurrentSObjectType();
        }

        @TestVisible
        private SObjectType getCurrentSObjectType() {
            List<SObject> recordItems = DELETE_TRIGGER_OPERATION_NAMES.contains(
                    this.operationName
                )
                ? this.oldRecordItems
                : this.newRecordItems;
            return (recordItems != null)
                ? recordItems.get(0).getSObjectType()
                : null;
        }
    }

    public static void handleRecords() {
        TriggerWrapper currentTrigger = (!isRunningTest)
            ? new TriggerWrapper()
            : testTriggerWrapper;

        List<String> triggerHandlerNames = getTriggerHandlerNames(
            currentTrigger.currentSObjectType.getDescribe().getName()
        );
        if (!triggerHandlerNames.isEmpty()) {
            for (String triggerHandlerName : triggerHandlerNames) {
                Type triggerHandlerType = Type.forName(triggerHandlerName);
                if (triggerHandlerType != null) {
                    TriggerHandler triggerHandlerInstance = (TriggerHandler) triggerHandlerType.newInstance();
                    callMethodFromTriggerHandler(
                        triggerHandlerInstance,
                        currentTrigger
                    );
                }
            }
        }
    }

    private static void callMethodFromTriggerHandler(
        TriggerHandler triggerHandlerInstance,
        TriggerWrapper currentTrigger
    ) {
        triggerHandlerInstance.newRecordItems = currentTrigger.newRecordItems;
        triggerHandlerInstance.oldRecordItems = currentTrigger.oldRecordItems;
        triggerHandlerInstance.newRecordMap = currentTrigger.newRecordMap;
        triggerHandlerInstance.oldRecordMap = currentTrigger.oldRecordMap;

        switch on currentTrigger.operationName {
            when 'BEFORE_INSERT' {
                triggerHandlerInstance.beforeInsert();
            }
            when 'BEFORE_UPDATE' {
                triggerHandlerInstance.beforeUpdate();
            }
            when 'BEFORE_DELETE' {
                triggerHandlerInstance.beforeDelete();
            }
            when 'AFTER_INSERT' {
                triggerHandlerInstance.afterInsert();
            }
            when 'AFTER_UPDATE' {
                triggerHandlerInstance.afterUpdate();
            }
            when 'AFTER_DELETE' {
                triggerHandlerInstance.afterDelete();
            }
            when 'AFTER_UNDELETE' {
                triggerHandlerInstance.afterUndelete();
            }
        }
    }

    private static List<String> getTriggerHandlerNames(String sObjectName) {
        List<String> result = new List<String>();

        List<TriggerHandler__mdt> triggerHandlerRecords = [
            SELECT DeveloperName
            FROM TriggerHandler__mdt
            WHERE
                SobjectType__r.QualifiedApiName = :sObjectName
                AND IsActive__c = TRUE
            ORDER BY DeveloperName, Order__c
        ];

        triggerHandlerRecords = (!isRunningTest)
            ? triggerHandlerRecords
            : testTriggerHandlerRecords;

        for (TriggerHandler__mdt triggerHandlerRecord : triggerHandlerRecords) {
            result.add(triggerHandlerRecord.DeveloperName);
        }

        return result;
    }
}
