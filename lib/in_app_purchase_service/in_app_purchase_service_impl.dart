import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:fita_in_app_purchase/configure_dependencies.dart';
import 'package:graphql/client.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import 'google_play_purchase_product.dart';
import 'in_app_purchase_service.dart';

@LazySingleton(as: InAppPurchaseService)
class InAppPurchaseServiceImpl implements InAppPurchaseService {
  // Auto-consume must be true on iOS.
// To try without auto-consume on another platform, change `true` to `false` here.
  final bool _kAutoConsume = Platform.isIOS || true;
  final GraphQLClient _client;
  final InAppPurchase _inAppPurchase;

  InAppPurchaseServiceImpl(this._inAppPurchase, this._client);

  final logger = getIt.get<Logger>();

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => _inAppPurchase.purchaseStream;

  @override
  Future<bool> get isAvailable => _inAppPurchase.isAvailable();

  /// Set literals require Dart 2.2. Alternatively, use
  /// `Set<String> _kIds = <String>['product1', 'product2'].toSet()`.
  @override
  Future<List<ProductDetails>> loadProductsForSale(Set<String> ids) async {
    logger.i('run loadProductsForSale');

    List<ProductDetails> products = [];
    try {
      final response = await _inAppPurchase.queryProductDetails(ids);
      inspect(response);
      if (response.notFoundIDs.isNotEmpty) {
        return products;
      }
      products = response.productDetails;
      return products;
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  @override
  Future<bool> makingAPurchase(ProductDetails productDetails, {bool isConsumable = false}) async {
    final purchaseParam = PurchaseParam(productDetails: productDetails);
    try {
      if (isConsumable) {
        return await _inAppPurchase.buyConsumable(
          purchaseParam: purchaseParam,
          autoConsume: _kAutoConsume,
        );
      } else {
        return await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      }
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> completePurchase(PurchaseDetails purchaseDetails) async {
    try {
      await _inAppPurchase.completePurchase(purchaseDetails);
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> restorePurchases() async {
    try {
      await _inAppPurchase.restorePurchases();
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<bool> verifyPurchase(
    String productId,
    String serverVerificationData,
  ) async {
    final variables = {
      'productId': productId,
      'purchaseToken': serverVerificationData,
    };
    final options = MutationOptions(
      document: gql(googlePlayPurchaseProduct),
      variables: variables,
      fetchPolicy: FetchPolicy.networkOnly,
    );
    try {
      final response = await _client.mutate(options);
      inspect(response);

      if (response.hasException) {
        Exception('has Exception');
      }
      return true;
    } catch (e) {
      rethrow;
    }
  }
}
