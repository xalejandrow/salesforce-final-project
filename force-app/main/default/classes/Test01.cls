@isTest
public class Test01 {
	
    @isTest
    static void testDeleteAll(){
        ucl_HerokuApiHandler.deleteAll();
    }
    
    @isTest
    static void testCallApi(){
        ucl_HerokuApiHandler.getHerokuData();
    }
    
    @isTest
    private static void testLegalAdvisorEnabled(){
        
     	StaticResource sr = [SELECT Id, Body FROM StaticResource WHERE Name = 'LegalAdvisorClientEnabled']; 
        String body = sr.Body.toString();
               
        ucl_HerokuApiHandler.insertHerokuData(body);
        
        String laNum = '651cbb19-dbcd-4978-99f5-71b235429d28';
		String cliNum  =  '78270901-768d-4c99-a72a-18dfde5839f1';
		String num = laNum + cliNum;
		List<Client__c> clients = [SELECT id, Client_Number__c, Created_By_Admin__c,Legal_Advisor__c 
                                            FROM Client__c WHERE Client_Number__c =: num ];
		String actual = clients[0].Client_Number__c;
        System.assertEquals(num, actual);

        
        StaticResource srDel = [SELECT Id, Body FROM StaticResource WHERE Name = 'LegalAdvisorClientToDelete']; 
        String bodyToDel = srDel.Body.toString();
               
        ucl_HerokuApiHandler.insertHerokuData(bodyToDel);
        List<Client__c> clientsRes = [SELECT id, Client_Number__c, Created_By_Admin__c,Legal_Advisor__c 
                                            FROM Client__c WHERE Client_Number__c =: num ];
		System.assertEquals(0, clientsRes.size());
       
    }
    
    @isTest
    private static void testLegalAdvisorError(){
        
     	StaticResource srError = [SELECT Id, Body FROM StaticResource WHERE Name = 'LegalAdvisorClientError']; 
        String body = srError.Body.toString();
               
        ucl_HerokuApiHandler.insertHerokuData(body);        
        
    }
    
}