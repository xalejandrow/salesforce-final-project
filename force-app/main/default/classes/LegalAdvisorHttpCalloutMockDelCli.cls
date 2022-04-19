@isTest
global class LegalAdvisorHttpCalloutMockDelCli implements HttpCalloutMock {
	
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
       	StaticResource sr = [SELECT Id, Body FROM StaticResource WHERE Name = 'LegalAdvisorClientToDelete']; 
        String json = sr.Body.toString(); 
        
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody(json);
        response.setStatusCode(200);
        return response; 
    }
}