import 'package:in_app_purchase/in_app_purchase.dart';

abstract class InAppPurchaseService {
  Stream<List<PurchaseDetails>> get purchaseStream;
  Future<bool> get isAvailable;
  Future<List<ProductDetails>> loadProductsForSale(Set<String> ids);
  Future<bool> makingAPurchase(ProductDetails productDetails, {bool isConsumable = false});
  Future<void> completePurchase(PurchaseDetails purchaseDetails);
  Future<void> restorePurchases();
  Future<bool> verifyPurchase(
    String productId,
    String serverVerificationData,
  );
}
