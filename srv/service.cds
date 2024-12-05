using my.bookshop as my from '../db/schema';

service CatalogService {
    @readonly entity BooksAnalytics as projection on my.Books;
}

annotate CatalogService.BooksAnalytics with @(

  Aggregation.ApplySupported: {
    Transformations: [
      'aggregate',
      'topcount',
      'bottomcount',
      'identity',
      'concat',
      'groupby',
      'filter',
      'search'      
    ],

    GroupableProperties: [
      ID,
      category1,
      category2,
      title,
      publishedAt
    ],

    AggregatableProperties: [{
      $Type : 'Aggregation.AggregatablePropertyType',
      Property: stock
    }]
  },

  Analytics.AggregatedProperty #totalStock: {
    $Type : 'Analytics.AggregatedPropertyType',
    AggregatableProperty : stock,
    AggregationMethod : 'sum',
    Name : 'totalStock',
    ![@Common.Label]: 'Total stock'
  },
);

annotate CatalogService.BooksAnalytics with @(
  UI.Chart: {
    $Type : 'UI.ChartDefinitionType',
    Title: 'Stock',
    ChartType : #Column,
    Dimensions: [
      category1,
      category2
    ],
    DimensionAttributes: [{
      $Type : 'UI.ChartDimensionAttributeType',
      Dimension: category1,
      Role: #Category
    },{
      $Type : 'UI.ChartDimensionAttributeType',
      Dimension: category2,
      Role: #Category2
    }],
    DynamicMeasures: [
      ![@Analytics.AggregatedProperty#totalStock]
    ],
    MeasureAttributes: [{
      $Type: 'UI.ChartMeasureAttributeType',
      DynamicMeasure: ![@Analytics.AggregatedProperty#totalStock],
      Role: #Axis1
    }]
  },
  UI.PresentationVariant: {
    $Type : 'UI.PresentationVariantType',
    Visualizations : [
        '@UI.Chart',
    ],
  }
);

annotate CatalogService.BooksAnalytics with @(
  UI.Chart #category1: {
    $Type : 'UI.ChartDefinitionType',
    ChartType: #Bar,
    Dimensions: [
      category1
    ],
    DynamicMeasures: [
      ![@Analytics.AggregatedProperty#totalStock]
    ]
  },
  UI.PresentationVariant #prevCategory1: {
    $Type : 'UI.PresentationVariantType',
    Visualizations : [
        '@UI.Chart#category1',
    ],
  }
){
  category1 @Common.ValueList #vlCategory1: {
    $Type : 'Common.ValueListType',
    CollectionPath : 'BooksAnalytics',
    Parameters: [{
      $Type : 'Common.ValueListParameterInOut',
      ValueListProperty : 'category1',
      LocalDataProperty: category1
    }],
    PresentationVariantQualifier: 'prevCategory1'
  }
}

annotate CatalogService.BooksAnalytics with@(
    UI: {
        SelectionFields  : [
            category1,
            category2,
            publishedAt
        ],
        LineItem: [
            {  $Type : 'UI.DataField', Value : ID, },
            {  $Type : 'UI.DataField', Value : title, },
            {  $Type : 'UI.DataField', Value : category1, },
            {  $Type : 'UI.DataField', Value : category2, },
            {  $Type : 'UI.DataField', Value : stock, },
            {  $Type : 'UI.DataField', Value : publishedAt, },
        ],
    }
);


