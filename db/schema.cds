namespace my.bookshop;
using { CE_PURCHASEORDER_0001 as external } from '../srv/external/CE_PURCHASEORDER_0001';

entity Books {
  key ID : Integer @title: 'ID';
  title  : String @title: 'Title';
  stock  : Integer @title: 'Stock';
  category1: String @title: 'Category1';
  category2: String @title: 'Category2';
  publishedAt: Date @title: 'Published At';
}

entity PurchaseOrders as projection on external.PurchaseOrderItem {
            *
};
