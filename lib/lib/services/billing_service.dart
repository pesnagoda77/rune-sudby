import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BillingService {
  static final BillingService _instance = BillingService._internal();
  factory BillingService() => _instance;
  BillingService._internal();

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  static const String _premiumForeverId = 'premium_forever';
  static const String _premium30DaysId = 'premium_30days';
  static const String _premiumExpiryKey = 'premium_expiry_date';
  static const String _premiumTypeKey = 'premium_type'; // 'forever' | '30days'

  List<ProductDetails> _products = [];
  bool _available = false;
  bool _initialized = false;

  bool get isAvailable => _available;
  List<ProductDetails> get products => _products;

  Future<void> init() async {
    if (_initialized) return;

    _available = await _iap.isAvailable();
    if (!_available) return;

    _subscription = _iap.purchaseStream.listen(
      _onPurchaseUpdate,
      onDone: () => _subscription?.cancel(),
    );

    await _loadProducts();
    await _checkPendingPurchases();
    _initialized = true;
  }

  Future<void> _loadProducts() async {
    const ids = <String>{_premiumForeverId, _premium30DaysId};
    final response = await _iap.queryProductDetails(ids);
    _products = response.productDetails;
  }

  Future<void> _checkPendingPurchases() async {
    if (!_available) return;
    final prefs = await SharedPreferences.getInstance();
    await _iap.restorePurchases();
  }

  Future<bool> isPremium() async {
    final prefs = await SharedPreferences.getInstance();
    final type = prefs.getString(_premiumTypeKey);
    if (type == null) return false;

    if (type == 'forever') return true;

    final expiryStr = prefs.getString(_premiumExpiryKey);
    if (expiryStr == null) return false;

    final expiry = DateTime.tryParse(expiryStr);
    if (expiry == null) return false;

    return DateTime.now().isBefore(expiry);
  }

  Future<void> buyProduct(ProductDetails product) async {
    final purchaseParam = PurchaseParam(productDetails: product);
    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchases) async {
    final prefs = await SharedPreferences.getInstance();

    for (final purchase in purchases) {
      switch (purchase.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          if (purchase.productID == _premiumForeverId) {
            await prefs.setString(_premiumTypeKey, 'forever');
            await prefs.remove(_premiumExpiryKey);
          } else if (purchase.productID == _premium30DaysId) {
            final expiry = DateTime.now().add(const Duration(days: 30));
            await prefs.setString(_premiumTypeKey, '30days');
            await prefs.setString(_premiumExpiryKey, expiry.toIso8601String());
          }
          if (purchase.pendingCompletePurchase) {
            await _iap.completePurchase(purchase);
          }
          break;
        case PurchaseStatus.error:
          break;
        case PurchaseStatus.pending:
          break;
        default:
          break;
      }
    }
  }

  ProductDetails? get foreverProduct =>
      _products.where((p) => p.id == _premiumForeverId).firstOrNull;

  ProductDetails? get days30Product =>
      _products.where((p) => p.id == _premium30DaysId).firstOrNull;

  void dispose() {
    _subscription?.cancel();
  }
}
