import 'package:flutter/foundation.dart';

/// Tek noktadan reklam kimlik yönetimi.
///
/// Üretimde gerçek AdMob unit ID'lerini `--dart-define` ile sağla:
///   --dart-define=ADMOB_ANDROID_BANNER_UNIT_ID=ca-app-pub-XXX/YYY
///   --dart-define=ADMOB_IOS_BANNER_UNIT_ID=ca-app-pub-XXX/ZZZ
///
/// Geliştirme ve debug modunda Google'ın resmi test ID'leri kullanılır.
abstract final class MonetizationConfig {
  // Google'ın resmi test reklam birim ID'leri.
  static const String _androidBannerTestId =
      'ca-app-pub-3940256099942544/6300978111';
  static const String _iosBannerTestId =
      'ca-app-pub-3940256099942544/2934735716';

  static const String _androidBannerProdId = String.fromEnvironment(
    'ADMOB_ANDROID_BANNER_UNIT_ID',
    defaultValue: _androidBannerTestId,
  );

  static const String _iosBannerProdId = String.fromEnvironment(
    'ADMOB_IOS_BANNER_UNIT_ID',
    defaultValue: _iosBannerTestId,
  );

  static String get bannerAdUnitId {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return kReleaseMode ? _iosBannerProdId : _iosBannerTestId;
    }
    return kReleaseMode ? _androidBannerProdId : _androidBannerTestId;
  }
}
