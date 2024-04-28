public virtual class TriggerHandler {
    public List<SObject> newRecordItems;
    public List<SObject> oldRecordItems;
    public Map<Id, SObject> oldRecordMap;
    public Map<Id, SObject> newRecordMap;

    public virtual void beforeInsert() {
    }

    public virtual void afterInsert() {
    }

    public virtual void beforeUpdate() {
    }

    public virtual void afterUpdate() {
    }

    public virtual void beforeDelete() {
    }

    public virtual void afterDelete() {
    }

    public virtual void afterUndelete() {
    }
}
