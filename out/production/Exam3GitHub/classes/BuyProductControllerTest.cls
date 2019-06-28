@isTest
public class BuyProductControllerTest {
    @isTest
    public static void testGetProduct (){
        insert new Org_Configuration__c(Period_Term__c = 10);
        Product_Table__c prod = new Product_Table__c (Name = 'TestPhone', Added_Date__c = System.today());
        insert prod;
        Test.startTest();
        PageReference pageRef = Page.BuyProduct;
        pageRef.getParameters().put('id', String.valueOf(prod.Id));
        Test.setCurrentPage(pageRef);

        BuyProductController testController = new BuyProductController();
        System.assertEquals(prod.Id, testController.getProduct().Id);

        Test.stopTest();
    }

    @isTest
    public static void testBuyProductNewContact (){
        insert new Org_Configuration__c(Period_Term__c = 10);
        Product_Table__c prod = new Product_Table__c (
                Name = 'TestPhone',
                Units_Available__c = 30,
                Unit_Price__c = 200,
                Added_Date__c = System.today()
        );
        insert prod;

        Test.startTest();
        PageReference pageRef = Page.BuyProduct;
        pageRef.getParameters().put('id', String.valueOf(prod.Id));
        Test.setCurrentPage(pageRef);
        BuyProductController testController = new BuyProductController();
        testController.firstName = 'TestFirstName';
        testController.lastName = 'TestLastName';
        testController.email = 'TestEmail@mail.ru';
        testController.count = 10;
        testController.buyProduct ();
        Test.stopTest();

        Product_Table__c product = new Product_Table__c ();
        product = [SELECT Id, Name, Unit_Price__c, Units_Available__c
        FROM Product_Table__c
        WHERE Id = :prod.Id];
        System.assertEquals((prod.Units_Available__c - testController.count), product.Units_Available__c);
        testController.back();
    }
}