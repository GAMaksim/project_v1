import 'package:flutter/foundation.dart';
import 'package:zzz/data/services/database_service.dart';

/// Purchase/subscription service.
/// Currently a stub — replace with RevenueCat integration when
/// App Store Connect and Google Play Console are configured.
class PurchaseService {
  static final PurchaseService _instance = PurchaseService._internal();
  factory PurchaseService() => _instance;
  PurchaseService._internal();

  final DatabaseService _db = DatabaseService();

  // TODO: Replace with your RevenueCat API keys
  // static const _iosApiKey = 'appl_XXXX';
  // static const _androidApiKey = 'goog_XXXX';

  /// Initialize RevenueCat SDK.
  Future<void> initialize() async {
    if (kIsWeb) return;

    // TODO: Uncomment when RevenueCat is configured
    // await Purchases.configure(
    //   PurchasesConfiguration(_iosApiKey)
    //     ..appUserID = null,
    // );

    debugPrint('PurchaseService initialized (stub mode)');
  }

  /// Check if user has active premium subscription.
  Future<bool> checkPremiumStatus() async {
    // TODO: Replace with RevenueCat check
    // try {
    //   final customerInfo = await Purchases.getCustomerInfo();
    //   return customerInfo.entitlements.active.containsKey('premium');
    // } catch (e) {
    //   debugPrint('Error checking premium: $e');
    //   return false;
    // }

    return _db.settings.isPremium;
  }

  /// Purchase monthly subscription ($2.99/month).
  Future<bool> purchaseMonthly() async {
    // TODO: Replace with RevenueCat purchase
    // try {
    //   final offerings = await Purchases.getOfferings();
    //   final package = offerings.current?.monthly;
    //   if (package != null) {
    //     await Purchases.purchasePackage(package);
    //     return true;
    //   }
    // } catch (e) {
    //   debugPrint('Purchase failed: $e');
    // }

    // Stub: just set premium
    _db.settings.isPremium = true;
    await _db.updateSettings(_db.settings);
    return true;
  }

  /// Purchase annual subscription ($19.99/year).
  Future<bool> purchaseAnnual() async {
    // TODO: Replace with RevenueCat purchase
    // Stub: just set premium
    _db.settings.isPremium = true;
    await _db.updateSettings(_db.settings);
    return true;
  }

  /// Restore previous purchases.
  Future<bool> restorePurchases() async {
    // TODO: Replace with RevenueCat restore
    // try {
    //   final customerInfo = await Purchases.restorePurchases();
    //   return customerInfo.entitlements.active.containsKey('premium');
    // } catch (e) {
    //   debugPrint('Restore failed: $e');
    //   return false;
    // }

    return _db.settings.isPremium;
  }
}
