import { LightningElement , wire} from 'lwc';
import ucl_herokuApi from '@salesforce/apex/ucl_HerokuApiHandler.getHerokuData';
import ucl_herokuDelete from '@salesforce/apex/ucl_HerokuApiHandler.deleteAll';


export default class InvokeService extends LightningElement {
    // @wire(ucl_herokuApi)
    clickedButtonLabel = '';

    handleClick(event) {
        try {
            ucl_herokuApi();
            // ucl_herokuApi.getHerokuData();
        // this.clickedButtonLabel = event.target.label;
        
            this.clickedButtonLabel = "Process Completed";
    
        } catch (error) {
            this.clickedButtonLabel = "Process Error";

        }
        
    }
    
    handleClickDelete(event) {
        try {

            ucl_herokuDelete();
            // ucl_herokuApi.deleteAll();
        // this.clickedButtonLabel = event.target.label;
        
            this.clickedButtonLabel = "Records Deleted";
    
        } catch (error) {
            this.clickedButtonLabel = "Process Error";

        }
        
    }
}