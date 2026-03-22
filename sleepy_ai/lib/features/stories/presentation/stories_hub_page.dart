import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sleepy_ai/core/constants/app_colors.dart';
import 'package:sleepy_ai/core/constants/app_constants.dart';
import 'package:sleepy_ai/core/constants/app_sizes.dart';
import 'package:sleepy_ai/features/stories/domain/story_data.dart';
import 'package:sleepy_ai/features/stories/domain/story_models.dart';

class StoriesHubPage extends StatefulWidget {
  const StoriesHubPage({super.key});

  @override
  State<StoriesHubPage> createState() => _StoriesHubPageState();
}

class _StoriesHubPageState extends State<StoriesHubPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmerCtrl;

  @override
  void initState() {
    super.initState();
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── App Bar ───────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.pagePaddingH,
                  AppSizes.md,
                  AppSizes.pagePaddingH,
                  0,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withAlpha(15),
                          border: Border.all(
                            color: Colors.white.withAlpha(30),
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white70,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSizes.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'sleepStories'.tr,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: AppSizes.fontXxl,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'storiesSubtitle'.tr,
                            style: TextStyle(
                              color: Colors.white.withAlpha(140),
                              fontSize: AppSizes.fontSm,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Text('📖', style: TextStyle(fontSize: 28)),
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.lg),

              // ─── Stories List ───────────────────────────────────
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.pagePaddingH,
                  ),
                  itemCount: kSleepStories.length,
                  itemBuilder: (_, i) => _StoryCard(
                    story: kSleepStories[i],
                    index: i,
                    shimmerCtrl: _shimmerCtrl,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StoryCard extends StatelessWidget {
  const _StoryCard({
    required this.story,
    required this.index,
    required this.shimmerCtrl,
  });

  final SleepStory story;
  final int index;
  final AnimationController shimmerCtrl;

  @override
  Widget build(BuildContext context) {
    final delay = index * 0.15;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 500 + index * 100),
      curve: Curves.easeOutCubic,
      builder: (_, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: child,
        ),
      ),
      child: GestureDetector(
        onTap: () => Get.toNamed(
          AppStrings.routeStoryPlayer,
          arguments: story,
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: AppSizes.md),
          padding: const EdgeInsets.all(AppSizes.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.radiusXl),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                story.bgGradientColors[0].withAlpha(200),
                story.bgGradientColors[1].withAlpha(180),
              ],
            ),
            border: Border.all(
              color: story.particleColor.withAlpha(40),
            ),
            boxShadow: [
              BoxShadow(
                color: story.particleColor.withAlpha(15),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              // Emoji + glow
              AnimatedBuilder(
                animation: shimmerCtrl,
                builder: (_, __) {
                  final glow =
                      (sin(shimmerCtrl.value * pi * 2 + delay) + 1) / 2;
                  return Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: story.lampColor.withAlpha(20),
                      boxShadow: [
                        BoxShadow(
                          color: story.lampColor.withAlpha((glow * 40).toInt()),
                          blurRadius: 15 + glow * 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        story.emoji,
                        style: const TextStyle(fontSize: 30),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(width: AppSizes.md),

              // Title + subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      story.titleKey.tr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: AppSizes.fontXl,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      story.subtitleKey.tr,
                      style: TextStyle(
                        color: Colors.white.withAlpha(150),
                        fontSize: AppSizes.fontSm,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: AppSizes.sm),

              // Scenes count + play icon
              Column(
                children: [
                  Icon(
                    Icons.play_circle_outline_rounded,
                    color: story.particleColor.withAlpha(180),
                    size: 28,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${story.scenes.length} ${'scenes'.tr}',
                    style: TextStyle(
                      color: Colors.white.withAlpha(100),
                      fontSize: AppSizes.fontXs,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
