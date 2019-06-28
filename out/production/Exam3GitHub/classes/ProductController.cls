public class ProductController {
    public String productId;
    public Product_Table__c product {
        get {
            if (product == null) {
                product = [
                        SELECT Id, Image_Url__c, Product_Description__c, Name, Unit_Price__c, Title__c, Units_Available__c
                        FROM Product_Table__c
                        WHERE Id = :productId
                ];
            }
            return product;
        }
        set;
    }
    public ProductController() {
        productId = ApexPages.currentPage().getParameters().get('Id');
    }
    public PageReference back() {
        String returnPage = ApexPages.currentPage().getParameters().get('ReturnPage');
        PageReference newocp = null;
        if (returnPage == 'ProductList') {
            newocp = new PageReference('/apex/' + returnPage );
        }
        if (returnPage == 'BuyProduct') {
            newocp = new PageReference('/apex/ProductList');

        }
        newocp.setRedirect(true);
        return newocp;

    }
}