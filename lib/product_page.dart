import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:logger/logger.dart';

import 'configure_dependencies.dart';
import 'in_app_purchase_service/in_app_purchase_service.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  static const idProduct = '9b764076_33fb_11ed_bf21_130100000000';
  final logger = getIt.get<Logger>();
  final inAppPurchaseService = getIt.get<InAppPurchaseService>();
  List<ProductDetails> products = [];
  bool isLoading = true;
  bool _isAvailable = false;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  showAlert(String text, Icon icon) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(text),
          content: icon,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    });
  }

  @override
  void initState() {
    initStoreInfo();
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  Future<void> _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          setState(() {
            isLoading = true;
          });
          break;
        case PurchaseStatus.error:
          inspect(purchaseDetails);
          final detail = purchaseDetails.error!.details.toString();
          showAlert(detail, const Icon(Icons.error));
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          try {
            await inAppPurchaseService.verifyPurchase(
              purchaseDetails.productID,
              purchaseDetails.verificationData.serverVerificationData,
            );
            showAlert('Thank you for paying with us ${purchaseDetails.status.name}',
                const Icon(Icons.check_circle_outline));
          } catch (error) {
            showAlert('Error Verification', const Icon(Icons.error));
          }
          break;
        default:
      }

      if (purchaseDetails.pendingCompletePurchase) {
        await inAppPurchaseService.completePurchase(purchaseDetails);
      }
    }
  }

  Future<void> initStoreInfo() async {
    final isAvailable = await inAppPurchaseService.isAvailable;
    setState(() => _isAvailable = isAvailable);
    if (!isAvailable) return;

    _subscription =
        inAppPurchaseService.purchaseStream.listen((List<PurchaseDetails> purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (Object error) {
      showAlert('Error Purchase stream', const Icon(Icons.error));
    });

    try {
      final productsForSale =
          await inAppPurchaseService.loadProductsForSale({idProduct, 'product_1'});
      setState(() {
        products = productsForSale;
        isLoading = false;
      });
    } catch (e) {
      showAlert('Error load initStoreInfo', const Icon(Icons.error));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : !_isAvailable
                ? const Text('the store is unavailable')
                : products.isEmpty
                    ? const Text(
                        'empty',
                        style: TextStyle(color: Colors.black),
                      )
                    : Column(
                        children: products.map((product) {
                          if (products.isEmpty) {
                            return const Text(
                              'not found',
                              style: TextStyle(color: Colors.black),
                            );
                          }

                          return ListTile(
                            title: Text(
                              product.title,
                            ),
                            subtitle: Text(
                              product.description,
                            ),
                            trailing: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.green[800],
                                primary: Colors.white,
                              ),
                              child: Text(product.price),
                              onPressed: () async {
                                await inAppPurchaseService.makingAPurchase(product);
                              },
                            ),
                          );
                        }).toList(),
                      ),
      ),
    );
  }
}
