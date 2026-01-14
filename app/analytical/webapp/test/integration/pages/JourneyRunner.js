sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"analytical/test/integration/pages/BooksAnalyticsList",
	"analytical/test/integration/pages/BooksAnalyticsObjectPage"
], function (JourneyRunner, BooksAnalyticsList, BooksAnalyticsObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('analytical') + '/test/flpSandbox.html#analytical-tile',
        pages: {
			onTheBooksAnalyticsList: BooksAnalyticsList,
			onTheBooksAnalyticsObjectPage: BooksAnalyticsObjectPage
        },
        async: true
    });

    return runner;
});

