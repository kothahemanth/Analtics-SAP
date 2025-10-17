using CatalogService as service from '../../srv/service';

annotate service.BooksAnalytics with @(

    // === General Identification ===
    UI.Identification                 : [{
        $Type         : 'UI.DataField',
        Value         : stock,
        Label         : 'Stock',
        @UI.Importance: #High
    }],

    // === Selection Variant for Stock Filtering ===
    UI.SelectionVariant #stock        : {SelectOptions: [{
        $Type       : 'UI.SelectOptionType',
        PropertyName: stock,
        Ranges      : [{
            $Type : 'UI.SelectionRangeType',
            Sign  : #I,
            Option: #GE,
            // Filter for stock >= 30
            Low   : 30
        }]
    }]},

    // === Line Item (Table) ===
    UI.LineItem #Stock                : [
        {
            $Type: 'UI.DataField',
            Value: category1,
            Label: 'Category'
        },
        {
            $Type: 'UI.DataField',
            Value: stock,
            Label: 'Stock'
        }
    ],

    // === Data Point (for Stock values) ===
    UI.DataPoint #stock               : {
        $Type                      : 'UI.DataPointType',
        Value                      : stock,
        Title                      : 'Stock',
        ValueFormat                : 'Number',
        // Ensures numeric display
        ValueCriticalityCalculation: {
            ImprovementDirection   : #Target,
            ToleranceRangeLowValue : 5,
            ToleranceRangeHighValue: 50
        }
    },


    // === Presentation Variant for Table ===
    UI.PresentationVariant #Stock     : {
        Visualizations: ['@UI.LineItem#Stock'],
        SortOrder     : [{
            Property  : stock,
            Descending: true
        }]
    },

    // === Chart Definition ===

    UI.Chart #TitleStock              : {
        $Type              : 'UI.ChartDefinitionType',
        ChartType          : #Column,
        Title              : 'Books Stock Overview',
        Description        : 'Stock per Book Title',
        Dimensions         : [title],
        Measures           : [quantity],
        MeasureAttributes  : [{
            $Type       : 'UI.ChartMeasureAttributeType',
            Measure     : quantity,
            Role        : #Axis1,
            DataPoint   : '@UI.DataPoint#stock',
            FormatString: '0' // Force integer on Y-axis
        }],
        DimensionAttributes: [{
            $Type    : 'UI.ChartDimensionAttributeType',
            Dimension: title,
            Role     : #Category
        }]
    },


    // === Presentation Variant for Chart ===
    UI.PresentationVariant #TitleStock: {
        Visualizations: ['@UI.Chart#TitleStock'],
        SortOrder     : [{
            Property  : stock,
            Descending: true
        }]
    }
);
