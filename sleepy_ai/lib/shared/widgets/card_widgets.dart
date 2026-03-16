import 'package:flutter/material.dart';
import 'package:sleepy_ai/core/constants/app_colors.dart';
import 'package:sleepy_ai/core/constants/app_sizes.dart';
import 'package:sleepy_ai/shared/models/app_models.dart';
import 'package:sleepy_ai/shared/widgets/common_widgets.dart';

/// Dashboard metrik kartı — const constructor ile önbelleğe alınır.
/// Uyku süresi, kalite skoru, uyku saati gibi tek bir metriği gösterir.
class MetricCardWidget extends StatelessWidget {
  const MetricCardWidget({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    this.color,
    this.subtitle,
    this.onTap,
    this.gradient,
  });

  final String title;
  final String value;
  final String unit;
  final IconData icon;
  final Color? color;
  final String? subtitle;
  final VoidCallback? onTap;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    final cardColor = color ?? AppColors.primary;
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSizes.sm),
                decoration: BoxDecoration(
                  color: cardColor.withAlpha(40),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
                child: Icon(icon, color: cardColor, size: AppSizes.iconMd),
              ),
              if (subtitle != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.sm,
                    vertical: AppSizes.xs,
                  ),
                  decoration: BoxDecoration(
                    color: cardColor.withAlpha(30),
                    borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                  ),
                  child: Text(
                    subtitle!,
                    style: TextStyle(
                      color: cardColor,
                      fontSize: AppSizes.fontXs,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSizes.sm),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: AppSizes.fontDisplay,
                    fontWeight: FontWeight.w700,
                    height: 1.1,
                  ),
                ),
                TextSpan(
                  text: ' $unit',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: AppSizes.fontMd,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.xs),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: AppSizes.fontSm,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Gamification rozet kartı.
/// Kazanılmış rozet için parlak, kazanılmamış için soluk görünüm.
class BadgeCardWidget extends StatelessWidget {
  const BadgeCardWidget({super.key, required this.badge, this.onTap});

  final BadgeModel badge;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(AppSizes.md),
        decoration: BoxDecoration(
          gradient: badge.isEarned
              ? AppColors.cardGradient
              : const LinearGradient(
                  colors: [AppColors.backgroundCard, AppColors.backgroundCard],
                ),
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          border: Border.all(
            color: badge.isEarned
                ? AppColors.badgeGold.withAlpha(120)
                : AppColors.border,
            width: badge.isEarned ? 1.0 : 0.5,
          ),
          boxShadow: badge.isEarned
              ? [
                  BoxShadow(
                    color: AppColors.badgeGold.withAlpha(40),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Rozet emoji
            Stack(
              alignment: Alignment.topRight,
              children: [
                Text(
                  badge.emoji,
                  style: TextStyle(
                    fontSize: 36,
                    color: badge.isEarned ? null : null,
                  ),
                ),
                if (!badge.isEarned)
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: AppColors.badgeLocked,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lock,
                      size: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSizes.sm),
            Text(
              badge.titleTr,
              style: TextStyle(
                color: badge.isEarned
                    ? AppColors.badgeGold
                    : AppColors.textMuted,
                fontSize: AppSizes.fontSm,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (badge.isEarned && badge.earnedAt != null) ...[
              const SizedBox(height: AppSizes.xs),
              Text(
                'Kazanıldı ✓',
                style: const TextStyle(
                  color: AppColors.success,
                  fontSize: AppSizes.fontXs,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Ses kart widget'ı — ses kategorileri grid'inde kullanılır.
class SoundCardWidget extends StatelessWidget {
  const SoundCardWidget({
    super.key,
    required this.emoji,
    required this.name,
    required this.isPlaying,
    required this.color,
    required this.onTap,
    this.isPro = false,
    this.isFavorite = false,
    this.volume = 1.0,
  });

  final String emoji;
  final String name;
  final bool isPlaying;
  final Color color;
  final VoidCallback onTap;
  final bool isPro;
  final bool isFavorite;
  final double volume;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: isPlaying
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color.withAlpha(80), color.withAlpha(40)],
                )
              : AppColors.cardGradient,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          border: Border.all(
            color: isPlaying ? color.withAlpha(180) : AppColors.border,
            width: isPlaying ? 1.5 : 0.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8, top: 4),
                  child: Text(emoji, style: const TextStyle(fontSize: 32)),
                ),
                if (isPro)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppColors.proGradient,
                      borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                    ),
                    child: const Text(
                      'PRO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSizes.xs),
            Text(
              name,
              style: TextStyle(
                color: isPlaying ? color : AppColors.textSecondary,
                fontSize: AppSizes.fontSm,
                fontWeight: isPlaying ? FontWeight.w700 : FontWeight.w400,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (isPlaying) ...[
              const SizedBox(height: 4),
              _SoundWaveIndicator(color: color),
            ],
          ],
        ),
      ),
    );
  }
}

/// Animasyonlu ses dalgası göstergesi.
class _SoundWaveIndicator extends StatefulWidget {
  const _SoundWaveIndicator({required this.color});
  final Color color;

  @override
  State<_SoundWaveIndicator> createState() => _SoundWaveIndicatorState();
}

class _SoundWaveIndicatorState extends State<_SoundWaveIndicator>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      4,
      (i) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 400 + i * 100),
      )..repeat(reverse: true),
    );
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(4, (i) {
        return AnimatedBuilder(
          animation: _controllers[i],
          builder: (context, child) {
            return Container(
              width: 3,
              height: 4 + _controllers[i].value * 8,
              margin: const EdgeInsets.symmetric(horizontal: 1.5),
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(2),
              ),
            );
          },
        );
      }),
    );
  }
}
