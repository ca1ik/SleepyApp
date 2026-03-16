import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleepy_ai/core/constants/app_colors.dart';
import 'package:sleepy_ai/core/constants/app_constants.dart';
import 'package:sleepy_ai/core/constants/app_sizes.dart';
import 'package:sleepy_ai/features/learning/cubit/learning_cubit.dart';
import 'package:sleepy_ai/features/learning/cubit/learning_state.dart';
import 'package:sleepy_ai/shared/models/app_models.dart';
import 'package:sleepy_ai/shared/widgets/common_widgets.dart';

class LearningPage extends StatelessWidget {
  const LearningPage({super.key});

  static const _cats = [
    'Tümü',
    'Biyoloji',
    'Teknoloji',
    'Beslenme',
    'Ortam',
    'Teknik',
    'Spor',
    'Psikoloji',
    'Hijyen',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AppBar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.pagePaddingH,
                  vertical: AppSizes.sm,
                ),
                child: Row(
                  children: [
                    const BackButton(color: AppColors.textPrimary),
                    const Expanded(
                      child: Text(
                        'Uyku Rehberi 📖',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: AppSizes.fontLg,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Arama
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.pagePaddingH,
                ),
                child: TextField(
                  onChanged: context.read<LearningCubit>().search,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(
                    hintText: 'Makale ara...',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.sm),
              // Kategori filtresi
              SizedBox(
                height: 36,
                child: BlocBuilder<LearningCubit, LearningState>(
                  builder: (ctx, state) {
                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.md,
                      ),
                      itemCount: _cats.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(width: AppSizes.xs),
                      itemBuilder: (_, i) {
                        final label = _cats[i];
                        final isAll = i == 0;
                        final isSelected = isAll
                            ? state.selectedCategory == null
                            : state.selectedCategory == label;
                        return GestureDetector(
                          onTap: () => ctx
                              .read<LearningCubit>()
                              .filterByCategory(isAll ? null : label),
                          child: AnimatedContainer(
                            duration: AppDurations.fast,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.surfaceVariant,
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusFull,
                              ),
                            ),
                            child: Text(
                              label,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textSecondary,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.normal,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSizes.sm),
              // Liste
              Expanded(
                child: BlocBuilder<LearningCubit, LearningState>(
                  builder: (ctx, state) {
                    if (state.filteredArticles.isEmpty) {
                      return const Center(
                        child: Text(
                          'Makale bulunamadı.',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      );
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.pagePaddingH,
                        vertical: AppSizes.sm,
                      ),
                      itemCount: state.filteredArticles.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: AppSizes.sm),
                      itemBuilder: (_, i) =>
                          _ArticleCard(article: state.filteredArticles[i]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  const _ArticleCard({required this.article});

  final SleepTipModel article;

  static const _categoryEmojis = <String, String>{
    'Biyoloji': '🧬',
    'Teknoloji': '📱',
    'Beslenme': '🥗',
    'Ortam': '🌡️',
    'Teknik': '⚡',
    'Spor': '🏃',
    'Psikoloji': '🧠',
    'Hijyen': '🛏️',
  };

  @override
  Widget build(BuildContext context) {
    final emoji = _categoryEmojis[article.category] ?? '📖';
    return GlassCard(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  article.body,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: AppSizes.fontSm,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      ),
                      child: Text(
                        article.category,
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSizes.sm),
                    const Icon(
                      Icons.timer_outlined,
                      size: 12,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${article.readTimeMinutes} dk',
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
