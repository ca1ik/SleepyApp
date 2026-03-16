import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleepy_ai/core/constants/app_constants.dart';

abstract class ProRepository {
  Future<bool> checkProStatus();
  Future<bool> purchaseMonthly();
  Future<bool> purchaseYearly();
  Future<void> restorePurchases();
}

class LocalProRepository implements ProRepository {
  LocalProRepository(this._prefs);

  final SharedPreferences _prefs;

  @override
  Future<bool> checkProStatus() async {
    return _prefs.getBool(AppStrings.prefIsPro) ?? false;
  }

  @override
  Future<bool> purchaseMonthly() async {
    // TODO: Integrate with in_app_purchase plugin when billing account ready
    // For now simulates a successful purchase flow
    await Future.delayed(const Duration(seconds: 2));
    await _prefs.setBool(AppStrings.prefIsPro, true);
    return true;
  }

  @override
  Future<bool> purchaseYearly() async {
    await Future.delayed(const Duration(seconds: 2));
    await _prefs.setBool(AppStrings.prefIsPro, true);
    return true;
  }

  @override
  Future<void> restorePurchases() async {
    await Future.delayed(const Duration(seconds: 1));
    // In production: query in_app_purchase.restorePurchases()
  }
}
