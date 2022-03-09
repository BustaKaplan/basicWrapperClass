import { LightningElement, track, wire } from 'lwc';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
import getEPRs from '@salesforce/apex/BasicWrapper.getBasicWrapper';   
//import SystemModstamp from '@salesforce/schema/Account.SystemModstamp';

const columns = [
    { label: 'Name', fieldName: 'studentName', type: 'text'},
    { label: 'Emplid', fieldName: 'emplid', type: 'text'},
    { label: 'Course Name/Course Section', fieldName: 'courseNameSection', type: 'text'},
    { label: 'First Feedback Type', fieldName: 'firstFeedbackType', type: 'text'},
    { label: 'Second Feedback Type', fieldName: 'secondFeedbackType', type: 'text'},
    { label: 'Additional Comments', fieldName: 'additionalComments', type: 'text'},
    { label: 'Date Sent', fieldName: 'dateSent', type: 'date'},
    { label: 'Date Acknowledged', fieldName: 'dateAcknowledged', type: 'date'},
]

export default class EarlyProgressReportsByCourse extends NavigationMixin(LightningElement) {
    
    @track data;
    @track error;
    columns = columns;
    currentPageReference = null; 
    urlStateParameters = null;
    contactId = null; /* Param from Url */
 
    //get the course Id from the URL
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
       if (currentPageReference) {
          this.urlStateParameters = currentPageReference.state;
          this.contactId = this.urlStateParameters.c__contactId || null;
       }
    }

    //pass the course Id to apex and retrieve related EPR records
    @wire(getEPRs, {contactId:'$contactId'})
    wiredEPRs({ error, data }) { 
        if (data) {
            this.data = data;

        } else if (error) {
            console.log('error: ' + JSON.stringify(error));
            this.listEPRs = null;
            this.error = error;
        }
    }
}
