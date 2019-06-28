@isTest
public class ProductTableTriggerTest {
    @testSetup
    static void methodName() {
        insert new Org_Configuration__c(Period_Term__c = 10);
    }
    @isTest
    static void testGetWarehouseForProduct() {
        Org_Configuration__c perOrg = Org_Configuration__c.getOrgDefaults();
        List<Product_Table__c> listProductTable = new List<Product_Table__c>();
        Date dt = System.today();
        dt.addDays(1);
        Product_Table__c prod = new Product_Table__c (Name = 'TestPhoneOne', Added_Date__c = dt);
        Warehouse__c warehouse = new Warehouse__c (Name = 'Warehouse' + prod.Added_Date__c + ' ' + perOrg.Period_Term__c,
                Period_Start__c = System.today(),
                Period_End__c = System.today().addMonths(1));
        listProductTable.add(prod);
        for (Integer i = 0; i < 5; i++) {
            listProductTable.add(new Product_Table__c (Name = 'TestPhoneOne:' + i,
                    Added_Date__c = dt.addMonths(i + 2)));
        }

        insert warehouse;

        Test.startTest();
        insert prod;
        Test.stopTest();

        Product_Table__c pr = new Product_Table__c ();
        pr = [
                SELECT Id, Warehouse__c
                FROM Product_Table__c
                WHERE Id = :prod.Id
        ];

        System.assertEquals(warehouse.Id, pr.Warehouse__c);

    }
    @isTest
    static void testCreateWarehouseForProduct() {
        Date dt;
        dt = System.today();
        dt.addDays(1);
        Product_Table__c prod = new Product_Table__c (Name = 'TestPhoneOne', Added_Date__c = dt);
        Test.startTest();
        insert prod;
        Test.stopTest();

        Product_Table__c pr = new Product_Table__c ();
        pr = [
                SELECT Id, Warehouse__c
                FROM Product_Table__c
                WHERE Id = :prod.Id
        ];

        System.assertNotEquals(Null, pr.Warehouse__c);

    }
}