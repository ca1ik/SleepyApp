import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sleepy_ai/core/constants/app_colors.dart';
import 'package:sleepy_ai/core/constants/app_sizes.dart';
import 'package:sleepy_ai/shared/widgets/common_widgets.dart';

/// Günün uyku ipucu — her gün dönen 21 ipucu
class DailyTip {
  const DailyTip({
    required this.titleKey,
    required this.bodyKey,
    required this.emoji,
    required this.category,
  });

  final String titleKey;
  final String bodyKey;
  final String emoji;
  final String category;
}

const List<DailyTip> kAllDailyTips = [
  DailyTip(
      titleKey: 'dt1Title',
      bodyKey: 'dt1Body',
      emoji: '🕐',
      category: 'routine'),
  DailyTip(
      titleKey: 'dt2Title',
      bodyKey: 'dt2Body',
      emoji: '📵',
      category: 'hygiene'),
  DailyTip(
      titleKey: 'dt3Title',
      bodyKey: 'dt3Body',
      emoji: '🌡️',
      category: 'environment'),
  DailyTip(
      titleKey: 'dt4Title',
      bodyKey: 'dt4Body',
      emoji: '☕',
      category: 'nutrition'),
  DailyTip(
      titleKey: 'dt5Title',
      bodyKey: 'dt5Body',
      emoji: '🏃',
      category: 'activity'),
  DailyTip(
      titleKey: 'dt6Title',
      bodyKey: 'dt6Body',
      emoji: '🧘',
      category: 'relaxation'),
  DailyTip(
      titleKey: 'dt7Title', bodyKey: 'dt7Body', emoji: '🌞', category: 'light'),
  DailyTip(
      titleKey: 'dt8Title',
      bodyKey: 'dt8Body',
      emoji: '📖',
      category: 'routine'),
  DailyTip(
      titleKey: 'dt9Title',
      bodyKey: 'dt9Body',
      emoji: '🛁',
      category: 'relaxation'),
  DailyTip(
      titleKey: 'dt10Title',
      bodyKey: 'dt10Body',
      emoji: '🍽️',
      category: 'nutrition'),
  DailyTip(
      titleKey: 'dt11Title',
      bodyKey: 'dt11Body',
      emoji: '🎵',
      category: 'relaxation'),
  DailyTip(
      titleKey: 'dt12Title',
      bodyKey: 'dt12Body',
      emoji: '🛏️',
      category: 'environment'),
  DailyTip(
      titleKey: 'dt13Title',
      bodyKey: 'dt13Body',
      emoji: '📝',
      category: 'routine'),
  DailyTip(
      titleKey: 'dt14Title',
      bodyKey: 'dt14Body',
      emoji: '🌿',
      category: 'environment'),
  DailyTip(
      titleKey: 'dt15Title',
      bodyKey: 'dt15Body',
      emoji: '🧊',
      category: 'hygiene'),
  DailyTip(
      titleKey: 'dt16Title',
      bodyKey: 'dt16Body',
      emoji: '😮‍💨',
      category: 'relaxation'),
  DailyTip(
      titleKey: 'dt17Title',
      bodyKey: 'dt17Body',
      emoji: '🥛',
      category: 'nutrition'),
  DailyTip(
      titleKey: 'dt18Title',
      bodyKey: 'dt18Body',
      emoji: '🧦',
      category: 'hygiene'),
  DailyTip(
      titleKey: 'dt19Title',
      bodyKey: 'dt19Body',
      emoji: '⏰',
      category: 'routine'),
  DailyTip(
      titleKey: 'dt20Title',
      bodyKey: 'dt20Body',
      emoji: '🫧',
      category: 'relaxation'),
  DailyTip(
      titleKey: 'dt21Title',
      bodyKey: 'dt21Body',
      emoji: '🌙',
      category: 'mindset'),
];

/// Günün ipuçlarını hesaplar — her gün 3 ipucu gösterilir
List<DailyTip> getTodaysTips() {
  final dayOfYear =
      DateTime.now().difference(DateTime(DateTime.now().year)).inDays;
  final startIndex = (dayOfYear * 3) % kAllDailyTips.length;
  return [
    kAllDailyTips[startIndex % kAllDailyTips.length],
    kAllDailyTips[(startIndex + 1) % kAllDailyTips.length],
    kAllDailyTips[(startIndex + 2) % kAllDailyTips.length],
  ];
}

class DailyTipsPage extends StatelessWidget {
  const DailyTipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              pinned: true,
              title: Text(
                'dailyTipsTitle'.tr,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.pagePaddingH,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: AppSizes.md),
                  // Today's featured
                  GlassCard(
                    padding: const EdgeInsets.all(AppSizes.md),
                    child: Column(
                      children: [
                        const Text('🌟', style: TextStyle(fontSize: 36)),
                        const SizedBox(height: AppSizes.xs),
                        Text(
                          'dailyTipsTodayPick'.tr,
                          style: const TextStyle(
                            color: AppColors.accentGold,
                            fontSize: AppSizes.fontLg,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppSizes.xs),
                        Text(
                          'dailyTipsSubtitle'.tr,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: AppSizes.fontSm,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSizes.lg),
                  // Today's 3 tips
                  Text(
                    'dailyTipsToday'.tr,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: AppSizes.fontLg,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  ...getTodaysTips().map(
                    (tip) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSizes.sm),
                      child: _TipCard(tip: tip),
                    ),
                  ),
                  const SizedBox(height: AppSizes.lg),
                  // All tips
                  Text(
                    'dailyTipsAll'.tr,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: AppSizes.fontLg,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  ...kAllDailyTips.map(
                    (tip) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSizes.sm),
                      child: _TipCard(tip: tip),
                    ),
                  ),
                  const SizedBox(height: AppSizes.xxxl),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  const _TipCard({required this.tip});

  final DailyTip tip;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Row(
        children: [
          Text(tip.emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tip.titleKey.tr,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  tip.bodyKey.tr,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: AppSizes.fontSm,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
