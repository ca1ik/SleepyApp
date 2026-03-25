import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sleepy_ai/core/constants/app_colors.dart';
import 'package:sleepy_ai/core/constants/app_constants.dart';
import 'package:sleepy_ai/core/constants/app_sizes.dart';
import 'package:sleepy_ai/features/pro/cubit/pro_cubit.dart';
import 'package:sleepy_ai/features/pro/cubit/pro_state.dart';
import 'package:sleepy_ai/features/sounds/cubit/sounds_cubit.dart';
import 'package:sleepy_ai/features/sounds/cubit/sounds_state.dart';
import 'package:sleepy_ai/shared/models/app_models.dart';
import 'package:sleepy_ai/shared/widgets/card_widgets.dart';
import 'package:sleepy_ai/shared/widgets/common_widgets.dart';

class SoundsPage extends StatefulWidget {
  const SoundsPage({super.key});

  @override
  State<SoundsPage> createState() => _SoundsPageState();
}

class _SoundsPageState extends State<SoundsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _aiController = TextEditingController();

  final _categories = [
    (label: 'catAll'.tr, category: null as SoundCategory?),
    (label: 'catNature'.tr, category: SoundCategory.nature),
    (label: 'catRain'.tr, category: SoundCategory.rain),
    (label: 'catWhiteNoise'.tr, category: SoundCategory.whiteNoise),
    (label: 'catAmbient'.tr, category: SoundCategory.ambient),
    (label: 'catMedieval'.tr, category: SoundCategory.medieval),
    (label: 'catLullaby'.tr, category: SoundCategory.lullaby),
    (label: 'catInstrument'.tr, category: SoundCategory.instrument),
    (label: 'catMeditation'.tr, category: SoundCategory.meditation),
    (label: 'catBinaural'.tr, category: SoundCategory.binaural),
    (label: 'catHappy'.tr, category: SoundCategory.happy),
    (label: 'catPrayer'.tr, category: SoundCategory.prayer),
    (label: 'catFavorites'.tr, category: null as SoundCategory?),
  ];

  int _selectedCatIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _aiController.dispose();
    super.dispose();
  }

  List<SoundModel> _filtered(SoundsState state) {
    // Son tab = favoriler
    if (_selectedCatIndex == _categories.length - 1) {
      return state.allSounds
          .where((s) => state.favorites.contains(s.id))
          .toList();
    }
    final cat = _categories[_selectedCatIndex].category;
    if (cat == null) return state.allSounds;
    return state.allSounds.where((s) => s.category == cat).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: BlocBuilder<SoundsCubit, SoundsState>(
          builder: (context, state) {
            return Column(
              children: [
                // AppBar
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.pagePaddingH,
                      vertical: AppSizes.sm,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'soundsAndMusic'.tr,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: AppSizes.fontLg,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        // Mixer toggle
                        if (state.hasTracks)
                          GestureDetector(
                            onTap: () => context
                                .read<SoundsCubit>()
                                .toggleMixerVisibility(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.md,
                                vertical: AppSizes.xs,
                              ),
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                borderRadius: BorderRadius.circular(
                                  AppSizes.radiusMd,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.tune_rounded,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${state.activeTracks.length}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                // Tab bar (Sesler / YZ Modu)
                TabBar(
                  controller: _tabController,
                  indicatorColor: AppColors.primaryLight,
                  labelColor: AppColors.primaryLight,
                  unselectedLabelColor: AppColors.textSecondary,
                  tabs: [
                    Tab(text: 'soundLibrary'.tr),
                    Tab(text: 'aiMoodMusic'.tr),
                  ],
                ),
                // Content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _SoundsLibraryTab(
                        state: state,
                        categories: _categories.map((c) => c.label).toList(),
                        selectedIndex: _selectedCatIndex,
                        onCategorySelected: (i) =>
                            setState(() => _selectedCatIndex = i),
                        filtered: _filtered(state),
                      ),
                      _AiMoodTab(
                        controller: _aiController,
                        state: state,
                        onSubmit: () => context
                            .read<SoundsCubit>()
                            .askAiForSounds(_aiController.text),
                      ),
                    ],
                  ),
                ),
                // Mixer panel (sliding)
                if (state.isMixerVisible && state.hasTracks)
                  _MiniMixerPanel(state: state),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ─── Yardımcı fonksiyon: Kategori → Renk ─────────────────────────────────────

Color _soundCategoryColor(SoundCategory category) {
  switch (category) {
    case SoundCategory.rain:
      return AppColors.soundRain;
    case SoundCategory.nature:
      return AppColors.soundForest;
    case SoundCategory.ambient:
      return AppColors.soundOcean;
    case SoundCategory.medieval:
      return AppColors.soundMedieval;
    case SoundCategory.whiteNoise:
      return AppColors.soundWind;
    case SoundCategory.instrument:
    case SoundCategory.instruments:
      return AppColors.soundInstrument;
    case SoundCategory.lullaby:
      return AppColors.soundLullaby;
    case SoundCategory.meditation:
      return AppColors.primary;
    case SoundCategory.healing:
      return AppColors.accentTeal;
    case SoundCategory.binaural:
      return AppColors.accentBlue;
    case SoundCategory.happy:
      return AppColors.accent;
    case SoundCategory.prayer:
      return AppColors.badgeGold;
  }
}

// ─── Ses Kütüphanesi Tab ──────────────────────────────────────────────────────

class _SoundsLibraryTab extends StatelessWidget {
  const _SoundsLibraryTab({
    required this.state,
    required this.categories,
    required this.selectedIndex,
    required this.onCategorySelected,
    required this.filtered,
  });

  final SoundsState state;
  final List<String> categories;
  final int selectedIndex;
  final ValueChanged<int> onCategorySelected;
  final List<SoundModel> filtered;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Yatay kategori filtresi
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSizes.xs),
            itemBuilder: (_, i) {
              final isSelected = selectedIndex == i;
              return GestureDetector(
                onTap: () => onCategorySelected(i),
                child: AnimatedContainer(
                  duration: AppDurations.fast,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.md,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryLight
                          : Colors.transparent,
                    ),
                  ),
                  child: Text(
                    categories[i],
                    style: TextStyle(
                      color:
                          isSelected ? Colors.white : AppColors.textSecondary,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.normal,
                      fontSize: AppSizes.fontSm,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppSizes.sm),
        // Grid
        Expanded(
          child: state.isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryLight,
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.md,
                    vertical: AppSizes.sm,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: AppSizes.sm,
                    mainAxisSpacing: AppSizes.sm,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (ctx, i) {
                    final sound = filtered[i];
                    return SoundCardWidget(
                      emoji: sound.iconEmoji,
                      name: sound.localeName,
                      isPlaying: state.isTrackActive(sound.id),
                      color: _soundCategoryColor(sound.category),
                      onTap: () {
                        context.read<SoundsCubit>().toggleSound(sound);
                      },
                      isFavorite: state.favorites.contains(sound.id),
                      isPro: sound.isPro,
                    );
                  },
                ),
        ),
      ],
    );
  }
}

// ─── YZ Mod Müziği Tab ────────────────────────────────────────────────────────

class _AiMoodTab extends StatelessWidget {
  const _AiMoodTab({
    required this.controller,
    required this.state,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final SoundsState state;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.pagePaddingH),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlassCard(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('🤖', style: TextStyle(fontSize: 24)),
                    const SizedBox(width: AppSizes.sm),
                    Text(
                      'aiMoodTitle'.tr,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: AppSizes.fontMd,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.sm),
                Text(
                  'aiMoodDesc'.tr,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: AppSizes.fontSm,
                  ),
                ),
                const SizedBox(height: AppSizes.md),
                TextField(
                  controller: controller,
                  maxLines: 3,
                  textInputAction: TextInputAction.send,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'aiMoodHint'.tr,
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.send_rounded,
                        color: AppColors.primaryLight,
                      ),
                      onPressed: state.isAiLoading ? null : onSubmit,
                    ),
                  ),
                  onSubmitted: (_) => state.isAiLoading ? null : onSubmit(),
                ),
                const SizedBox(height: AppSizes.md),
                GradientButton(
                  label: 'askAi'.tr,
                  onPressed: state.isAiLoading ? null : onSubmit,
                  isLoading: state.isAiLoading,
                  icon: Icons.auto_awesome_rounded,
                ),
              ],
            ),
          ),
          if (state.aiRecommendedSounds.isNotEmpty) ...[
            const SizedBox(height: AppSizes.lg),
            Text(
              'aiRecommendations'.tr,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: AppSizes.fontLg,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppSizes.sm,
                mainAxisSpacing: AppSizes.sm,
                childAspectRatio: 1.4,
              ),
              itemCount: state.aiRecommendedSounds.length,
              itemBuilder: (ctx, i) {
                final sound = state.aiRecommendedSounds[i];
                return SoundCardWidget(
                  emoji: sound.iconEmoji,
                  name: sound.localeName,
                  isPlaying: state.isTrackActive(sound.id),
                  color: _soundCategoryColor(sound.category),
                  onTap: () => context.read<SoundsCubit>().toggleSound(sound),
                  isFavorite: state.favorites.contains(sound.id),
                  isPro: sound.isPro,
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Mini Mixer Paneli (alt kısım) ────────────────────────────────────────────

class _MiniMixerPanel extends StatelessWidget {
  const _MiniMixerPanel({required this.state});

  final SoundsState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusXxl),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(80),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: AppSizes.sm),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textMuted,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      'Mixer',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    // Tümünü durdur
                    IconButton(
                      onPressed: () => context.read<SoundsCubit>().stopAll(),
                      icon: const Icon(
                        Icons.stop_circle_outlined,
                        color: AppColors.error,
                      ),
                    ),
                    // Pause/Resume
                    IconButton(
                      onPressed: () {
                        if (state.isAnyPlaying) {
                          context.read<SoundsCubit>().pauseAll();
                        } else {
                          context.read<SoundsCubit>().resumeAll();
                        }
                      },
                      icon: Icon(
                        state.isAnyPlaying
                            ? Icons.pause_circle_outline_rounded
                            : Icons.play_circle_outline_rounded,
                        color: AppColors.primaryLight,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.sm),
                ...state.activeTracks.map(
                  (track) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSizes.sm),
                    child: Row(
                      children: [
                        Text(
                          track.sound.iconEmoji,
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: AppSizes.sm),
                        Expanded(
                          flex: 2,
                          child: Text(
                            track.sound.localeName,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: AppSizes.fontSm,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Slider(
                            value: track.volume,
                            onChanged: (v) => context
                                .read<SoundsCubit>()
                                .setVolume(track.sound.id, v),
                            activeColor: AppColors.primaryLight,
                            inactiveColor: AppColors.surfaceVariant,
                            min: 0,
                            max: 1,
                          ),
                        ),
                        IconButton(
                          onPressed: () => context
                              .read<SoundsCubit>()
                              .removeTrack(track.sound.id),
                          icon: const Icon(
                            Icons.close,
                            color: AppColors.textMuted,
                            size: 18,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                        ),
                      ],
                    ),
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
