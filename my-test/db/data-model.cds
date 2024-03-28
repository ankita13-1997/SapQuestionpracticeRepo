// db/data-model.cds

namespace my.TestService;
using {Currency, managed, cuid } from '@sap/cds/common';
using my.TestService.Reviews from './reviews';

entity Questions {
  key QuestionID : String;
  Text           : String;
  test : Association to one Tests ;
  answers : Composition of one Answers   
 
}
// Define a custom type for currency
// type Currency : String(3);
@fiori.draft.enabled
entity Tests{
  key TestID       : String;
      Title       : String;
      Description : String;
      CreatedAt   : DateTime;
      CreatedBy   : String;
      ModifiedAt  : DateTime;
      ModifiedBy  : String;
      questions :   Association to  many Questions on questions.test = $self;
      rating :      Decimal(2,1);
      reviews :     Association to many Reviews on reviews.test = $self;
      fees        : Decimal(9, 2);
      currency     : Currency;
      associatedQuestion: Boolean
      
}



// Aspect for recording correct answers
aspect Answers{
  key AnswerID   : String;
      Text       : String;
      questions  : Association to Questions  on questions.QuestionID = $self.AnswerID


  // No direct associations for aspects
}
