const String googlePlayPurchaseProduct = r'''
mutation googlePlayPurchaseProduct($productId: String!, $purchaseToken: String!){
  googlePlayPurchaseProduct(productId: $productId, purchaseToken: $purchaseToken){
    id
  }
}''';
