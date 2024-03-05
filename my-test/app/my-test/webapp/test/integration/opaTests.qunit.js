sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'mytest/test/integration/FirstJourney',
		'mytest/test/integration/pages/TestsList',
		'mytest/test/integration/pages/TestsObjectPage',
		'mytest/test/integration/pages/QuestionsObjectPage'
    ],
    function(JourneyRunner, opaJourney, TestsList, TestsObjectPage, QuestionsObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('mytest') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheTestsList: TestsList,
					onTheTestsObjectPage: TestsObjectPage,
					onTheQuestionsObjectPage: QuestionsObjectPage
                }
            },
            opaJourney.run
        );
    }
);