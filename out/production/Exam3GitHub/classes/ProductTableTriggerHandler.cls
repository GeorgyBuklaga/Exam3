public class ProductTableTriggerHandler {

    public static void checkWarehouse(List<Product_Table__c> productTableList) {
        Org_Configuration__c perOrg = Org_Configuration__c.getOrgDefaults();
        List<Warehouse__c> warlist = new List<Warehouse__c>();
        Map<String, Product_Table__c> mapWarhousNameToProd = new Map<String, Product_Table__c>();
        List<Date> listAddedDateProductTable = new List<Date>();

        for (Integer i = 0; i < productTableList.size(); i++) {
            if (productTableList[i].Added_Date__c == null) {
                productTableList[i].Added_Date__c = System.today();
            }
            listAddedDateProductTable.add(productTableList[i].Added_Date__c);
        }
        listAddedDateProductTable.sort();
        List<Warehouse__c> warlistOld = new List<Warehouse__c>([
                SELECT Id, Period_Start__c, Period_End__c
                FROM Warehouse__c
                WHERE Period_End__c >= :listAddedDateProductTable[0]
                AND Period_Start__c <= :listAddedDateProductTable[listAddedDateProductTable.size() - 1]
        ]);
        for (Product_Table__c prod : productTableList) {
            for (Warehouse__c war : warlistOld) {
                if ((war.Period_Start__c < prod.Added_Date__c &&
                        war.Period_End__c >= prod.Added_Date__c) ||
                        war.Period_Start__c.isSameDay(prod.Added_Date__c)) {
                    prod.Warehouse__c = war.Id;
                    break;
                }
            }
            if (prod.Warehouse__c == NULL) {
                Warehouse__c warehouse = new Warehouse__c ();
                warehouse.Name = 'Warehouse ' + prod.Added_Date__c.format() + ' ' + prod.Added_Date__c.addDays((integer) perOrg.Period_Term__c).format();
                warehouse.Period_Start__c = prod.Added_Date__c;
                warehouse.Period_End__c = prod.Added_Date__c.addDays((integer) perOrg.Period_Term__c);
                mapWarhousNameToProd.put(warehouse.Name, prod);
                warlist.add(warehouse);
            }
        }
        try {
            if (!warlist.isEmpty()) {
                insert warlist;
            }
        } catch (DmlException ex) {
            for (Integer i = 0; i < ex.getNumDml(); i++) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getDmlMessage(i)));
            }
        }
        for (Warehouse__c war : warlist) {

            if (mapWarhousNameToProd.containsKey(war.Name)) {
                mapWarhousNameToProd.get(war.Name).Warehouse__c = war.Id;
            }
        }

    }

}