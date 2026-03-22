import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sleepy_ai/core/constants/app_colors.dart';
import 'package:sleepy_ai/core/constants/app_sizes.dart';
import 'package:sleepy_ai/features/pro/cubit/pro_cubit.dart';
import 'package:sleepy_ai/features/pro/cubit/pro_state.dart';

class ProPaywallPage extends StatelessWidget {
  const ProPaywallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProCubit, ProState>(
      listener: (context, state) {
        if (state.isPro) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'proWelcome'.tr,
              ),
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
      builder: (context, state) {
        final cubit = context.read<ProCubit>();
        return Scaffold(
          backgroundColor: AppColors.backgroundDark,
          body: CustomScrollView(
            slivers: [
              // Gradient header
              SliverToBoxAdapter(
                child: Container(
                  height: 260,
                  decoration: const BoxDecoration(
                    gradient: AppColors.nightSkyGradient,
                  ),
                  child: Stack(
                    children: [
                      // Stars decoration
                      ..._buildStars(),
                      // Close button
                      Positioned(
                        top: MediaQuery.of(context).padding.top + 8,
                        left: 16,
                        child: IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: AppColors.textPrimary,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      // PRO badge
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 40),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.lg,
                                vertical: AppSizes.sm,
                              ),
                              decoration: BoxDecoration(
                                gradient: AppColors.goldGradient,
                                borderRadius: BorderRadius.circular(
                                  AppSizes.radiusXxl,
                                ),
                              ),
                              child: const Text(
                                '✨ SleepyApp PRO',
                                style: TextStyle(
                                  color: AppColors.backgroundDark,
                                  fontSize: AppSizes.fontXxl,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSizes.md),
                            Text(
                              'proPremiumExp'.tr,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
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

              // Features list
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'proWhatYouGet'.tr,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: AppSizes.fontXl,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSizes.md),
                      ..._kFeatures.map((f) => _FeatureRow(feature: f)),
                      const SizedBox(height: AppSizes.xl),

                      // Pricing cards
                      _PricingCard(
                        label: 'monthlyPlan'.tr,
                        price: state.monthlyPrice,
                        subtitle: 'monthlyLabel'.tr,
                        badge: null,
                        onTap:
                            state.isPurchasing ? null : cubit.purchaseMonthly,
                        isLoading: state.isPurchasing,
                      ),
                      const SizedBox(height: AppSizes.sm),
                      _PricingCard(
                        label: 'yearlyPlan'.tr,
                        price: state.yearlyPrice,
                        subtitle: 'yearlyLabel'.tr,
                        badge: 'bestValue'.tr,
                        onTap: state.isPurchasing ? null : cubit.purchaseYearly,
                        isLoading: state.isPurchasing,
                      ),
                      const SizedBox(height: AppSizes.md),

                      // Restore
                      Center(
                        child: TextButton(
                          onPressed: state.isPurchasing
                              ? null
                              : cubit.restorePurchases,
                          child: Text(
                            'restorePurchases'.tr,
                            style: const TextStyle(color: AppColors.textMuted),
                          ),
                        ),
                      ),

                      // Legal
                      Center(
                        child: Text(
                          'subscriptionNote'.tr,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.textDisabled,
                            fontSize: AppSizes.fontXs,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSizes.xxl),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildStars() {
    const positions = [
      Offset(40, 30),
      Offset(120, 50),
      Offset(200, 20),
      Offset(280, 60),
      Offset(320, 30),
      Offset(80, 80),
      Offset(240, 100),
      Offset(160, 70),
    ];
    return positions
        .map(
          (p) => Positioned(
            left: p.dx,
            top: p.dy,
            child: const Text(
              '✦',
              style: TextStyle(color: Colors.white24, fontSize: 8),
            ),
          ),
        )
        .toList();
  }
}

final _kFeatures = [
  _ProFeature(
    '🤖',
    'proSleepyAssistant'.tr,
    'proAssistantDesc'.tr,
  ),
  _ProFeature(
    '🎵',
    'proUnlimitedSounds'.tr,
    'proUnlimitedSoundsDesc'.tr,
  ),
  _ProFeature(
    '🤖',
    'proAiMoodMusic'.tr,
    'proAiMoodMusicDesc'.tr,
  ),
  _ProFeature('📚', 'proAllContent'.tr, 'proAllContentDesc'.tr),
  _ProFeature('🔔', 'proSmartAlarm'.tr, 'proSmartAlarmDesc'.tr),
  _ProFeature('📊', 'proAdvancedAnalysis'.tr, 'proAdvancedAnalysisDesc'.tr),
  _ProFeature('🏆', 'proSpecialBadges'.tr, 'proSpecialBadgesDesc'.tr),
  _ProFeature(
    '☁️',
    'proCloudSync'.tr,
    'proCloudSyncDesc'.tr,
  ),
  _ProFeature(
    '🚫',
    'noAdsTitle'.tr,
    'noAdsProActiveDesc'.tr,
  ),
];

class _ProFeature {
  const _ProFeature(this.emoji, this.title, this.subtitle);
  final String emoji;
  final String title;
  final String subtitle;
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.feature});
  final _ProFeature feature;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.sm),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primaryDark,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: Center(
              child: Text(feature.emoji, style: const TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature.title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: AppSizes.fontLg,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  feature.subtitle,
                  style: const TextStyle(
                    color: AppColors.textMuted,
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

class _PricingCard extends StatelessWidget {
  const _PricingCard({
    required this.label,
    required this.price,
    required this.subtitle,
    required this.onTap,
    this.badge,
    this.isLoading = false,
  });

  final String label;
  final String price;
  final String subtitle;
  final String? badge;
  final VoidCallback? onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final isHighlighted = badge != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSizes.md),
        decoration: BoxDecoration(
          gradient: isHighlighted ? AppColors.goldGradient : null,
          color: isHighlighted ? null : AppColors.backgroundCard,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          border: Border.all(
            color: isHighlighted ? Colors.transparent : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (badge != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: AppSizes.xs),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.sm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundDark,
                        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      ),
                      child: Text(
                        badge!,
                        style: TextStyle(
                          color: AppColors.accentGold,
                          fontSize: AppSizes.fontXs,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  Text(
                    label,
                    style: TextStyle(
                      color: isHighlighted
                          ? AppColors.backgroundDark
                          : AppColors.textPrimary,
                      fontSize: AppSizes.fontLg,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: isHighlighted
                          ? AppColors.backgroundDark.withOpacity(0.7)
                          : AppColors.textMuted,
                      fontSize: AppSizes.fontSm,
                    ),
                  ),
                ],
              ),
            ),
            if (isLoading)
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    price,
                    style: TextStyle(
                      color: isHighlighted
                          ? AppColors.backgroundDark
                          : AppColors.textPrimary,
                      fontSize: AppSizes.fontXxl,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: isHighlighted
                        ? AppColors.backgroundDark
                        : AppColors.textMuted,
                    size: 14,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
