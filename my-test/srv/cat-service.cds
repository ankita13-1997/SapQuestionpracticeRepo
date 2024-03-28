using my.TestService as test from '../db/data-model';

service TestService @(requires: 'authenticated-user')   {
    @odata.draft.enabled //Enable Draft
    entity Tests 
    @(restrict: [
        {
            grant: 'READ',
            to:  'endUser'
        },
        {
            grant : 
            [
               'READ',
               'WRITE',
               'UPDATE',
               'INSERT',
               'DELETE'
            ], 
             to   : 'admin',
        },
        {grant: 'assignQuestionsToTest', to : 'admin'},
        {grant: 'addReview', to: 'endUser' }
        
        ]) as select from  test.Tests actions{
        @(Common.SideEffects #AddQuestion:{
            TargetEntities:['in/questions'],
        })
        action assignQuestionsToTest @(require : 'admin') (testId : String, questionsCount : Integer);
        action  addReview @(require: 'endUser')(testId : String,rating : Integer, title : String, text : String);
    };
    
    entity Questions @readonly as projection on test.Questions;
    // action assignQuestionsToTest(testId : String, questionsCount : Integer) returns String; 
    

}
