public class ProductListController {
    public List <Product_Table__c> productList {
        get {
            if (productList == null || productList.isEmpty()) {
                productList = new List <Product_Table__c>();
                productList = [
                        SELECT Id, Image_Url__c, Product_Description__c, Name, Unit_Price__c, Title__c
                        FROM Product_Table__c
                        WHERE Image_Url__c != null AND Unit_Price__c != null AND Title__c != null
                ];

                for (Integer i = 0; i < productList.size(); i++) {
                    if (String.isBlank(productList[i].Product_Description__c)) {
                        productList.remove(i);
                    } else if (productList[i].Product_Description__c.length() > 100) {
                        productList[i].Product_Description__c = productList[i].Product_Description__c.substring(0, 100) + '... ';
                    }
                }
            }
            return productList;
        }
        set;
    }
}