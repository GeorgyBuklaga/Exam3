@isTest
public class ProductListControllerTest {

    @testSetup
    static void methodName() {
        insert new Org_Configuration__c(Period_Term__c = 10);
    }

    @IsTest
    public static void testGetProducts() {
        List<Product_Table__c> prod = new List<Product_Table__c> ();
        Product_Table__c p = new Product_Table__c (
                Name = 'TestPhone',
                Product_Description__c = 'Test text with some text ... and more than 100 ' +
                        '........................................................................................',
                Added_Date__c = System.today(),
                Unit_Price__c = 100,
                Title__c = 'test text',
                Image_Url__c = 'https://content2.onliner.by/catalog/device/header/98b65279323ea2beeba0c347f365f728.jpeg'
        );
        prod.add(p);
        insert prod;

        Test.startTest();
        ProductListController testController = new ProductListController();
        System.assertEquals(prod.get(0).Id, testController.productList.get(0).Id);
        System.assertEquals(1, testController.productList.size());
        Test.stopTest();
    }

    @IsTest
    public static void testGetProductsWithoutProductDescription () {
        Product_Table__c prod = new Product_Table__c (
                Name = 'TestPhone',
                Added_Date__c = System.today(),
                Unit_Price__c = 100,
                Title__c = 'test text',
                Image_Url__c = 'https://content2.onliner.by/catalog/device/header/98b65279323ea2beeba0c347f365f728.jpeg'
        );
        insert prod;

        Test.startTest();
        ProductListController testController = new ProductListController();
        System.assertEquals(0, testController.productList.size());
        Test.stopTest();
    }
}