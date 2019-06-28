trigger ProductTableTrigger on Product_Table__c (before insert) {

    if (Trigger.isBefore && Trigger.isInsert){
        ProductTableTriggerHandler.checkWarehouse((List<Product_Table__c>) Trigger.new);
    }
    
}