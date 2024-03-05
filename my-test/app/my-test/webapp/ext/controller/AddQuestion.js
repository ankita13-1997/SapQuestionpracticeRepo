sap.ui.define([
    "sap/m/MessageToast",
    "sap/ui/core/mvc/Controller"

], function (MessageToast) {
    'use strict';

    return {
        AddQuestion: function (oEvent) {
            MessageToast.show("Custom handler invoked.");
           
            let sActionName = "TestService.assignQuestionsToTest"; 
            var oDataModel = this.getModel(); 
            let mParameters = { model: oDataModel, questionsCount:2 }; 
            this.editFlow.invokeAction(sActionName, mParameters).
            then(function () { oDataModel.refresh(); }); this.refresh();

        //     console.log("value in this ", this)

        //     // Specify the TestID and questionsCount
        //     var sTestId = "1";  // Replace with your actual TestID
        //     var iQuestionsCount = 2;  // Replace with your actual questionsCount

        //     // Specify the action name and parameters
        //     var sActionName = "TestService.EntityContainer/assignQuestionsToTest";
        //     var mParameters = {
        //         "questionsCount": iQuestionsCount
        //     };

        //     // Invoke the custom action
        //     this.editFlow.invokeAction("TestService", [sActionName], mParameters)
        //         .then(function (oResponse) {
        //             // Handle the success response
        //             console.log("Action invoked successfully:", oResponse);
        //         })
        //         .catch(function (oError) {
        //             // Handle the error response
        //             console.error("Error invoking action:", oError);
        //         });
         }
    };

});
