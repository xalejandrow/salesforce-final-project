@isTest
public class ucl_TestEmailError {
    
    @isTest
    private static void testSendEmail(){
    
        Error_Log__c error = new Error_Log__c();
        error.Message__c = 'This is the body Message from test';
        error.Line__c = String.valueOf(12345);
        error.Type__c = 'Error Type';
        
        ucl_Utils.sendErrorMail(error);
    }
    
    

}