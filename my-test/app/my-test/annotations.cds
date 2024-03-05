using TestService as service from '../../srv/cat-service';
using from '../../db/data-model';

annotate service.Tests with @(
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Label : 'TestID',
            Value : TestID,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Title',
            Value : Title,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Description',
            Value : Description,
        },
        {
            $Type : 'UI.DataField',
            Label : 'CreatedAt',
            Value : CreatedAt,
        },
        {
            $Type : 'UI.DataField',
            Label : 'CreatedBy',
            Value : CreatedBy,
        },
    ]
);
annotate service.Tests with {
    questions @Common.ValueList : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'Questions',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : questions_QuestionID,
                ValueListProperty : 'QuestionID',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'Text',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'test_TestID',
            },
        ],
    }
};
annotate service.Tests with @(
    UI.FieldGroup #GeneratedGroup1 : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : 'TestID',
                Value : TestID,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Title',
                Value : Title,
            },
            {
                $Type : 'UI.DataField',
                Label : 'Description',
                Value : Description,
            },
            {
                $Type : 'UI.DataField',
                Label : 'CreatedAt',
                Value : CreatedAt,
            },
            {
                $Type : 'UI.DataField',
                Label : 'CreatedBy',
                Value : CreatedBy,
            },
            {
                $Type : 'UI.DataField',
                Label : 'ModifiedAt',
                Value : ModifiedAt,
            },
            {
                $Type : 'UI.DataField',
                Label : 'ModifiedBy',
                Value : ModifiedBy,
            },
            {
                $Type : 'UI.DataField',
                Label : 'questions_QuestionID',
                Value : questions_QuestionID,
            },
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneratedFacet1',
            Label : '{i18n>Test}',
            Target : '@UI.FieldGroup#GeneratedGroup1',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Questions',
            ID : 'Questions',
            Target : 'questions/@UI.LineItem#Questions',
        },
    ]
);
annotate service.Questions with @(
    UI.LineItem #Questions : [
        {
            $Type : 'UI.DataField',
            Value : answers.Text,
            Label : '{i18n>AnswersText}',
        },
        {
            $Type : 'UI.DataField',
            Value : Text,
            Label : '{i18n>QuestionText}',
        },]
);
annotate service.Questions.answers with {
    Text @Common.Text : up_.Text
};
annotate service.Questions with {
    Text @Common.Text : QuestionID
};
