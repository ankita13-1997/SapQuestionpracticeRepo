using TestService as service from '../../srv/cat-service';
using from '../../db/data-model';

annotate service.Tests with @(UI.LineItem: [
    {
        $Type: 'UI.DataField',
        Label: 'TestID',
        Value: TestID,
    },
    {
        $Type: 'UI.DataField',
        Label: 'Title',
        Value: Title,
    },
    {
        $Type: 'UI.DataField',
        Label: 'Description',
        Value: Description,
    },
    {
        $Type: 'UI.DataField',
        Label: 'CreatedAt',
        Value: CreatedAt,
    },
    {
        $Type : 'UI.DataFieldForAnnotation',
        Label : 'Addquestion',
        Target: '@UI.FieldGroup#AddQuestion',
    },
    {
        $Type : 'UI.DataFieldForAnnotation',
        Label : '{i18n>AddReview}',
        Target: '@UI.FieldGroup#AddReview',
    },
    {
        $Type: 'UI.DataField',
        Label: 'CreatedBy',
        Value: CreatedBy,
    },
    {
        $Type            : 'UI.DataFieldForAnnotation',
        Label            : 'testRating',
        Target           : '@UI.DataPoint#testRating',
        ![@UI.Importance]: #High,
    },

    {Value : fees},
],

);

annotate service.Tests with {
    questions @Common.ValueList: {
        $Type         : 'Common.ValueListType',
        CollectionPath: 'Questions',
        Parameters    : [

            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'Text',
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'test_TestID',
            },
        ],
    }
};

annotate service.Tests with {
    @Common.Label                   : 'Fees'
    @Common                         : {
        Text           : currency.name,
        TextArrangement: #TextOnly
    }
    @Common.ValueListWithFixedValues: true
    @Common.ValueList               : {
        $Type         : 'Common.ValueListType',
        Label         : 'Currency',
        CollectionPath: 'Currencies',
        Parameters    : [
            {
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: currency_code,
                ValueListProperty: 'code'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'name'
            }
        ]
    }
    @Core.Description               : 'A currency code as specified in ISO 4217'
    currency

};

annotate service.Tests with @(
    UI.FieldGroup #GeneratedGroup1: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: 'TestID',
                Value: TestID,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Title',
                Value: Title,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Description',
                Value: Description,
            },
            {
                $Type: 'UI.DataField',
                Label: 'CreatedAt',
                Value: CreatedAt,
            },
            {
                $Type: 'UI.DataField',
                Label: 'CreatedBy',
                Value: CreatedBy,
            },
            {
                $Type: 'UI.DataField',
                Label: 'ModifiedAt',
                Value: ModifiedAt,
            },
            {
                $Type: 'UI.DataField',
                Label: 'ModifiedBy',
                Value: ModifiedBy,
            },
            {
                $Type            : 'UI.DataFieldForAnnotation',
                Label            : 'testRating',
                Target           : '@UI.DataPoint#testRating',
                ![@UI.Importance]: #High,
            },
             {Value : fees},

        ],
    },

    UI.Facets                     : [
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'GeneratedFacet1',
            Label : '{i18n>Test}',
            Target: '@UI.FieldGroup#GeneratedGroup1',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : '{i18n>Questions}',
            ID    : 'i18nQuestions',
            Target: 'questions/@UI.LineItem#i18nQuestions',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Review',
            ID    : 'Review1',
            Target: '@UI.FieldGroup#Review1',
        },


    ],

    UI.FieldGroup #AddQuestion    : {Data: [{
        $Type             : 'UI.DataFieldForAction',
        Label             : '{i18n>AddQuestion}',
        Action            : 'TestService.assignQuestionsToTest',
        InvocationGrouping: #ChangeSet
    }, ]},
     
    
    UI.FieldGroup #AddReview      : {Data: [{
        $Type             : 'UI.DataFieldForAction',
        Label             : '{i18n>AddReview}',
        ![@UI.Hidden] : {$edmJson: {$Eq: [{$Path: 'associatedQuestion'}, true]}},
        Action            : 'TestService.addReview',
        InvocationGrouping: #ChangeSet,
       
    }, ]},

    UI.DataPoint #testRating      : {
        Value        : rating,
        Visualization: #Rating,
        MinimumValue : 0,
        MaximumValue : 5,
        TargetValue  : 5

    },


    UI.Identification             : [
        {Value: rating},
        {
            $Type : 'UI.DataFieldForAction',
            Label : '{i18n>AddReview}',
            ![@UI.Hidden] : {$edmJson: {$Eq: [{$Path: 'associatedQuestion'},false]}},
            Action: 'TestService.addReview'
        }
    ],


);

annotate service.Questions with @(UI.LineItem #Questions: []);

annotate service.Questions.answers with{
    Text @Common.Text: questions.test_TestID
};

annotate service.Questions with {
    Text @Common.Text: answers.Text
};

annotate service.Questions with @( UI.LineItem #i18nQuestions: [
    {
        $Type: 'UI.DataField',
        Value: Text,
        Label: 'Question Text',
    },
    {
        $Type: 'UI.DataField',
        Value: answers.Text,
        Label: 'Answer_text',
    },
]);

// annotate service.Tests  with @(Common.SideEffects #AddQuestion:{
//     TargetProperties:['associatedQuestion'],
//     TargetEntities:['questions'],
//     TriggerAction: 'service.assignQuestionsToTest'
// });

// annotate service.Questions  with @(Common.SideEffects #AddQuestion:{
//     TargetProperties:['QuestionID','Text','test_TestID'],
//     TargetEntities:['test'],
//     TriggerAction: 'service.assignQuestionsToTest'
// });


annotate my.TestService.Reviews with @(UI.LineItem #Review: []);
annotate service.Tests with @(UI.FieldGroup #Review1: {
    $Type: 'UI.FieldGroupType',
    Data : [
        {
            $Type            : 'UI.DataFieldForAnnotation',
            Label            : 'testRating',
            Target           : '@UI.DataPoint#testRating',
            ![@UI.Importance]: #High,
        },
        {
            $Type: 'UI.DataField',
            Value: Title,
        },
    ],
});

annotate my.TestService.Reviews with @(UI.LineItem #Reviews: []);
