@isTest
public class MaintenanceRequestHelperTest {
    
    //DATA CREATION

    private static final String STATUS_NEW = 'New';
    private static final String REPAIR = 'Repair';
    private static final String WORKING = 'Working';
    private static final String CLOSED = 'Closed';
    private static final String REQUEST_TYPE = 'Routine Maintenance';
    private static final String REQUEST_ORIGIN = 'Web';
    private static final String REQUEST_SUBJECT = 'Subject_Test';

    private static Product2 cEquipment(){
        Product2 e = new Product2(Name = 'Equipment test',
                                    Lifespan_Months__c = 10,
                                    Maintenance_Cycle__c = 10,
                                    Replacement_Part__c = true);
        return e;
    }

    private static Vehicle__c cVehicle(){
        Vehicle__c v = new Vehicle__c(Name = 'Vehicle_test');
        return v;
    }

    private static Case cMTRequest(Id vId, Id eId){
        case c = new Case(Vehicle__c = vId,
                            Type = REPAIR,
                            Status = STATUS_NEW,
                            Equipment__c = eId,
                            Subject = REQUEST_SUBJECT,
                            Origin = REQUEST_ORIGIN);
        return c;
    }

    private static Equipment_Maintenance_Item__c createWorkPart(Id eId, Id rId){
        Equipment_Maintenance_Item__c EQT = new Equipment_Maintenance_Item__c(Equipment__c = eId,
                                                                                Maintenance_Request__c = rId);
        return EQT;
    }

    @isTest
    private static void testMaintenanceRequestPositive(){
        Product2 e = cEquipment();
        insert e;
        Id eId = e.Id;

        Vehicle__c v = cVehicle();
        Id vId = v.Id;

        Case u = cMTRequest(vId, eId);
        insert u;

        Equipment_Maintenance_Item__c EQT = createWorkPart(eId, u.Id);
        insert EQT;

        Test.startTest();
        u.Status = CLOSED;
        update u;
        Test.stopTest();

        Case newCase = [SELECT id, subject, type, Equipment__c, Date_Reported__c, Vehicle__c, Date_Due__c
                        FROM case
                        WHERE status = :STATUS_NEW];

        Equipment_Maintenance_Item__c Parts = [SELECT id
                                                FROM Equipment_Maintenance_Item__c
                                                WHERE Maintenance_Request__c =:newCase.Id];

        System.assertEquals(newCase.Vehicle__c, vId);
        System.assertEquals(newCase.Equipment__c, eId);
        System.assert(newCase.Subject != null);
        System.assertEquals(newCase.Type, REQUEST_TYPE);
        System.assert(Parts != null);
        System.assertEquals(newCase.Date_Reported__c, System.today());

    }

}