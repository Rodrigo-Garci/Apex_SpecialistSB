public with sharing class WarehouseCalloutService{

    //class that makes a REST callout to an external warehouse system to get a list of equipment that needs to be updated.
    //The callout’s JSON response returns the equipment records that you upsert in Salesforce. 

    //We obtain the static URL for the warehouse
    //Endpoint must be added in Remote Site Setting within your organization
    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';

    //@future(callout=true)
    public static void runWarehouseEquipmentSync(){
        Http http = new Http();
        HttpRequest req = new HttpRequest();

        req.setEndpoint(WAREHOUSE_URL);
        req.setMethod('GET');

        HttpResponse res = http.send(req);

        List<Product2> warehouseEquip = new List<Product2>();

        //Meaning that if the response was succesful
        if(res.getStatusCode() == 200){
            List<Object> jsonRes = (List<Object>)JSON.deserializeUntyped(res.getBody());
            system.debug(jsonRes);
            system.debug(res.getBody());

            /* Your class maps the following fields:
                    Replacement part (always true)
                    Cost
                    Current inventory
                    Lifespan
                    Maintenance cycle
                    Warehouse SKU
                Use the warehouse SKU as the external ID to identify which equipment records to update within Salesforce.
            */

            for (Object equipment : jsonRes) {
                Map<String, Object> mapJSON = (Map<String,Object>)equipment;
                Product2 myEquipment = new Product2();
                myEquipment.Replacement_Part__c = (Boolean) mapJSON.get('replacement');
                myEquipment.Cost__c = (Integer) mapJSON.get('cost');
                myEquipment.Current_Inventory__c = (Double) mapJSON.get('quantity');
                myEquipment.Lifespan_Months__c = (Integer) mapJSON.get('lifespan');
                myEquipment.Maintenance_Cycle__c = (Integer) mapJSON.get('maintenanceperiod');
                myEquipment.Warehouse_SKU__c = (String) mapJSON.get('sku');

                warehouseEquip.add(myEquipment);

            }

            if (!warehouseEquip.isEmpty()) {
                upsert warehouseEquip;
            }

        }
    }

    // public static void execute (QueueableContext context){
    //     runWarehouseEquipmentSync();
    // }
}