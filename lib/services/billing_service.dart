import 'dart:async';
import 'package:activation_codes/activation_codes.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Биллинг Руны Судьбы 1.2.1.
///
/// Модель:
/// - premium_forever — разовая покупка (non-consumable), без изменений;
/// - premium_monthly — ПОДПИСКА с автопродлением (Google ведёт статус
///   и продление; приложение не фабрикует локальные сроки);
/// - коды активации (task 091): FOREVER — Premium навсегда, MONTH — Premium
///   до даты кода; права по коду объединяются со стором по максимуму.
///
/// Старый one-time продукт premium_30days (1.1.8) отключается в Play Console
/// при релизе 1.1.9 — entitlement его покупателей снимается синхронизацией
/// со стором (restore при старте присылает только активные покупки).
class BillingService {
  static final BillingService _instance = BillingService._internal();
  factory BillingService() => _instance;
  BillingService._internal();

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  static const String _premiumForeverId = 'premium_forever';
  static const String _premium30DaysSubId = 'premium_monthly';
  static const String _premiumTypeKey = 'premium_type'; // 'forever' | '30days'
  static const String _premiumExpiryKey = 'premium_expiry_date'; // legacy 1.1.8
  static const String _premiumCodeExpiryKey =
      'premium_code_expiry_date'; // код MONTH (task 091)

  List<ProductDetails> _products = [];
  bool _available = false;
  bool _initialized = false;
  bool _sawActiveSubscription = false;

  bool get isAvailable => _available;
  List<ProductDetails> get products => _products;

  /// Сообщения для UI: отмена, ошибка, недоступность магазина.
  final StreamController<String> _messages = StreamController<String>.broadcast();
  Stream<String> get messages => _messages.stream;

  Future<void> init() async {
    if (_initialized) return;

    _available = await _iap.isAvailable();
    if (!_available) return;

    _subscription = _iap.purchaseStream.listen(
      _onPurchaseUpdate,
      onDone: () => _subscription?.cancel(),
    );

    await _loadProducts();

    // Синхронизация entitlement с Play при старте: restore присылает только
    // активные покупки/подписки. Если подписка не пришла — снимаем «30days».
    _sawActiveSubscription = false;
    await _iap.restorePurchases();
    _scheduleEntitlementSync();

    _initialized = true;
  }

  Future<void> _loadProducts() async {
    const ids = <String>{_premiumForeverId, _premium30DaysSubId};
    final response = await _iap.queryProductDetails(ids);
    _products = response.productDetails;
  }

  void _scheduleEntitlementSync() {
    Timer(const Duration(seconds: 3), _syncSubscriptionEntitlement);
  }

  Future<void> _syncSubscriptionEntitlement() async {
    if (!_available || _sawActiveSubscription) return;
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString(_premiumTypeKey) == '30days') {
      await prefs.remove(_premiumTypeKey);
      await prefs.remove(_premiumExpiryKey);
    }
  }

  Future<void> _onPurchaseUpdate(List<PurchaseDetails> purchases) async {
    final prefs = await SharedPreferences.getInstance();

    for (final purchase in purchases) {
      switch (purchase.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          if (purchase.productID == _premiumForeverId) {
            await prefs.setString(_premiumTypeKey, 'forever');
            await prefs.remove(_premiumExpiryKey);
          } else if (purchase.productID == _premium30DaysSubId) {
            _sawActiveSubscription = true;
            // «Навсегда» (покупка или код FOREVER) не укорачиваем подпиской:
            // права объединяются по максимуму (task 091).
            if (prefs.getString(_premiumTypeKey) != 'forever') {
              await prefs.setString(_premiumTypeKey, '30days');
              await prefs.remove(_premiumExpiryKey); // срок ведёт Google
            }
          }
          if (purchase.pendingCompletePurchase) {
            await _iap.completePurchase(purchase);
          }
          break;
        case PurchaseStatus.canceled:
          _messages.add('msgPurchaseCanceled');
          break;
        case PurchaseStatus.error:
          final code = purchase.error?.code ?? '';
          if (code.toLowerCase().contains('cancel')) {
            _messages.add('msgPurchaseCanceled');
          } else {
            _messages.add('msgPurchaseError');
          }
          break;
        case PurchaseStatus.pending:
          break;
      }
    }
  }

  Future<bool> isPremium() async {
    final prefs = await SharedPreferences.getInstance();
    final type = prefs.getString(_premiumTypeKey);
    if (type == 'forever') return true;

    if (type == '30days') {
      // Подписка premium_monthly (1.1.9): Google ведёт продление. Legacy
      // 1.1.8 — со сроком; истёкший legacy не выкидываем сразу — код MONTH
      // может продлевать доступ (task 091).
      final expiryStr = prefs.getString(_premiumExpiryKey);
      if (expiryStr == null) return true;
      final expiry = DateTime.tryParse(expiryStr);
      if (expiry == null) return true;
      if (DateTime.now().isBefore(expiry)) return true;
    }

    // Код MONTH: доступ до даты кода.
    final codeExpiryStr = prefs.getString(_premiumCodeExpiryKey);
    if (codeExpiryStr != null) {
      final codeExpiry = DateTime.tryParse(codeExpiryStr);
      if (codeExpiry != null && DateTime.now().isBefore(codeExpiry)) {
        return true;
      }
    }
    return false;
  }

  /// Выдача прав по результату активации кода (task 091).
  ///
  /// FOREVER — навсегда, не перетирается ничем (повторной активацией,
  /// отменой подписки, синком со стором). MONTH — Premium до даты кода;
  /// действующую подписку не укорачивает, дату кода только продлевает.
  Future<void> applyCodeResult(CodeResult result) async {
    if (!result.ok) return;
    final prefs = await SharedPreferences.getInstance();
    switch (result.typeKey) {
      case 'FOREVER':
        await prefs.setString(_premiumTypeKey, 'forever');
        await prefs.remove(_premiumExpiryKey);
        await prefs.remove(_premiumCodeExpiryKey);
        break;
      case 'MONTH':
        final expiresAt = result.expiresAt;
        if (expiresAt == null) return;
        if (prefs.getString(_premiumTypeKey) == 'forever') return;
        // Не укорачиваем: более поздняя дата побеждает.
        final existingStr = prefs.getString(_premiumCodeExpiryKey);
        final existing =
            existingStr == null ? null : DateTime.tryParse(existingStr);
        if (existing != null && existing.isAfter(expiresAt)) return;
        await prefs.setString(
            _premiumCodeExpiryKey, expiresAt.toIso8601String());
        break;
    }
  }

  /// Ждёт подтверждения покупки (пока Play пришлёт событие в стрим).
  Future<bool> waitForPremium({
    Duration timeout = const Duration(seconds: 60),
  }) async {
    final deadline = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(deadline)) {
      if (await isPremium()) return true;
      await Future.delayed(const Duration(seconds: 1));
    }
    return false;
  }

  /// Цена для отображения: у GooglePlayProductDetails.price уже собран
  /// из первой фазы оффера подписки; для разовой покупки — обычная цена.
  String displayPrice(ProductDetails product) => product.price;

  Future<void> buyProduct(ProductDetails product) async {
    final PurchaseParam param = product is GooglePlayProductDetails
        ? GooglePlayPurchaseParam(productDetails: product, offerToken: product.offerToken)
        : PurchaseParam(productDetails: product);
    await _iap.buyNonConsumable(purchaseParam: param);
  }

  /// Ручное восстановление покупок (кнопка на экране премиума).
  /// Возвращает итог: есть ли активный премиум после синка со стором.
  Future<bool> restore() async {
    if (!_available) {
      _messages.add('msgStoreUnavailable');
      return false;
    }
    _sawActiveSubscription = false;
    await _iap.restorePurchases();
    await Future.delayed(const Duration(seconds: 3));
    await _syncSubscriptionEntitlement();
    return isPremium();
  }

  ProductDetails? get foreverProduct =>
      _products.where((p) => p.id == _premiumForeverId).firstOrNull;

  ProductDetails? get days30Product =>
      _products.where((p) => p.id == _premium30DaysSubId).firstOrNull;

  void dispose() {
    _subscription?.cancel();
  }
}
