// db/data-model.cds

namespace my.TestService;
using {Currency, managed, cuid } from '@sap/cds/common';
using my.TestService.Reviews from './reviews';
using {  API_BUSINESS_PARTNER as bupa } from '../srv/external/API_BUSINESS_PARTNER';

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
      associatedQuestion: Boolean;
      supplier    : Association to Suppliers;
      
}



// Aspect for recording correct answers
aspect Answers{
  key AnswerID   : String;
      Text       : String;
      questions  : Association to Questions  on questions.QuestionID = $self.AnswerID


  // No direct associations for aspects
}

entity Suppliers as projection on bupa.A_BusinessPartner {
        key BusinessPartner as ID,
        BusinessPartnerFullName as fullName,
        BusinessPartnerIsBlocked as isBlocked,
}
