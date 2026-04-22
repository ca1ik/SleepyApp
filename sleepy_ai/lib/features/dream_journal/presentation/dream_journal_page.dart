import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sleepy_ai/core/constants/app_colors.dart';
import 'package:sleepy_ai/core/constants/app_sizes.dart';
import 'package:sleepy_ai/features/dream_journal/cubit/dream_journal_cubit.dart';
import 'package:sleepy_ai/features/dream_journal/cubit/dream_journal_state.dart';
import 'package:sleepy_ai/features/dream_journal/domain/dream_models.dart';
import 'package:sleepy_ai/shared/widgets/common_widgets.dart';

class DreamJournalPage extends StatelessWidget {
  const DreamJournalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: BlocBuilder<DreamJournalCubit, DreamJournalState>(
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  pinned: true,
                  title: Text(
                    'dreamJournalTitle'.tr,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () => _showAddDreamSheet(context),
                      icon: const Icon(Icons.add_circle_outline,
                          color: AppColors.accent),
                    ),
                  ],
                ),
                // Stats bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.pagePaddingH,
                    ),
                    child: _StatsRow(state: state),
                  ),
                ),
                // Emotion filters
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSizes.pagePaddingH),
                    child: _EmotionFilterRow(
                      selected: state.filterEmotion,
                      onSelected: (e) =>
                          context.read<DreamJournalCubit>().setFilter(e),
                    ),
                  ),
                ),
                // Dream list
                if (state.filteredDreams.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🌙', style: TextStyle(fontSize: 64)),
                          const SizedBox(height: AppSizes.md),
                          Text(
                            'dreamJournalEmpty'.tr,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: AppSizes.fontMd,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.pagePaddingH,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (ctx, i) => Padding(
                          padding: const EdgeInsets.only(bottom: AppSizes.sm),
                          child: _DreamCard(
                            dream: state.filteredDreams[i],
                            onDelete: () => context
                                .read<DreamJournalCubit>()
                                .deleteDream(state.filteredDreams[i].id),
                          ),
                        ),
                        childCount: state.filteredDreams.length,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDreamSheet(context),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }

  void _showAddDreamSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.backgroundCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<DreamJournalCubit>(),
        child: const _AddDreamSheet(),
      ),
    );
  }
}

// ─── Stats Row ────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.state});

  final DreamJournalState state;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatChip(
          emoji: '📝',
          value: '${state.totalDreams}',
          label: 'dreamTotal'.tr,
        ),
        const SizedBox(width: AppSizes.sm),
        _StatChip(
          emoji: '✨',
          value: '${state.lucidDreams}',
          label: 'dreamLucid'.tr,
        ),
        const SizedBox(width: AppSizes.sm),
        _StatChip(
          emoji: '🔄',
          value: '${state.recurringDreams}',
          label: 'dreamRecurring'.tr,
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.emoji,
    required this.value,
    required this.label,
  });

  final String emoji;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GlassCard(
        padding: const EdgeInsets.all(AppSizes.sm),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: AppSizes.fontLg,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Emotion Filter Row ──────────────────────────────────────────────────────

class _EmotionFilterRow extends StatelessWidget {
  const _EmotionFilterRow({required this.selected, required this.onSelected});

  final DreamEmotion? selected;
  final ValueChanged<DreamEmotion?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _FilterChip(
            label: 'all'.tr,
            isSelected: selected == null,
            onTap: () => onSelected(null),
          ),
          ...DreamEmotion.values.map(
            (e) => _FilterChip(
              label: '${e.emoji} ${e.labelKey.tr}',
              isSelected: selected == e,
              onTap: () => onSelected(selected == e ? null : e),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: AppSizes.xs),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: AppSizes.xs,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withAlpha(60)
              : AppColors.backgroundCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              fontSize: AppSizes.fontSm,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Dream Card ───────────────────────────────────────────────────────────────

class _DreamCard extends StatelessWidget {
  const _DreamCard({required this.dream, required this.onDelete});

  final DreamEntry dream;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final dateStr = '${dream.date.day}.${dream.date.month}.${dream.date.year}';
    return GlassCard(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                dream.emotions.isNotEmpty ? dream.emotions.first.emoji : '💭',
                style: const TextStyle(fontSize: 28),
              ),
              const SizedBox(width: AppSizes.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dream.title,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: AppSizes.fontMd,
                      ),
                    ),
                    Text(
                      dateStr,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: AppSizes.fontSm,
                      ),
                    ),
                  ],
                ),
              ),
              if (dream.isRecurring)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withAlpha(30),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '🔄 ${'dreamRecurring'.tr}',
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontSize: 10,
                    ),
                  ),
                ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(
                  Icons.delete_outline,
                  color: AppColors.textMuted,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            dream.description,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: AppSizes.fontSm,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSizes.sm),
          // Lucidity + Emotion tags
          Row(
            children: [
              // Lucidity bar
              Text(
                '${'dreamLucidity'.tr}: ',
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                ),
              ),
              ...List.generate(
                5,
                (i) => Icon(
                  i < dream.lucidityLevel
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  color: AppColors.accentGold,
                  size: 14,
                ),
              ),
              const Spacer(),
              // Emotion emojis
              ...dream.emotions.map(
                (e) => Padding(
                  padding: const EdgeInsets.only(left: 2),
                  child: Text(e.emoji, style: const TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Add Dream Sheet ──────────────────────────────────────────────────────────

class _AddDreamSheet extends StatefulWidget {
  const _AddDreamSheet();

  @override
  State<_AddDreamSheet> createState() => _AddDreamSheetState();
}

class _AddDreamSheetState extends State<_AddDreamSheet> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _selectedEmotions = <DreamEmotion>{};
  int _lucidity = 0;
  bool _isRecurring = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(
        left: AppSizes.pagePaddingH,
        right: AppSizes.pagePaddingH,
        top: AppSizes.lg,
        bottom: bottomInset + AppSizes.lg,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.md),
            Text(
              'dreamAddTitle'.tr,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: AppSizes.fontXl,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSizes.md),
            // Title
            TextField(
              controller: _titleCtrl,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'dreamTitleHint'.tr,
                hintStyle: const TextStyle(color: AppColors.textMuted),
                filled: true,
                fillColor: AppColors.backgroundMid,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            // Description
            TextField(
              controller: _descCtrl,
              maxLines: 4,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'dreamDescHint'.tr,
                hintStyle: const TextStyle(color: AppColors.textMuted),
                filled: true,
                fillColor: AppColors.backgroundMid,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: AppSizes.md),
            // Emotions
            Text(
              'dreamEmotions'.tr,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSizes.xs),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: DreamEmotion.values
                  .map(
                    (e) => GestureDetector(
                      onTap: () => setState(() {
                        if (_selectedEmotions.contains(e)) {
                          _selectedEmotions.remove(e);
                        } else {
                          _selectedEmotions.add(e);
                        }
                      }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _selectedEmotions.contains(e)
                              ? AppColors.primary.withAlpha(50)
                              : AppColors.backgroundMid,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _selectedEmotions.contains(e)
                                ? AppColors.primary
                                : AppColors.divider,
                          ),
                        ),
                        child: Text(
                          '${e.emoji} ${e.labelKey.tr}',
                          style: TextStyle(
                            color: _selectedEmotions.contains(e)
                                ? AppColors.primary
                                : AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: AppSizes.md),
            // Lucidity
            Text(
              '${'dreamLucidity'.tr}: $_lucidity/5',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            Slider(
              value: _lucidity.toDouble(),
              max: 5,
              divisions: 5,
              activeColor: AppColors.primary,
              inactiveColor: AppColors.divider,
              onChanged: (v) => setState(() => _lucidity = v.round()),
            ),
            // Recurring toggle
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'dreamIsRecurring'.tr,
                style: const TextStyle(color: AppColors.textPrimary),
              ),
              value: _isRecurring,
              activeColor: AppColors.primary,
              onChanged: (v) => setState(() => _isRecurring = v),
            ),
            const SizedBox(height: AppSizes.md),
            // Save button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                ),
                child: Text(
                  'dreamSave'.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _save() {
    if (_titleCtrl.text.trim().isEmpty) return;
    final entry = DreamEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      emotions: _selectedEmotions.toList(),
      lucidityLevel: _lucidity,
      isRecurring: _isRecurring,
    );
    context.read<DreamJournalCubit>().addDream(entry);
    Navigator.of(context).pop();
  }
}
