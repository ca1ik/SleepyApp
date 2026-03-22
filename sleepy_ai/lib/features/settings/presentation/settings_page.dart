import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sleepy_ai/core/constants/app_colors.dart';
import 'package:sleepy_ai/core/constants/app_constants.dart';
import 'package:sleepy_ai/core/constants/app_sizes.dart';
import 'package:sleepy_ai/features/auth/bloc/auth_bloc.dart';
import 'package:sleepy_ai/features/auth/bloc/auth_event.dart';
import 'package:sleepy_ai/features/settings/cubit/settings_cubit.dart';
import 'package:sleepy_ai/features/settings/cubit/settings_state.dart';
import 'package:sleepy_ai/features/pro/cubit/pro_cubit.dart';
import 'package:sleepy_ai/features/pro/cubit/pro_state.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with TickerProviderStateMixin {
  late final AnimationController _headerCtrl;
  late final AnimationController _staggerCtrl;
  late final Animation<double> _headerScale;
  late final Animation<double> _headerOpacity;

  @override
  void initState() {
    super.initState();
    _headerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _staggerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _headerScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOutBack),
    );
    _headerOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOut),
    );
    _headerCtrl.forward();
    _staggerCtrl.forward();
  }

  @override
  void dispose() {
    _headerCtrl.dispose();
    _staggerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final cubit = context.read<SettingsCubit>();
        final isDark = state.isDarkMode;

        return Scaffold(
          backgroundColor:
              isDark ? AppColors.backgroundDark : const Color(0xFFF5F0FF),
          body: CustomScrollView(
            slivers: [
              // ─── Animated SliverAppBar ──────────────────────────
              SliverAppBar(
                backgroundColor: Colors.transparent,
                pinned: true,
                expandedHeight: 140,
                leading: const BackButton(color: AppColors.textPrimary),
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(
                    'settings'.tr,
                    style: TextStyle(
                      color: isDark
                          ? AppColors.textPrimary
                          : const Color(0xFF1A1A2E),
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                  background: AnimatedBuilder(
                    animation: _headerCtrl,
                    builder: (_, __) => Opacity(
                      opacity: _headerOpacity.value,
                      child: Transform.scale(
                        scale: _headerScale.value,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: isDark
                                  ? [
                                      AppColors.primaryDark.withAlpha(100),
                                      AppColors.backgroundDark,
                                    ]
                                  : [
                                      AppColors.primary.withAlpha(30),
                                      const Color(0xFFF5F0FF),
                                    ],
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.settings_rounded,
                              size: 50,
                              color: AppColors.primary.withAlpha(40),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // ─── Content ───────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.all(AppSizes.md),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // ═══ THEME SECTION ═══
                    _buildStaggeredItem(
                      index: 0,
                      child: _ThemeToggleCard(
                        isDarkMode: isDark,
                        onToggle: cubit.toggleTheme,
                      ),
                    ),
                    const SizedBox(height: AppSizes.lg),

                    // ═══ LANGUAGE SECTION ═══
                    _buildStaggeredItem(
                      index: 1,
                      child: _AnimatedSectionHeader(
                        label: 'languageSection'.tr,
                        icon: Icons.translate_rounded,
                      ),
                    ),
                    const SizedBox(height: AppSizes.sm),
                    _buildStaggeredItem(
                      index: 2,
                      child: _LanguageGrid(
                        selectedLocale: state.locale.languageCode,
                        onSelect: cubit.setLocale,
                        isDarkMode: isDark,
                      ),
                    ),
                    const SizedBox(height: AppSizes.lg),

                    // ═══ NOTIFICATIONS ═══
                    _buildStaggeredItem(
                      index: 3,
                      child: _AnimatedSectionHeader(
                        label: 'notifications'.tr,
                        icon: Icons.notifications_rounded,
                      ),
                    ),
                    const SizedBox(height: AppSizes.sm),
                    _buildStaggeredItem(
                      index: 4,
                      child: _GlassSettingsCard(
                        isDarkMode: isDark,
                        child: SwitchListTile(
                          value: state.notificationsEnabled,
                          onChanged: (val) =>
                              cubit.toggleNotifications(enabled: val),
                          title: Text(
                            'sleepReminder'.tr,
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.textPrimary
                                  : const Color(0xFF1A1A2E),
                            ),
                          ),
                          subtitle: Text(
                            'sleepReminderSub'.tr,
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.textMuted
                                  : const Color(0xFF6B5B93),
                              fontSize: AppSizes.fontSm,
                            ),
                          ),
                          activeColor: AppColors.primary,
                          inactiveTrackColor: isDark
                              ? AppColors.border
                              : AppColors.primary.withAlpha(30),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.md,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.lg),

                    // ═══ SLEEP SCHEDULE ═══
                    _buildStaggeredItem(
                      index: 5,
                      child: _AnimatedSectionHeader(
                        label: 'sleepSchedule'.tr,
                        icon: Icons.bedtime_rounded,
                      ),
                    ),
                    const SizedBox(height: AppSizes.sm),
                    _buildStaggeredItem(
                      index: 6,
                      child: _GlassSettingsCard(
                        isDarkMode: isDark,
                        child: Column(
                          children: [
                            ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.md,
                              ),
                              leading: const Text('🌙',
                                  style: TextStyle(fontSize: 24)),
                              title: Text(
                                'bedtime'.tr,
                                style: TextStyle(
                                  color: isDark
                                      ? AppColors.textPrimary
                                      : const Color(0xFF1A1A2E),
                                ),
                              ),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  gradient: AppColors.primaryGradient,
                                  borderRadius:
                                      BorderRadius.circular(AppSizes.radiusMd),
                                ),
                                child: Text(
                                  '${state.bedtimeHour.toString().padLeft(2, '0')}:${state.bedtimeMinute.toString().padLeft(2, '0')}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: AppSizes.fontLg,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              onTap: () async {
                                final picked = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay(
                                    hour: state.bedtimeHour,
                                    minute: state.bedtimeMinute,
                                  ),
                                  builder: (ctx, child) => Theme(
                                    data: Theme.of(ctx).copyWith(
                                      colorScheme: const ColorScheme.dark(
                                        primary: AppColors.primary,
                                      ),
                                    ),
                                    child: child!,
                                  ),
                                );
                                if (picked != null) {
                                  cubit.setBedtime(picked);
                                }
                              },
                            ),
                            Divider(
                              color: isDark
                                  ? AppColors.divider
                                  : AppColors.primary.withAlpha(20),
                              height: 1,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.md,
                                vertical: AppSizes.sm,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text('⏱️',
                                          style: TextStyle(fontSize: 20)),
                                      const SizedBox(width: AppSizes.sm),
                                      Text(
                                        'sleepGoal'.tr,
                                        style: TextStyle(
                                          color: isDark
                                              ? AppColors.textPrimary
                                              : const Color(0xFF1A1A2E),
                                        ),
                                      ),
                                      const Spacer(),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              AppColors.primary.withAlpha(25),
                                          borderRadius: BorderRadius.circular(
                                              AppSizes.radiusSm),
                                        ),
                                        child: Text(
                                          '${state.sleepGoalHours.toStringAsFixed(1)} ${'hours'.tr}',
                                          style: const TextStyle(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Slider(
                                    value: state.sleepGoalHours,
                                    min: 4.0,
                                    max: 12.0,
                                    divisions: 16,
                                    activeColor: AppColors.primary,
                                    inactiveColor: isDark
                                        ? AppColors.border
                                        : AppColors.primary.withAlpha(30),
                                    onChanged: cubit.setSleepGoal,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.lg),

                    // ═══ SUBSCRIPTION ═══
                    _buildStaggeredItem(
                      index: 7,
                      child: _AnimatedSectionHeader(
                        label: 'subscriptionSection'.tr,
                        icon: Icons.workspace_premium_rounded,
                      ),
                    ),
                    const SizedBox(height: AppSizes.sm),
                    _buildStaggeredItem(
                      index: 8,
                      child: _SubscriptionCard(isDarkMode: isDark),
                    ),
                    const SizedBox(height: AppSizes.lg),

                    // ═══ ACCOUNT ═══
                    _buildStaggeredItem(
                      index: 9,
                      child: _AnimatedSectionHeader(
                        label: 'account'.tr,
                        icon: Icons.person_rounded,
                      ),
                    ),
                    const SizedBox(height: AppSizes.sm),
                    _buildStaggeredItem(
                      index: 10,
                      child: _GlassSettingsCard(
                        isDarkMode: isDark,
                        child: Column(
                          children: [
                            _ActionTile(
                              emoji: '🔒',
                              label: 'privacyPolicy'.tr,
                              isDarkMode: isDark,
                              onTap: () {},
                            ),
                            Divider(
                              color: isDark
                                  ? AppColors.divider
                                  : AppColors.primary.withAlpha(20),
                              height: 1,
                            ),
                            _ActionTile(
                              emoji: '📋',
                              label: 'termsOfService'.tr,
                              isDarkMode: isDark,
                              onTap: () {},
                            ),
                            Divider(
                              color: isDark
                                  ? AppColors.divider
                                  : AppColors.primary.withAlpha(20),
                              height: 1,
                            ),
                            _ActionTile(
                              emoji: '🚪',
                              label: 'logout'.tr,
                              isDarkMode: isDark,
                              labelColor: AppColors.error,
                              onTap: () => _showLogoutDialog(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.xl),

                    // Version
                    Center(
                      child: Text(
                        'SleepyApp v${AppStrings.appVersion}',
                        style: TextStyle(
                          color: isDark
                              ? AppColors.textDisabled
                              : const Color(0xFF9E8EC0),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.xxxl),
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStaggeredItem({required int index, required Widget child}) {
    final begin = (index * 0.08).clamp(0.0, 0.7);
    final end = (begin + 0.3).clamp(0.0, 1.0);
    final animation = CurvedAnimation(
      parent: _staggerCtrl,
      curve: Interval(begin, end, curve: Curves.easeOutCubic),
    );
    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) => Transform.translate(
        offset: Offset(0, 30 * (1 - animation.value)),
        child: Opacity(opacity: animation.value, child: child),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.backgroundCard,
        title: Text(
          'logout'.tr,
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        content: Text(
          'logoutConfirm'.tr,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'cancel'.tr,
              style: const TextStyle(color: AppColors.textMuted),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<AuthBloc>().add(LogoutRequested());
              Get.offAllNamed(AppStrings.routeLogin);
            },
            child: Text(
              'logout'.tr,
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// THEME TOGGLE CARD — Animated sun/moon switch
// ═══════════════════════════════════════════════════════════════════════════════

class _ThemeToggleCard extends StatefulWidget {
  const _ThemeToggleCard({
    required this.isDarkMode,
    required this.onToggle,
  });

  final bool isDarkMode;
  final VoidCallback onToggle;

  @override
  State<_ThemeToggleCard> createState() => _ThemeToggleCardState();
}

class _ThemeToggleCardState extends State<_ThemeToggleCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _rotation;
  late final Animation<Color?> _bgColor;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
      value: widget.isDarkMode ? 0.0 : 1.0,
    );
    _rotation = Tween<double>(begin: 0, end: pi).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOutCubic),
    );
    _bgColor = ColorTween(
      begin: AppColors.backgroundCard,
      end: const Color(0xFFEDE5FF),
    ).animate(_ctrl);
  }

  @override
  void didUpdateWidget(_ThemeToggleCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isDarkMode != oldWidget.isDarkMode) {
      widget.isDarkMode ? _ctrl.reverse() : _ctrl.forward();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        return GestureDetector(
          onTap: widget.onToggle,
          child: Container(
            padding: const EdgeInsets.all(AppSizes.lg),
            decoration: BoxDecoration(
              color: _bgColor.value,
              borderRadius: BorderRadius.circular(AppSizes.radiusXl),
              border: Border.all(
                color: widget.isDarkMode
                    ? AppColors.primary.withAlpha(60)
                    : AppColors.primary.withAlpha(40),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withAlpha(
                    widget.isDarkMode ? 30 : 15,
                  ),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Row(
              children: [
                // Animated icon
                Transform.rotate(
                  angle: _rotation.value,
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: widget.isDarkMode
                          ? const LinearGradient(
                              colors: [
                                Color(0xFF6366F1),
                                Color(0xFF7C3AED),
                              ],
                            )
                          : const LinearGradient(
                              colors: [
                                Color(0xFFFFD700),
                                Color(0xFFFFA500),
                              ],
                            ),
                      boxShadow: [
                        BoxShadow(
                          color: widget.isDarkMode
                              ? AppColors.primary.withAlpha(80)
                              : const Color(0xFFFFD700).withAlpha(80),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      widget.isDarkMode
                          ? Icons.nightlight_round
                          : Icons.wb_sunny_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'themeSection'.tr,
                        style: TextStyle(
                          color: widget.isDarkMode
                              ? AppColors.textMuted
                              : const Color(0xFF6B5B93),
                          fontSize: AppSizes.fontSm,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.isDarkMode ? 'darkMode'.tr : 'lightMode'.tr,
                        style: TextStyle(
                          color: widget.isDarkMode
                              ? AppColors.textPrimary
                              : const Color(0xFF1A1A2E),
                          fontSize: AppSizes.fontXl,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                // Toggle indicator
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOutCubic,
                  width: 56,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: widget.isDarkMode
                        ? const LinearGradient(
                            colors: [Color(0xFF1A0845), Color(0xFF2D0A6B)],
                          )
                        : const LinearGradient(
                            colors: [Color(0xFF87CEEB), Color(0xFF60A5FA)],
                          ),
                  ),
                  child: AnimatedAlign(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOutCubic,
                    alignment: widget.isDarkMode
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: Container(
                      width: 24,
                      height: 24,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(40),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        widget.isDarkMode
                            ? Icons.dark_mode_rounded
                            : Icons.light_mode_rounded,
                        size: 14,
                        color: widget.isDarkMode
                            ? AppColors.primary
                            : const Color(0xFFFFA500),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// LANGUAGE GRID — 2-column animated grid
// ═══════════════════════════════════════════════════════════════════════════════

class _LanguageGrid extends StatelessWidget {
  const _LanguageGrid({
    required this.selectedLocale,
    required this.onSelect,
    required this.isDarkMode,
  });

  final String selectedLocale;
  final void Function(String) onSelect;
  final bool isDarkMode;

  static const _languages = <({String code, String flag, String name})>[
    (code: 'tr', flag: '🇹🇷', name: 'Türkçe'),
    (code: 'en', flag: '🇺🇸', name: 'English'),
    (code: 'de', flag: '🇩🇪', name: 'Deutsch'),
    (code: 'es', flag: '🇪🇸', name: 'Español'),
    (code: 'fr', flag: '🇫🇷', name: 'Français'),
    (code: 'it', flag: '🇮🇹', name: 'Italiano'),
    (code: 'pt', flag: '🇧🇷', name: 'Português'),
    (code: 'ru', flag: '🇷🇺', name: 'Русский'),
    (code: 'ar', flag: '🇸🇦', name: 'العربية'),
    (code: 'hi', flag: '🇮🇳', name: 'हिन्दी'),
    (code: 'zh', flag: '🇨🇳', name: '中文'),
    (code: 'ja', flag: '🇯🇵', name: '日本語'),
    (code: 'ko', flag: '🇰🇷', name: '한국어'),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.8,
      ),
      itemCount: _languages.length,
      itemBuilder: (_, i) {
        final lang = _languages[i];
        final isSelected = selectedLocale == lang.code;
        return _AnimatedLanguageTile(
          flag: lang.flag,
          name: lang.name,
          isSelected: isSelected,
          isDarkMode: isDarkMode,
          onTap: () => onSelect(lang.code),
        );
      },
    );
  }
}

class _AnimatedLanguageTile extends StatelessWidget {
  const _AnimatedLanguageTile({
    required this.flag,
    required this.name,
    required this.isSelected,
    required this.isDarkMode,
    required this.onTap,
  });

  final String flag;
  final String name;
  final bool isSelected;
  final bool isDarkMode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: isSelected
              ? (isDarkMode
                  ? AppColors.primary.withAlpha(30)
                  : AppColors.primary.withAlpha(20))
              : (isDarkMode ? AppColors.backgroundCard : Colors.white),
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (isDarkMode
                    ? AppColors.border
                    : AppColors.primary.withAlpha(25)),
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withAlpha(30),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  color: isSelected
                      ? AppColors.primary
                      : (isDarkMode
                          ? AppColors.textPrimary
                          : const Color(0xFF1A1A2E)),
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: AppSizes.fontMd,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded,
                  color: AppColors.primary, size: 18),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// HELPER WIDGETS
// ═══════════════════════════════════════════════════════════════════════════════

class _AnimatedSectionHeader extends StatelessWidget {
  const _AnimatedSectionHeader({required this.label, required this.icon});
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 18),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: AppSizes.fontSm,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }
}

class _GlassSettingsCard extends StatelessWidget {
  const _GlassSettingsCard({
    required this.child,
    required this.isDarkMode,
  });

  final Widget child;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.backgroundCard : Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(
          color:
              isDarkMode ? AppColors.border : AppColors.primary.withAlpha(25),
        ),
        boxShadow: isDarkMode
            ? null
            : [
                BoxShadow(
                  color: AppColors.primary.withAlpha(10),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        child: child,
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.emoji,
    required this.label,
    required this.onTap,
    required this.isDarkMode,
    this.labelColor,
  });

  final String emoji;
  final String label;
  final VoidCallback onTap;
  final bool isDarkMode;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      leading: Text(emoji, style: const TextStyle(fontSize: 20)),
      title: Text(
        label,
        style: TextStyle(
          color: labelColor ??
              (isDarkMode ? AppColors.textPrimary : const Color(0xFF1A1A2E)),
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: isDarkMode ? AppColors.textMuted : const Color(0xFF9E8EC0),
      ),
      onTap: onTap,
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SUBSCRIPTION CARD — PRO + No Ads durumu
// ═══════════════════════════════════════════════════════════════════════════════

class _SubscriptionCard extends StatelessWidget {
  const _SubscriptionCard({required this.isDarkMode});
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProCubit, ProState>(
      builder: (context, proState) {
        return _GlassSettingsCard(
          isDarkMode: isDarkMode,
          child: Column(
            children: [
              // PRO Durumu
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: AppSizes.md),
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: proState.isPro ? AppColors.goldGradient : null,
                    color:
                        proState.isPro ? null : AppColors.primary.withAlpha(30),
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  ),
                  child: Icon(
                    proState.isPro
                        ? Icons.workspace_premium_rounded
                        : Icons.star_outline_rounded,
                    color: proState.isPro ? Colors.white : AppColors.primary,
                    size: 20,
                  ),
                ),
                title: Text(
                  proState.isPro ? 'proActive'.tr : 'goPro'.tr,
                  style: TextStyle(
                    color: isDarkMode
                        ? AppColors.textPrimary
                        : const Color(0xFF1A1A2E),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  proState.isPro ? 'proActiveDesc'.tr : 'proInactiveDesc'.tr,
                  style: TextStyle(
                    color: isDarkMode
                        ? AppColors.textMuted
                        : const Color(0xFF6B5B93),
                    fontSize: AppSizes.fontSm,
                  ),
                ),
                trailing: proState.isPro
                    ? const Icon(
                        Icons.verified_rounded,
                        color: AppColors.success,
                        size: 22,
                      )
                    : Icon(
                        Icons.chevron_right_rounded,
                        color: isDarkMode
                            ? AppColors.textMuted
                            : const Color(0xFF9E8EC0),
                      ),
                onTap: proState.isPro
                    ? null
                    : () => Get.toNamed(AppStrings.routePro),
              ),
              Divider(
                color: isDarkMode
                    ? AppColors.divider
                    : AppColors.primary.withAlpha(20),
                height: 1,
              ),
              // No Ads Durumu
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: AppSizes.md),
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: !proState.shouldShowAds
                        ? AppColors.success.withAlpha(30)
                        : AppColors.primary.withAlpha(30),
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  ),
                  child: Icon(
                    !proState.shouldShowAds
                        ? Icons.block_rounded
                        : Icons.campaign_outlined,
                    color: !proState.shouldShowAds
                        ? AppColors.success
                        : AppColors.primary,
                    size: 20,
                  ),
                ),
                title: Text(
                  'noAdsTitle'.tr,
                  style: TextStyle(
                    color: isDarkMode
                        ? AppColors.textPrimary
                        : const Color(0xFF1A1A2E),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  !proState.shouldShowAds
                      ? 'noAdsActiveDesc'.tr
                      : 'noAdsInactiveDesc'.tr,
                  style: TextStyle(
                    color: isDarkMode
                        ? AppColors.textMuted
                        : const Color(0xFF6B5B93),
                    fontSize: AppSizes.fontSm,
                  ),
                ),
                trailing: !proState.shouldShowAds
                    ? const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.success,
                        size: 22,
                      )
                    : Icon(
                        Icons.chevron_right_rounded,
                        color: isDarkMode
                            ? AppColors.textMuted
                            : const Color(0xFF9E8EC0),
                      ),
                onTap: proState.shouldShowAds
                    ? () => Get.toNamed(AppStrings.routeNoAds)
                    : null,
              ),
            ],
          ),
        );
      },
    );
  }
}
