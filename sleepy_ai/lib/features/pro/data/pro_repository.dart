import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleepy_ai/core/constants/app_constants.dart';

/// Mağazadan dönen yerelleştirilmiş fiyat ve müsaitlik bilgisi.
class ProStoreCatalog {
  const ProStoreCatalog({
    required this.isStoreAvailable,
    required this.monthlyPrice,
    required this.yearlyPrice,
    required this.noAdsMonthlyPrice,
  });

  final bool isStoreAvailable;
  final String monthlyPrice;
  final String yearlyPrice;
  final String noAdsMonthlyPrice;

  static const ProStoreCatalog fallback = ProStoreCatalog(
    isStoreAvailable: false,
    monthlyPrice: '₺99,99',
    yearlyPrice: '₺799,99',
    noAdsMonthlyPrice: '₺49,99',
  );
}

abstract class ProRepository {
  Future<bool> checkProStatus();
  Future<bool> checkNoAdsStatus();
  Future<ProStoreCatalog> fetchStoreCatalog();
  Future<bool> purchaseMonthly();
  Future<bool> purchaseYearly();
  Future<bool> purchaseNoAds();
  Future<void> restorePurchases();
}

/// Gerçek Play Billing / StoreKit entegrasyonlu repository.
///
/// Hak (entitlement) cache'i [SharedPreferences] üzerinde tutulur; offline
/// açılışta PRO kullanıcı PRO görünür. Doğrulama [purchaseStream] ile gelir.
class LocalProRepository implements ProRepository {
  LocalProRepository(
    this._prefs, {
    InAppPurchase? inAppPurchase,
  })  : _inAppPurchase = inAppPurchase ?? InAppPurchase.instance,
        _knownProductIds = const {
          AppStrings.iapProMonthly,
          AppStrings.iapProYearly,
          AppStrings.iapNoAdsMonthly,
        } {
    _purchaseSubscription = _inAppPurchase.purchaseStream.listen(
      _onPurchaseUpdates,
      onError: (Object _) {
        _activePurchaseCompleter?.complete(false);
        _activePurchaseCompleter = null;
      },
    );
  }

  final SharedPreferences _prefs;
  final InAppPurchase _inAppPurchase;
  final Set<String> _knownProductIds;
  late final StreamSubscription<List<PurchaseDetails>> _purchaseSubscription;
  Completer<bool>? _activePurchaseCompleter;

  static const Duration _purchaseTimeout = Duration(seconds: 90);

  @override
  Future<bool> checkProStatus() async {
    return _prefs.getBool(AppStrings.prefIsPro) ?? false;
  }

  @override
  Future<bool> checkNoAdsStatus() async {
    final isPro = _prefs.getBool(AppStrings.prefIsPro) ?? false;
    if (isPro) return true;
    return _prefs.getBool(AppStrings.prefIsNoAds) ?? false;
  }

  @override
  Future<ProStoreCatalog> fetchStoreCatalog() async {
    final available = await _inAppPurchase.isAvailable();
    if (!available) return ProStoreCatalog.fallback;

    final response = await _inAppPurchase.queryProductDetails(_knownProductIds);
    if (response.error != null) {
      return ProStoreCatalog.fallback;
    }

    final productsById = <String, ProductDetails>{
      for (final product in response.productDetails) product.id: product,
    };

    String price(String id, String fallback) =>
        productsById[id]?.price ?? fallback;

    return ProStoreCatalog(
      isStoreAvailable: true,
      monthlyPrice: price(
        AppStrings.iapProMonthly,
        ProStoreCatalog.fallback.monthlyPrice,
      ),
      yearlyPrice: price(
        AppStrings.iapProYearly,
        ProStoreCatalog.fallback.yearlyPrice,
      ),
      noAdsMonthlyPrice: price(
        AppStrings.iapNoAdsMonthly,
        ProStoreCatalog.fallback.noAdsMonthlyPrice,
      ),
    );
  }

  @override
  Future<bool> purchaseMonthly() =>
      _purchaseSubscriptionProduct(AppStrings.iapProMonthly);

  @override
  Future<bool> purchaseYearly() =>
      _purchaseSubscriptionProduct(AppStrings.iapProYearly);

  @override
  Future<bool> purchaseNoAds() =>
      _purchaseSubscriptionProduct(AppStrings.iapNoAdsMonthly);

  @override
  Future<void> restorePurchases() => _inAppPurchase.restorePurchases();

  Future<bool> _purchaseSubscriptionProduct(String productId) async {
    final isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      throw StateError('Play Store şu anda kullanılamıyor.');
    }

    final response = await _inAppPurchase.queryProductDetails({productId});
    if (response.error != null) {
      throw StateError(response.error!.message);
    }

    ProductDetails? product;
    for (final detail in response.productDetails) {
      if (detail.id == productId) {
        product = detail;
        break;
      }
    }

    if (product == null) {
      throw StateError('Ürün bulunamadı: $productId');
    }

    if (_activePurchaseCompleter != null) {
      throw StateError('Devam eden bir satın alma var, lütfen bekleyin.');
    }

    final completer = Completer<bool>();
    _activePurchaseCompleter = completer;

    final launched = await _inAppPurchase.buyNonConsumable(
      purchaseParam: PurchaseParam(productDetails: product),
    );
    if (!launched) {
      _activePurchaseCompleter = null;
      return false;
    }

    final success = await completer.future.timeout(
      _purchaseTimeout,
      onTimeout: () => false,
    );
    if (!success) return false;

    if (productId == AppStrings.iapNoAdsMonthly) {
      return checkNoAdsStatus();
    }
    return checkProStatus();
  }

  Future<void> _onPurchaseUpdates(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (!_knownProductIds.contains(purchase.productID)) {
        if (purchase.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchase);
        }
        continue;
      }

      switch (purchase.status) {
        case PurchaseStatus.pending:
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          final granted = await _applyEntitlement(purchase.productID);
          if (purchase.pendingCompletePurchase) {
            await _inAppPurchase.completePurchase(purchase);
          }
          _activePurchaseCompleter?.complete(granted);
          _activePurchaseCompleter = null;
        case PurchaseStatus.error:
        case PurchaseStatus.canceled:
          if (purchase.pendingCompletePurchase) {
            await _inAppPurchase.completePurchase(purchase);
          }
          _activePurchaseCompleter?.complete(false);
          _activePurchaseCompleter = null;
      }
    }
  }

  Future<bool> _applyEntitlement(String productId) async {
    if (productId == AppStrings.iapNoAdsMonthly) {
      await _prefs.setBool(AppStrings.prefIsNoAds, true);
      return true;
    }
    if (productId == AppStrings.iapProMonthly ||
        productId == AppStrings.iapProYearly) {
      await _prefs.setBool(AppStrings.prefIsPro, true);
      await _prefs.setBool(AppStrings.prefIsNoAds, true);
      return true;
    }
    return false;
  }

  Future<void> dispose() => _purchaseSubscription.cancel();
}
