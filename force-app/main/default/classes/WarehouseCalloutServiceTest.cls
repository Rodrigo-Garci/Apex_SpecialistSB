@isTest
private class WarehouseCalloutServiceTest {

    @isTest
    static void testRunWarehouseEquipmentSync(){
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());

        Test.startTest();
        WarehouseCalloutService.runWarehouseEquipmentSync();
        test.stopTest();

        system.assertEquals(3, [SELECT count() FROM Product2]);
    }

}