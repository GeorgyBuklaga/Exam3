@isTest
public class ProductControllerTest {
    @testSetup
    static void methodName() {
        insert new Org_Configuration__c(Period_Term__c = 10);
    }
    @IsTest public static void testGetProduct() {
        Product_Table__c prod = new Product_Table__c (Name = 'TestPhone', Added_Date__c = System.today());
        insert prod;
        Test.startTest();
        PageReference pageRef = Page.Product;
        pageRef.getParameters().put('id', String.valueOf(prod.Id));
        Test.setCurrentPage(pageRef);

        ProductController testController = new ProductController();
        System.assertEquals(prod.Id, testController.product.Id);


        Test.stopTest();
    }
    @isTest
    public static void testBuck (){
        Product_Table__c prod = new Product_Table__c (Name = 'TestPhone', Added_Date__c = System.today());
        insert prod;

        Test.startTest();
        PageReference pageRef = Page.Product;
        pageRef.getParameters().put('id', String.valueOf(prod.Id));
        pageRef.getParameters().put('returnPage','ProductList');
        Test.setCurrentPage(pageRef);

        BuyProductController testController = new BuyProductController();
        PageReference newPage = testController.back();
        System.assertEquals('/apex/ProductList', newPage.getUrl());

        Test.stopTest();

    }
}