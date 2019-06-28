@isTest
public class BuyProductControllerTest {
    @testSetup
    static void methodName() {
        insert new Org_Configuration__c(Period_Term__c = 10);
    }
    @isTest
    public static void testGetProduct (){
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

    }
    @isTest
    public static void testBuck (){
        Product_Table__c prod = new Product_Table__c (Name = 'TestPhone', Added_Date__c = System.today());
        insert prod;

        Test.startTest();
        PageReference pageRef = Page.BuyProduct;
        pageRef.getParameters().put('id', String.valueOf(prod.Id));
        pageRef.getParameters().put('returnPage','ProductList');
        Test.setCurrentPage(pageRef);
        BuyProductController testController = new BuyProductController();
        PageReference newPage = testController.back();
        System.assertEquals('/apex/ProductList', newPage.getUrl());

        Test.stopTest();

    }
}