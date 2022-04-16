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
        
        
        StaticResource srDel = [SELECT Id, Body FROM StaticResource WHERE Name = 'LegalAdvisorClientToDelete']; 
        String bodyToDel = srDel.Body.toString();
               
        ucl_HerokuApiHandler.insertHerokuData(bodyToDel);
        
        
    }
    
    @isTest
    private static void testLegalAdvisorError(){
        
     	StaticResource srError = [SELECT Id, Body FROM StaticResource WHERE Name = 'LegalAdvisorClientError']; 
        String body = srError.Body.toString();
               
        ucl_HerokuApiHandler.insertHerokuData(body);        
        
    }
    
}