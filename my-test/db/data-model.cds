// db/data-model.cds

namespace my.TestService;
using { managed, cuid } from '@sap/cds/common';


entity Tests{
  key TestID       : String;
      Title       : String;
      Description : String;
      CreatedAt   : DateTime;
      CreatedBy   : String;
      ModifiedAt  : DateTime;
      ModifiedBy  : String;
      questions : Association to  many Questions
}

entity Questions {
  key QuestionID : String;
  Text           : String;
  test : Association to Tests;
  answers : Composition of one Answers   
 
}

// Aspect for recording correct answers
aspect Answers{
  key AnswerID   : String;
      Text       : String;
      questions  : Association to Questions on questions.QuestionID = $self.AnswerID


  // No direct associations for aspects
}
