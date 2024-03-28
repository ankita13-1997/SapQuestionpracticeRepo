
sap.ui.define([
    "sap/m/MessageToast",
    "sap/ui/core/mvc/Controller",
    "sap/ui/core/library"

], function (MessageToast, coreLibrary) {
    'use strict';

    return {
        AddQuestion: function (oEvent) {
            MessageToast.show("Custom handler invoked.");

            console.log(this)
            var oDataModel = oEvent.oModel
            let sActionName = "TestService.assignQuestionsToTest";
            // var oDataModel = this.getModel(); 
            let mParameters = {

                contexts: oEvent.oBinding,
                model: oEvent.oModel,
                label: 'Confirm',
                invocationGrouping: true

            };
            this.editFlow.invokeAction(sActionName, mParameters).
                then(function (oResponse) {
                    oDataModel.refresh(); 
                    // Log the response to the console
                    console.log("Action response:", oResponse);
                    // if (oResponse || oResponse.length === 0) {
                    //     // Show a dialog box
                    //     var oDialog = new oDialog({
                    //         title: "Success",
                    //         type: "Message",
                    //         content: new Text({ text: "API call was successful, but no values in the response." }),
                    //         beginButton: new sap.m.Button({
                    //             text: "OK",
                    //             press: function () {
                    //                 oDialog.close();
                    //             }
                    //         }),
                    //         afterClose: function () {
                    //             oDialog.destroy();
                    //         }
                    //     });

                    //     oDialog.open();
                    // }
                    // oDataModel.refresh();
                }).catch(function (oError) {
                    // Handle errors if needed
                    console.error("Error while invoking action:", oError);
                });;
            this.refresh();


        }
    };

});
