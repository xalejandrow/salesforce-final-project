public with sharing class ucl_legalAdvisorController {
    public ucl_legalAdvisorController() {

    }

    @AuraEnabled(Cacheable=true)
    public static Legal_Advisor__c[] getAllLegalAdvisors(){
        return [
            SELECT
                Id,
                Name,
                Account_Name__c,
                Account_Number__c,
                Account_Status__c,
                As_of_Date__c
            FROM Legal_Advisor__c
            WITH SECURITY_ENFORCED
            // ORDER BY Name
            // LIMIT 50
        ];
    }


    @AuraEnabled(Cacheable=true)
    public static Legal_Advisor__c[] searchLegalAdvisors(String searchTerm) {
        // Return all LegalAdvisors when no search term
        searchTerm = searchTerm.trim();
        if (searchTerm == '') {
            return getAllLegalAdvisors();
        }
        // Prepare query paramters
        searchTerm = '%' + searchTerm + '%';
        // Execute search query
        return [
            SELECT
                Id,
                Name,
                Account_Name__c,
                Account_Number__c,
                Account_Status__c,
                As_of_Date__c
            FROM Legal_Advisor__c
            WHERE Name LIKE :searchTerm
            WITH SECURITY_ENFORCED
            // ORDER BY Name
            // LIMIT 50
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<Client__c> getRelatedClients(Id advisorId) {
        return [
            SELECT 
                Id,
                Name,
                Client_Number__c,
                First_Name__c,
                Last_Name__c,
                Address__c,
                Phone__c,
                Created_By_Admin__c
            FROM Client__c
            WHERE Legal_Advisor__c = :advisorId
            WITH SECURITY_ENFORCED
       ];
    }


}
