import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sleepy_ai/core/constants/app_colors.dart';
import 'package:sleepy_ai/core/constants/app_constants.dart';
import 'package:sleepy_ai/core/constants/app_sizes.dart';
import 'package:sleepy_ai/features/pro/cubit/pro_cubit.dart';
import 'package:sleepy_ai/features/pro/cubit/pro_state.dart';
import 'package:sleepy_ai/features/settings/cubit/settings_cubit.dart';
import 'package:sleepy_ai/features/settings/cubit/settings_state.dart';

/// Reklam alanı — PRO veya No Ads aboneleri görmez.
/// Gerçek AdMob entegrasyonu hazır olduğunda buradaki mock banner
/// google_mobile_ads BannerAd ile değiştirilecek.
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
                color:
                    isDark ? AppColors.backgroundCard : const Color(0xFFEDE5FF),
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                border: Border.all(
                  color: isDark
                      ? AppColors.border
                      : AppColors.primary.withAlpha(30),
                ),
              ),
              child: Stack(
                children: [
                  // Mock ad content — gerçek AdMob entegrasyonunda kaldırılacak
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.lg,
                      vertical: AppSizes.md,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withAlpha(30),
                            borderRadius:
                                BorderRadius.circular(AppSizes.radiusSm),
                          ),
                          child: const Icon(
                            Icons.campaign_rounded,
                            color: AppColors.primary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: AppSizes.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'adPlaceholder'.tr,
                                style: TextStyle(
                                  color: isDark
                                      ? AppColors.textMuted
                                      : const Color(0xFF6B5B93),
                                  fontSize: AppSizes.fontSm,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'removeAdsHint'.tr,
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
                      ],
                    ),
                  ),
                  // "Remove Ads" tıklanabilir alan
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
