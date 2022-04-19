@isTest
public class ucl_TestSchedule {

        // Para ver los Jobs en la consola 
    //List<CronTrigger> lt = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger];
    //System.debug('TASKS: '+ lt);

   static testmethod void test() {
   Test.startTest();

      // Schedule the test job
      
      ucl_ScheduleLegalAdvisorAndClients job = new ucl_ScheduleLegalAdvisorAndClients();
      String sch = '0 0 13 * * ?';
       
      String jobId = System.schedule('Test_ucl_Scheduled_LegalAdvisor', sch, job);

      // Get the information from the CronTrigger API object
      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
         NextFireTime
         FROM CronTrigger WHERE id = :jobId];

      // Verify the expressions are the same
      System.assertEquals(sch, 
         ct.CronExpression);

      // Verify the job has not run
      System.assertEquals(0, ct.TimesTriggered);

      // Verify the next time the job will run
     // System.assertEquals('2022-09-03 00:00:00', 
       //  String.valueOf(ct.NextFireTime));
      
   Test.stopTest();

   //System.assertEquals('Test_ucl_Scheduled_LegalAdvisor',[SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger]);
   String status = [SELECT Id, CronExpression, TimesTriggered, 
         NextFireTime,CronJobDetail.Name,CronJobDetail.Id,State
         FROM CronTrigger  WHERE id = :jobId].State;
   System.assertEquals('WAITING',status);

   }

}