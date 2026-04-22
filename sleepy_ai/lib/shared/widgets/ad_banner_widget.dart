import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sleepy_ai/core/config/monetization_config.dart';
import 'package:sleepy_ai/core/constants/app_colors.dart';
import 'package:sleepy_ai/core/constants/app_constants.dart';
import 'package:sleepy_ai/core/constants/app_sizes.dart';
import 'package:sleepy_ai/features/pro/cubit/pro_cubit.dart';
import 'package:sleepy_ai/features/pro/cubit/pro_state.dart';
import 'package:sleepy_ai/features/settings/cubit/settings_cubit.dart';
import 'package:sleepy_ai/features/settings/cubit/settings_state.dart';

/// Reklam alanÄ± â€” PRO veya No Ads aboneleri gÃ¶rmez.
/// Reklamlar gerÃ§ek AdMob `BannerAd` ile servis edilir.
class AdBannerWidget extends StatelessWidget {
  const AdBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProCubit, ProState>(
      builder: (context, proState) {
        if (!proState.shouldShowAds) return const SizedBox.shrink();

        return BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, settingsState) {
            final isDark = settingsState.isDarkMode;
            return Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(
                horizontal: AppSizes.md,
                vertical: AppSizes.sm,
              ),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.backgroundCard
                    : const Color(0xFFEDE5FF),
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                border: Border.all(
                  color: isDark
                      ? AppColors.border
                      : AppColors.primary.withAlpha(30),
                ),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.lg,
                      vertical: AppSizes.md,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const _AdMobBanner(),
                        const SizedBox(height: AppSizes.xs),
                        Text(
                          'removeAdsHint'.tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isDark
                                ? AppColors.textDisabled
                                : const Color(0xFF9E8EC0),
                            fontSize: AppSizes.fontXs,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                        onTap: () => Get.toNamed(AppStrings.routeNoAds),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.sm,
                            vertical: 4,
                          ),
                          child: Text(
                            'removeAds'.tr,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: AppSizes.fontXs,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _AdMobBanner extends StatefulWidget {
  const _AdMobBanner();

  @override
  State<_AdMobBanner> createState() => _AdMobBannerState();
}

class _AdMobBannerState extends State<_AdMobBanner> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      adUnitId: MonetizationConfig.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (!mounted) return;
          setState(() => _isLoaded = true);
        },
        onAdFailedToLoad: (ad, _) {
          ad.dispose();
          if (!mounted) return;
          setState(() => _isLoaded = false);
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ad = _bannerAd;
    if (!_isLoaded || ad == null) {
      return const SizedBox(height: 50);
    }
    return SizedBox(
      width: ad.size.width.toDouble(),
      height: ad.size.height.toDouble(),
      child: AdWidget(ad: ad),
    );
  }
}
