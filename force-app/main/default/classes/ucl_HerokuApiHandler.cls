public class ucl_HerokuApiHandler {  

    @future(callout=true)
    @AuraEnabled
    public static void getHerokuData () {

        try {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://altimetrik-bootcamp.herokuapp.com/LegalAccounts');
            request.setMethod('GET');
            HttpResponse response = http.send(request);
            
            //System.debug('\n\n-------\n httpresponse: ' + response + '\n\n-------\n');
            
            // If the request is successful, parse the JSON response.
            if(response.getStatusCode() == 200) {
                ucl_HerokuApiHandler.insertHerokuData(response.getBody());
            }
        } catch (Exception e) {
            System.debug('Error: ' + e.getMessage());
            Error_Log__c error = new Error_Log__c();
            error.Message__c = e.getMessage();
            error.Line__c = String.valueOf(e.getLineNumber());
            error.Type__c = e.getTypeName();
            insert error;
        }
        
    }

    
    public static void insertHerokuData (String responseBody) {

        try {

            // Deserialize the JSON string into collections of primitive data types.
            List<Object> results = (List<Object>) JSON.deserializeUntyped(responseBody);
            
            //System.debug('\n\n-------\n results : ' + results + '\n\n-------\n');
            List<Legal_Advisor__c> legalAdvisors = new List<Legal_Advisor__c>();
            // List<Legal_Advisor__c> legalAdvisorsToDelete = new List<Legal_Advisor__c>();
            Set<String> setAccNum = new Set<String>();
            Set<String> setAccNumDelCli = new Set<String>();
            Set<String> setCliAccNum = new Set<String>();

            // Insert all Legal Advisor when Account_Status__c = 'Enabled'
            for (Object legalAdvisor : results) {
                Map<String, Object> legalAdvisorMap = (Map<String, Object>) legalAdvisor;
                String accountNumber = (String) legalAdvisorMap.get('AccountNumber');
                setAccNum.add(accountNumber);
                Legal_Advisor__c la = new Legal_Advisor__c();
                la.Account_Number__c = accountNumber;
                la.Account_Name__c = (String) legalAdvisorMap.get('AccountName');
                la.Account_Status__c = (String) legalAdvisorMap.get('AccountStatus');
                la.Name = la.Account_Name__c;
                Date AsOfDate = date.parse(legalAdvisorMap.get('AsOfDate').toString());
                la.As_of_Date__c = AsOfDate;
                
                if(la.Account_Status__c == 'Enabled'){
                    legalAdvisors.add(la);
                }
                // else {
                //     legalAdvisorsToDelete.add(la);
                //     setAccNumDelCli.add(accountNumber);
                // }
            }
            upsert legalAdvisors Legal_Advisor__c.Account_Number__c;
            // System.debug('Legal Advisors: ' + legalAdvisors);
            // System.debug('Legal Advisors To Delete: ' + legalAdvisorsToDelete);
            Map<String, Legal_Advisor__c> legAdvMap = new Map<String, Legal_Advisor__c>();
            for(Legal_Advisor__c legAdv :[SELECT z.Account_Number__c, z.Id  FROM Legal_Advisor__c z WHERE Account_Number__c IN: setAccNum] ){
                legAdvMap.put(legAdv.Account_Number__c,legAdv);
            }
            // Map<String, Legal_Advisor__c> legAdvMapDelCli = new Map<String, Legal_Advisor__c>();
            // for(Legal_Advisor__c legAdvDelCli :[SELECT z.Account_Number__c, z.Id  FROM Legal_Advisor__c z WHERE Account_Number__c IN: setAccNumDelCli] ){
            //     legAdvMapDelCli.put(legAdvDelCli.Account_Number__c,legAdvDelCli);
            // }

            // Insert all Legal Advisor Clients 
            List<Client__c> advisorClients = new List<Client__c>();
            // List<Client__c> advisorClientsToDelete = new List<Client__c>();

            for (Object legalAdvisor : results) {
                // System.debug('\n\n-------\n legalAdvisor: ' + legalAdvisor + '\n\n-------\n');
                Map<String, Object> legalAdvisorMap = (Map<String, Object>) legalAdvisor;
                String accountNumber = (String) legalAdvisorMap.get('AccountNumber');
                String accountStatus = (String) legalAdvisorMap.get('AccountStatus');
                // System.debug('\n\n-------\n accountNumber: ' + accountNumber + '\n\n-------\n');
                // System.debug('\n\n-------\n accountStatus: ' + accountStatus + '\n\n-------\n');
            
                if(accountStatus == 'Enabled'){

                    String accountID = legAdvMap.get(accountNumber).ID;

                    List<Object> clients = (List<Object>) legalAdvisorMap.get('Clients');
                    // System.debug('\n\n-------\n clients: ' + clients + '\n\n-------\n');

                    for (Object client : clients) {
                        Map<String, Object> clientsMap = (Map<String, Object>) client;
                        String clientNumber = (String) clientsMap.get('ClientNumber');
                        Client__c cli = new Client__c();
                        cli.Client_Number__c = accountNumber + (String) clientsMap.get('ClientNumber');
                        cli.First_Name__c = (String) clientsMap.get('FirstName');
                        cli.Last_Name__c = (String) clientsMap.get('LastName');
                        cli.Name = (String) clientsMap.get('LastName') + ', ' + (String) clientsMap.get('FirstName');
                        cli.Email__c = (String) clientsMap.get('Email');
                        cli.Phone__c = (String) clientsMap.get('Phone');
                        cli.Address__c = (String) clientsMap.get('Address');
                        cli.Legal_Advisor__c = accountID;
                        
                        advisorClients.add(cli);
                        setCliAccNum.add(cli.Client_Number__c);
                    }         
                }
               
            } 
            // System.debug('Clients: ' + advisorClients);
            if(advisorClients.size() > 0){
                upsert advisorClients Client_Number__c;
            }
            
            // VERIFICAR Los Client en BD que no vienen en en el JSON y que no tienen Created_By_Admin__c = true para BORRARLOS
            // System.debug('advisorClients: '+advisorClients.size());
            // System.debug('setCliAccNum: '+setCliAccNum);
            List<Client__c> clientsToDel = [SELECT id, Client_Number__c, Created_By_Admin__c,Legal_Advisor__c 
                                            FROM Client__c WHERE Client_Number__c NOT IN:setCliAccNum AND Created_By_Admin__c = false ];
            // System.debug('clientsToDel: ' + clientsToDel.size());
            if (clientsToDel.size() > 0) {
                delete clientsToDel;
            }
            
            
        } catch (DmlException e) {
            System.debug('ERROR: ' + e.getMessage());
            Error_Log__c error = new Error_Log__c();
            error.Message__c = e.getMessage();
            error.Line__c = String.valueOf(e.getLineNumber());
            error.Type__c = e.getTypeName();
            insert error;
        }
    	
    }


    @AuraEnabled
    public static void deleteAll() {

        try {
            List<Legal_Advisor__c> legalAdvisors = [SELECT Id FROM Legal_Advisor__c];
            delete legalAdvisors;
        } catch (DmlException e) {
            System.debug('delete Error: ' + e.getMessage());
        }
        
    }
    
}