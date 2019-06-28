public class BuyProductController {
    public String firstName { get; set; }
    public String lastName { get; set; }
    public String email { get; set; }
    public String message { get; set; }
    public String errorMessage { get; set; }
    public Integer count { get; set; }
    public String productId;
    public String returnPage;
    public Product_Table__c product = new Product_Table__c ();

    public static Boolean validateEmail(String email) {
        Boolean res = true;
        String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';
        Pattern myPattern = Pattern.compile(emailRegex);
        Matcher myMatcher = myPattern.matcher(email);
        if (!myMatcher.matches()) {
            res = false;
        }
        return res;
    }

    public BuyProductController() {
        productId = ApexPages.currentPage().getParameters().get('Id');
        returnPage = ApexPages.currentPage().getParameters().get('ReturnPage');
        product = [
                SELECT Id, Name, Unit_Price__c, Units_Available__c
                FROM Product_Table__c
                WHERE Id = :productId
        ];
    }

    public Product_Table__c getProduct() {
        return product;
    }

    public void buyProduct() {
        message = '';
        errorMessage = '';
        List<Contact> listCont = new List<Contact> ();

        if (String.isNotBlank(firstName) &&
                String.isNotBlank(lastName) &&
                validateEmail(email) &&
                count > 0 &&
                count < product.Units_Available__c) {
            listCont.addAll([
                    SELECT FirstName, LastName, Email
                    FROM Contact
                    WHERE Email = :email
                    LIMIT 1
            ]);
            Contact cont = new Contact();
            if (!listCont.isEmpty()) {
                cont = listCont.get(0);
            }
            if (cont.Email != email) {
                cont.FirstName = firstName;
                cont.LastName = lastName;
                cont.Email = email;
                insert cont;
            } else {
                cont.FirstName = firstName;
                cont.LastName = lastName;
                update cont;
            }
            Order_Table__c order = new Order_Table__c ();
            order.Product__c = product.Id;
            order.Units__c = count;
            order.Order_Amount__c = count * product.Unit_Price__c;
            order.Contact__c = cont.Id;
            if (order.Units__c <= product.Units_Available__c) {
                product.Units_Available__c -= order.Units__c;
                update product;
                insert order;
                message = 'Success! Product purchased';
            }
        } else {
            if (count <= 0) {
                errorMessage = 'Error. The field "Unit Count" cannot be less than 1';
            } else if (count > product.Units_Available__c) {
                errorMessage = 'Error. The available units of the item in warehouse are less than number units entered for purchase';
            } else if (!validateEmail(email)) {
                errorMessage = 'Error. The field "Email" is not valid. Example: name@Gmail.com';
            } else if (String.isBlank(firstName)) {
                errorMessage = 'Error. The field "First Name" are not filled';
            } else if (String.isBlank(lastName)) {
                errorMessage = 'Error. The field "Last Name" are not filled';
            }
        }
    }
    public PageReference back() {
        PageReference newocp = null;
        if (returnPage == 'Product') {
            newocp = new PageReference('/apex/' + returnPage + '?Id=' + productId);
            newocp.getParameters().put('returnPage', 'BuyProduct');
        }
        if (returnPage == 'ProductList') {
            newocp = new PageReference('/apex/' + returnPage );
        }

        newocp.setRedirect(true);
        return newocp;

    }
}