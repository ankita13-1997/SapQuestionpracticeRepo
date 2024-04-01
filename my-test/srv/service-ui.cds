using TestService from './cat-service';

annotate TestService.Tests with {
    TestID           @title :  'Test Id';
    Title            @title :  'Title';
    Description      @title :  'Desciption';
    CreatedAt        @title :  'CreatedAt';
    CreatedBy        @tile  :  'CreatedBy';  
    ModifiedAt       @title :  'ModifiedAt';
    ModifiedBy       @title :  'ModifiedBy';
    fees             @title :  'Fees';
    @Measures.ISOCurrency: currency_code
    fees;

    supplier    @(
        title: 'Supplier',
        Common.Text: supplier.fullName,
        Common.TextArrangement: #TextOnly
    )
   

}

annotate  TestService.Questions with {
  QuestionID  @title : 'Qusetion Id';
  Text        @title :  'text';  
};


annotate TestService.Tests with @(
    UI : {

       
        HeaderInfo: {
			TypeName: 'Test',
			TypeNamePlural: 'Tests',
			Title          : {
                $Type : 'UI.DataField',
                Value : TestID
            },
			Description : {
				$Type: 'UI.DataField',
				Value:  Description
			}
		},
        SelectionFields: [TestID],

        FieldGroup#Main: {
            Data: [
                {Value: TestID},
                {Value: Title},
                {Value: Description},
                {Value: CreatedAt},
                {Value: CreatedBy},
                {Value: fees},
                // {Value : currency_code}
                {Value: supplier_ID}
    
            ]
        }
      }
){}

annotate TestService.Questions with @(
    UI: {
        LineItem: [
            {Value: QuestionID},
            {Value: Text},
        ]
    }
){};


annotate TestService.Tests with {
    supplier @(
        Common.ValueList: {
            Label: 'Suppliers',
            CollectionPath: 'Suppliers',
            Parameters: [
                { $Type: 'Common.ValueListParameterInOut',
                    LocalDataProperty: supplier_ID,
                    ValueListProperty: 'ID'
                },
                { $Type: 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'fullName'
                }
            ]
        }
    );
}

annotate TestService.Suppliers with {
    ID          @(
        title: 'ID',
        Common.Text: fullName
    );
    fullName    @title: 'Name';
}

annotate TestService.Suppliers with @Capabilities.SearchRestrictions.Searchable : false;
