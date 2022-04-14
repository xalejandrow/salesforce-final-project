// import BEAR_LIST_UPDATE_MESSAGE from '@salesforce/messageChannel/BearListUpdate__c';
import { NavigationMixin } from 'lightning/navigation';
import { LightningElement, wire } from 'lwc';
import searchLegalAdvisors from '@salesforce/apex/ucl_legalAdvisorController.searchLegalAdvisors';

export default class LegalAdvisorList extends LightningElement {

    searchTerm = '';
	legalAdvisors;
	// @wire(MessageContext) messageContext;
	@wire(searchLegalAdvisors, {searchTerm: '$searchTerm'})
	loadLegalAdvisors(result) {
	this.legalAdvisors = result;
	if (result.data) {
		const message = {
			legalAdvisors: result.data
		};
		// publish(this.messageContext, ADVISOR_LIST_UPDATE_MESSAGE, message);
	}
	}
	handleSearchTermChange(event) {
		// Debouncing this method: do not update the reactive property as
		// long as this function is being called within a delay of 300 ms.
		// This is to avoid a very large number of Apex method calls.
		window.clearTimeout(this.delayTimeout);
		const searchTerm = event.target.value;
		// eslint-disable-next-line @lwc/lwc/no-async-operation
		this.delayTimeout = setTimeout(() => {
			this.searchTerm = searchTerm;
		}, 300);
	}
	get hasResults() {
		return (this.legalAdvisors.data.length > 0);
	}
	handleAdvisorView(event) {
		// Get advisor record id from advisorview event
		const advisorId = event.detail;
		// Navigate to advisor record page
		this[NavigationMixin.Navigate]({
			type: 'standard__recordPage',
			attributes: {
				recordId: advisorId,
				objectApiName: 'Legal_Advisor__c',
				actionName: 'view',
			},
		});
	}

}