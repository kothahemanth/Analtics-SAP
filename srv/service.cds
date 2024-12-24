using my.bookshop as my from '../db/schema';

service CatalogService {
    @readonly entity BooksAnalytics as projection on my.Books;
    entity PurchaseOrders as projection on my.PurchaseOrders;
}

entity PurchaseOrders as projection on my.PurchaseOrders{
    @title: 'Purchase Order'
    PurchaseOrder : Decimal(10, 2),
    @title: 'Material'
    Material : String(50),
    @title: 'Plant'
    Plant : String(50),
    @title: 'Quantity'
    OrderQuantity : Decimal(20),
    @title: 'Item'
    PurchaseOrderItem : String,
    @title: 'Purchase Order Item Text'
    PurchaseOrderItemText : String(150),
    @title: 'Quantity Unit'
    BaseUnit : String(20),
    @title: 'Storage Location'
    StorageLocation : String(50),
    @title: 'Tax Code'
    TaxCode : String(50),
    @title: 'Company Code'
    CompanyCode : String(50),
    @title: 'HSN Code'
    ConsumptionTaxCtrlCode : String(50),
    @title: 'UOP'
    OrderPriceUnit : String(50),
    *
}

annotate CatalogService.PurchaseOrders with @(

  Aggregation.ApplySupported: {
    Transformations: [
      'aggregate',
      'topcount',
      'bottomcount',
      'identity',
      'concat',
      'filter',
      'search'      
    ],

    GroupableProperties: [
      PurchaseOrder,
      Material,
      Plant,
      OrderQuantity,
      StorageLocation
    ],

    AggregatableProperties: [{
      $Type : 'Aggregation.AggregatablePropertyType',
      Property: OrderPriceUnit
    }]
  },

  Analytics.AggregatedProperty #totalStock: {
    $Type : 'Analytics.AggregatedPropertyType',
    AggregatableProperty : OrderPriceUnit,
    AggregationMethod : 'sum',
    Name : 'totalStock',
    ![@Common.Label]: 'Total stock'
  },
);

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

annotate CatalogService.PurchaseOrders with @(
  UI.Chart: {
    $Type : 'UI.ChartDefinitionType',
    Title: 'Order',
    ChartType : #Column,
    Dimensions: [
      OrderQuantity,
      StorageLocation
    ],
    DimensionAttributes: [{
      $Type : 'UI.ChartDimensionAttributeType',
      Dimension: OrderQuantity,
      Role: #Category
    },{
      $Type : 'UI.ChartDimensionAttributeType',
      Dimension: StorageLocation,
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

annotate CatalogService.PurchaseOrders with @(
  UI.Chart #OrderQuantity: {
    $Type : 'UI.ChartDefinitionType',
    ChartType: #Bar,
    Dimensions: [
      OrderQuantity
    ],
    DynamicMeasures: [
      ![@Analytics.AggregatedProperty#totalStock]
    ]
  },
  UI.PresentationVariant #prevOrderQuantity: {
    $Type : 'UI.PresentationVariantType',
    Visualizations : [
        '@UI.Chart#OrderQuantity',
    ],
  }
){
  OrderQuantity @Common.ValueList #vlOrderQuantity: {
    $Type : 'Common.ValueListType',
    CollectionPath : 'PurchaseOrders',
    Parameters: [{
      $Type : 'Common.ValueListParameterInOut',
      ValueListProperty : 'OrderQuantity',
      LocalDataProperty: OrderQuantity
    }],
    PresentationVariantQualifier: 'prevOrderQuantity'
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

annotate CatalogService.PurchaseOrders with@(
    UI: {
        SelectionFields  : [
            OrderQuantity,
            StorageLocation,
            Material
        ],
        LineItem: [
            {  $Type : 'UI.DataField', Value : PurchaseOrder, },
            {  $Type : 'UI.DataField', Value : Material, },
            {  $Type : 'UI.DataField', Value : Plant, },
            {  $Type : 'UI.DataField', Value : OrderQuantity, },
            {  $Type : 'UI.DataField', Value : StorageLocation, },
            {  $Type : 'UI.DataField', Value : CompanyCode, },
            {  $Type : 'UI.DataField', Value : OrderPriceUnit, },
        ],
    }
);
