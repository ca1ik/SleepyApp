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

class NoAdsPage extends StatelessWidget {
  const NoAdsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProCubit, ProState>(
      listener: (context, state) {
        if (!state.shouldShowAds && !state.isPurchasing) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('noAdsActivated'.tr),
              backgroundColor: AppColors.success,
            ),
          );
          Navigator.of(context).pop();
        } else if (state.status == ProStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error ?? 'purchaseFailed'.tr),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      builder: (context, proState) {
        return BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, settingsState) {
            final isDark = settingsState.isDarkMode;
            final cubit = context.read<ProCubit>();

            return Scaffold(
              backgroundColor:
                  isDark ? AppColors.backgroundDark : const Color(0xFFF5F0FF),
              body: CustomScrollView(
                slivers: [
                  // ── Gradient Header ───────────────────────────────
                  SliverToBoxAdapter(
                    child: Container(
                      height: 280,
                      decoration: BoxDecoration(
                        gradient: isDark
                            ? AppColors.nightSkyGradient
                            : const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xFFEDE5FF),
                                  Color(0xFFF5F0FF),
                                ],
                              ),
                      ),
                      child: Stack(
                        children: [
                          // Close button
                          Positioned(
                            top: MediaQuery.of(context).padding.top + 8,
                            left: 16,
                            child: IconButton(
                              icon: Icon(
                                Icons.close,
                                color: isDark
                                    ? AppColors.textPrimary
                                    : const Color(0xFF1A1A2E),
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ),
                          // Badge
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 40),
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        AppColors.primary,
                                        AppColors.accentBlue,
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary.withAlpha(100),
                                        blurRadius: 24,
                                        spreadRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.block_rounded,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                ),
                                const SizedBox(height: AppSizes.md),
                                Text(
                                  'noAdsTitle'.tr,
                                  style: TextStyle(
                                    color: isDark
                                        ? AppColors.textPrimary
                                        : const Color(0xFF1A1A2E),
                                    fontSize: AppSizes.fontXxl,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: AppSizes.xs),
                                Text(
                                  'noAdsSubtitle'.tr,
                                  style: TextStyle(
                                    color: isDark
                                        ? AppColors.textSecondary
                                        : const Color(0xFF6B5B93),
                                    fontSize: AppSizes.fontLg,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ── Content ───────────────────────────────────────
                  SliverPadding(
                    padding: const EdgeInsets.all(AppSizes.md),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // Avantajlar
                        _BenefitCard(
                          isDark: isDark,
                          emoji: '🚫',
                          title: 'noAdsBenefit1'.tr,
                          subtitle: 'noAdsBenefit1Desc'.tr,
                        ),
                        const SizedBox(height: AppSizes.sm),
                        _BenefitCard(
                          isDark: isDark,
                          emoji: '⚡',
                          title: 'noAdsBenefit2'.tr,
                          subtitle: 'noAdsBenefit2Desc'.tr,
                        ),
                        const SizedBox(height: AppSizes.sm),
                        _BenefitCard(
                          isDark: isDark,
                          emoji: '🌙',
                          title: 'noAdsBenefit3'.tr,
                          subtitle: 'noAdsBenefit3Desc'.tr,
                        ),
                        const SizedBox(height: AppSizes.xl),

                        // Zaten PRO ise bilgi göster
                        if (proState.isPro) ...[
                          _ProBadgeInfo(isDark: isDark),
                        ] else ...[
                          // Fiyat kartı
                          _NoAdsPricingCard(
                            price: proState.noAdsMonthlyPrice,
                            onTap: proState.isPurchasing ||
                                    !proState.isStoreAvailable
                                ? null
                                : cubit.purchaseNoAds,
                            isLoading: proState.isPurchasing,
                            isDark: isDark,
                          ),
                          const SizedBox(height: AppSizes.md),

                          // PRO'ya yükselt
                          _UpgradeToProCard(
                            isDark: isDark,
                            onTap: () {
                              Navigator.of(context).pop();
                              Get.toNamed(AppStrings.routePro);
                            },
                          ),
                          const SizedBox(height: AppSizes.md),

                          // Geri yükle
                          Center(
                            child: TextButton(
                              onPressed: proState.isPurchasing
                                  ? null
                                  : cubit.restorePurchases,
                              child: Text(
                                'restorePurchases'.tr,
                                style: TextStyle(
                                  color: isDark
                                      ? AppColors.textMuted
                                      : const Color(0xFF6B5B93),
                                ),
                              ),
                            ),
                          ),

                          // Legal
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.lg,
                              ),
                              child: Text(
                                'noAdsSubscriptionNote'.tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isDark
                                      ? AppColors.textDisabled
                                      : const Color(0xFF9E8EC0),
                                  fontSize: AppSizes.fontXs,
                                ),
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: AppSizes.xxl),
                      ]),
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

// ═══════════════════════════════════════════════════════════════════════════════
// BENEFİT CARD
// ═══════════════════════════════════════════════════════════════════════════════

class _BenefitCard extends StatelessWidget {
  const _BenefitCard({
    required this.isDark,
    required this.emoji,
    required this.title,
    required this.subtitle,
  });

  final bool isDark;
  final String emoji;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundCard : Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(
          color: isDark ? AppColors.border : AppColors.primary.withAlpha(20),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(isDark ? 40 : 20),
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.textPrimary
                        : const Color(0xFF1A1A2E),
                    fontSize: AppSizes.fontLg,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color:
                        isDark ? AppColors.textMuted : const Color(0xFF6B5B93),
                    fontSize: AppSizes.fontSm,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.check_circle_rounded,
            color: AppColors.success,
            size: 20,
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// FİYAT KARTI
// ═══════════════════════════════════════════════════════════════════════════════

class _NoAdsPricingCard extends StatelessWidget {
  const _NoAdsPricingCard({
    required this.price,
    required this.onTap,
    required this.isLoading,
    required this.isDark,
  });

  final String price;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSizes.lg),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withAlpha(60),
              blurRadius: 16,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'noAdsMonthlyPlan'.tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: AppSizes.fontXl,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'noAdsMonthlyLabel'.tr,
                    style: TextStyle(
                      color: Colors.white.withAlpha(180),
                      fontSize: AppSizes.fontSm,
                    ),
                  ),
                ],
              ),
            ),
            if (isLoading)
              const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    price,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: AppSizes.fontXxl + 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'monthlyLabel'.tr,
                    style: TextStyle(
                      color: Colors.white.withAlpha(180),
                      fontSize: AppSizes.fontSm,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// PRO'YA YÜKSELTMEYİ ÖNER
// ═══════════════════════════════════════════════════════════════════════════════

class _UpgradeToProCard extends StatelessWidget {
  const _UpgradeToProCard({
    required this.isDark,
    required this.onTap,
  });

  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSizes.md),
        decoration: BoxDecoration(
          color: isDark ? AppColors.backgroundCard : Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          border: Border.all(
            color: AppColors.accentGold.withAlpha(80),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: AppColors.goldGradient,
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
              child: const Icon(
                Icons.workspace_premium_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: AppSizes.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'noAdsUpgradePro'.tr,
                    style: TextStyle(
                      color: isDark
                          ? AppColors.textPrimary
                          : const Color(0xFF1A1A2E),
                      fontSize: AppSizes.fontLg,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'noAdsUpgradeProDesc'.tr,
                    style: TextStyle(
                      color: isDark
                          ? AppColors.textMuted
                          : const Color(0xFF6B5B93),
                      fontSize: AppSizes.fontSm,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: isDark ? AppColors.textMuted : const Color(0xFF6B5B93),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// PRO BADGE (zaten PRO olanlar için)
// ═══════════════════════════════════════════════════════════════════════════════

class _ProBadgeInfo extends StatelessWidget {
  const _ProBadgeInfo({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        gradient: AppColors.goldGradient,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.verified_rounded,
            color: Colors.white,
            size: 32,
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'noAdsProActive'.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: AppSizes.fontXl,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'noAdsProActiveDesc'.tr,
                  style: TextStyle(
                    color: Colors.white.withAlpha(200),
                    fontSize: AppSizes.fontSm,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
