import { LightningElement , wire} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import ucl_herokuApi from '@salesforce/apex/ucl_HerokuApiHandler.getHerokuData';
import ucl_herokuDelete from '@salesforce/apex/ucl_HerokuApiHandler.deleteAll';


export default class InvokeService extends LightningElement {
    // @wire(ucl_herokuApi)
    clickedButtonLabel = '';
    _title = 'Import Data';
    message = '';
    variant = 'success';
    variantOptions = [
        { label: 'error', value: 'error' },
        { label: 'warning', value: 'warning' },
        { label: 'success', value: 'success' },
        { label: 'info', value: 'info' },
    ];

    handleClick(event) {
        try {
            ucl_herokuApi();
            // ucl_herokuApi.getHerokuData();
        // this.clickedButtonLabel = event.target.label;
        
            this.clickedButtonLabel = "Process Completed";
            this.message = "Process Completed";
            this.variant = 'success';
            this.showNotification();
    
        } catch (error) {
            this.clickedButtonLabel = "Process Error";
            this.message = "Process Error";
            this.variant = "error";
            this.showNotification();

        }
        
    }
    
    handleClickDelete(event) {
        try {

            ucl_herokuDelete();
            // ucl_herokuApi.deleteAll();
        // this.clickedButtonLabel = event.target.label;
        
            this.clickedButtonLabel = "Records Deleted";
            this.message = "Records Deleted";
            this.variant = "info";
            this.showNotification();
    
        } catch (error) {
            this.clickedButtonLabel = "Process Error";
            this.message = "Process Error";
            this.variant = "error";
            this.showNotification();

        }
        
    }

    showNotification() {
        const evt = new ShowToastEvent({
            title: this._title,
            message: this.message,
            variant: this.variant,
        });
        this.dispatchEvent(evt);
    }
}