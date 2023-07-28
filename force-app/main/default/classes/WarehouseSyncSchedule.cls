global with sharing class WarehouseSyncSchedule implements Schedulable{

    //To schedule the job go to the organization
    //Got to Setup -> Search for Apex Classes
    //Enter Job Name, Select the Batch Apex class and the Frequency in this case
    //Everyday at 1:00

    global void execute(SchedulableContext ctx){
        System.enqueueJob(new WarehouseCalloutService());
    }
}