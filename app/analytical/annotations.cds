using CatalogService as service from '../../srv/service';
annotate service.BooksAnalytics with @(
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Value : ID,
        },
        {
            $Type : 'UI.DataField',
            Value : title,
        },
        {
            $Type : 'UI.DataField',
            Value : category1,
        },
        {
            $Type : 'UI.DataField',
            Value : category2,
        },
        {
            $Type : 'UI.DataField',
            Value : stock,
        },
        {
            $Type : 'UI.DataField',
            Value : publishedAt,
        },
        {
            $Type : 'UI.DataField',
            Value : quantity,
        },
    ]
);
