import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sleepy_ai/core/constants/app_colors.dart';
import 'package:sleepy_ai/core/constants/app_sizes.dart';
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

  static const _categories = [
    (label: 'Tümü', category: null as SoundCategory?),
    (label: 'Doğa', category: SoundCategory.nature),
    (label: 'Yagmur', category: SoundCategory.rain),
    (label: 'Gürültü', category: SoundCategory.whiteNoise),
    (label: 'Ortam', category: SoundCategory.ambient),
    (label: 'Orta Çağ', category: SoundCategory.medieval),
    (label: 'Ninni', category: SoundCategory.lullaby),
    (label: 'Enstrüman', category: SoundCategory.instrument),
    (label: 'Meditasyon', category: SoundCategory.meditation),
    (label: 'Binaural', category: SoundCategory.binaural),
    (label: 'Mutlu', category: SoundCategory.happy),
    (label: 'Dua', category: SoundCategory.prayer),
    (label: 'Favoriler', category: null as SoundCategory?),
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
                        const Expanded(
                          child: Text(
                            'Sesler & Müzik 🎵',
                            style: TextStyle(
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
                  tabs: const [
                    Tab(text: 'Ses Kütüphanesi'),
                    Tab(text: 'YZ Mod Müzigi'),
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
                      _AiMoodTab(controller: _aiController, state: state),
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
                      color: isSelected
                          ? Colors.white
                          : AppColors.textSecondary,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.normal,
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
                      sound: sound,
                      isActive: state.isTrackActive(sound.id),
                      isFavorite: state.favorites.contains(sound.id),
                      onTap: () {
                        context.read<SoundsCubit>().toggleSound(sound);
                      },
                      onFavoriteTap: () {
                        context.read<SoundsCubit>().toggleFavorite(sound.id);
                      },
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
  const _AiMoodTab({required this.controller, required this.state});

  final TextEditingController controller;
  final SoundsState state;

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
                const Row(
                  children: [
                    Text('🤖', style: TextStyle(fontSize: 24)),
                    SizedBox(width: AppSizes.sm),
                    Text(
                      'YZ Mod Müziği',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: AppSizes.fontMd,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.sm),
                const Text(
                  'Simdiki ruh halini veya bulundugun ortami anlat, '
                  'YZ sana özel bir ses karisiimi olusturusun.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: AppSizes.fontSm,
                  ),
                ),
                const SizedBox(height: AppSizes.md),
                TextField(
                  controller: controller,
                  maxLines: 3,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(
                    hintText:
                        'Örn: "Yagmurlu bir aksamda yorgun hissediyorum..."',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: AppSizes.md),
                GradientButton(
                  label: 'YZ\'ye Sor',
                  onPressed: () {
                    context.read<SoundsCubit>().askAiForSounds(controller.text);
                  },
                  isLoading: state.isAiLoading,
                  icon: Icons.auto_awesome_rounded,
                ),
              ],
            ),
          ),
          if (state.aiRecommendedSounds.isNotEmpty) ...[
            const SizedBox(height: AppSizes.lg),
            const Text(
              'YZ Önerileri',
              style: TextStyle(
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
                  sound: sound,
                  isActive: state.isTrackActive(sound.id),
                  isFavorite: state.favorites.contains(sound.id),
                  onTap: () => context.read<SoundsCubit>().toggleSound(sound),
                  onFavoriteTap: () =>
                      context.read<SoundsCubit>().toggleFavorite(sound.id),
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
                            track.sound.nameTr,
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
