trigger sendMail on Error_Log__c (after insert) {

    Error_Log__c[] error = Trigger.New;

     ucl_Utils.sendErrorMail(error[0]);

}