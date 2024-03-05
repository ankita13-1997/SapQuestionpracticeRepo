using my.TestService as test from '../db/data-model';

service TestService {
    entity Tests @readonly as projection on test.Tests actions{

        action assignQuestionsToTest(testId : String, questionsCount : Integer) returns array of Questions;
    };
    entity Questions @readonly as projection on test.Questions;
    // action assignQuestionsToTest(testId : String, questionsCount : Integer) returns String; 
    

}
