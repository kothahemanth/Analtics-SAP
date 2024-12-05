sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'project2/test/integration/FirstJourney',
		'project2/test/integration/pages/BooksAnalyticsList',
		'project2/test/integration/pages/BooksAnalyticsObjectPage'
    ],
    function(JourneyRunner, opaJourney, BooksAnalyticsList, BooksAnalyticsObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('project2') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheBooksAnalyticsList: BooksAnalyticsList,
					onTheBooksAnalyticsObjectPage: BooksAnalyticsObjectPage
                }
            },
            opaJourney.run
        );
    }
);