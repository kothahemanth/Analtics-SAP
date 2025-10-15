using CatalogService as service from '../../srv/service';
annotate service.BooksAnalytics with @(
    UI.Identification : [
        {
            $Type : 'UI.DataField',
            Value : stock,
            Label : 'Stock',
            @UI.Importance : #High,
        },
    ],
    UI.SelectionVariant #stock : {
        SelectOptions : [
            {
                $Type : 'UI.SelectOptionType',
                PropertyName : stock,
                Ranges : [
                    {
                        $Type : 'UI.SelectionRangeType',
                        Sign : #I,
                        Option : #EQ,
                        Low : '30',
                    },
                ],
            },
        ],
    },
    UI.DataPoint #stock : {
        $Type : 'UI.DataPointType',
        Value : stock,
        Criticality : #Critical,
        Title : 'Stock Data',
    },
);

