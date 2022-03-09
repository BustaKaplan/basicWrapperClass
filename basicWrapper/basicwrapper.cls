public with sharing class ContactsAndAccounts{
      
    @AuraEnabled(cacheable=true)
    public static List<AccWrapper> getAccountsByContact(String contactId){
        List<AccWrapper> accs = new List<AccWrapper>();

        //retreive related Accounts
        List<Contact> conList =   [SELECT Name, Student__r.Name, Student__r.Emplid__c, Course_Section__c, Course_Name__c, 
                                                            Feedback_Type_1__c, Feedback_Type_2__c, Additional_Comments__c, Last_Acknowledged_Date__c, 
                                                            CreatedDate From Contact 
                                                            WHERE Course_Id__c = :courseId ORDER By student__r.LastName];
        //build the epr wrapper from the information returned
        if(!conList.isEmpty()){
            for(Contact con : conList){
                
                AccWrapper wacc = new AccWrapper();                   
                    wacc.studentName = con.Student__r.Name;
                    wacc.emplid = con.Student__r.Emplid__c;
                    wacc.courseNameSection = con.Course_Name__c + ' ' + con.Course_Section__c;
                    wacc.firstFeedbackType = con.Feedback_Type_1__c;
                    wacc.secondFeedbackType = con.Feedback_Type_2__c;
                    wacc.additionalComments = con.Additional_Comments__c != null ? con.Additional_Comments__c.stripHtmlTags() : null;
                    wacc.dateSent = con.CreatedDate.date();
                    wacc.dateAcknowledged = con.Last_Acknowledged_Date__c != null ? con.Last_Acknowledged_Date__c.date() : null;
                accs.add(wacc);
            }
        }
        return accs;
    }
      
    // wrapper class with @AuraEnabled and {get;set;} properties 
    public class AccWrapper{
        @AuraEnabled
        public String studentName{get;set;}
        @AuraEnabled
        public String emplid{get;set;}
        @AuraEnabled
        public String courseNameSection{get;set;}
        @AuraEnabled
        public String firstFeedbackType{get;set;}
        @AuraEnabled
        public String secondFeedbackType{get;set;}
        @AuraEnabled
        public String additionalComments{get;set;}
        @AuraEnabled
        public Date dateSent{get;set;}
        @AuraEnabled
        public DateTime dateAcknowledged{get;set;}
    }
}
