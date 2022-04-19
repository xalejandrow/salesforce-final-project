public with sharing class ucl_Utils {
  
    public static void sendErrorMail(Error_Log__c error){
        
	  List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
      List<String> sendTo = new List<String>();
      //The mail is assumed static for this purpose, 
      //it should be passed as a parameter or obtained from the system
      sendTo.add('xalejandrow@gmail.com');
      mail.setToAddresses(sendTo);
        
      mail.setReplyTo('xalejandrow@gmail.com');
      mail.setSenderDisplayName('Salesforce Error Administration');

      mail.setSubject('ERROR LOG');
      String body = 'Error Found ';
      body += 'Messaje: '+ error.Message__c + '<br/>';
      body += 'Line: '+ error.Line__c + '<br/>';
      body += 'Type: '+ error.Type__c + '<br/>';
      body += 'Messaje: '+ error.Message__c + '<br/>';
      mail.setHtmlBody(body);
    
      mails.add(mail);
        
      Messaging.sendEmail(mails);
    }
}