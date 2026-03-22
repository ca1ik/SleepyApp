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

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: AppColors.textPrimary),
        title: Text(
          'settings'.tr,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          final cubit = context.read<SettingsCubit>();
          return ListView(
            padding: const EdgeInsets.all(AppSizes.md),
            children: [
              // Language section
              _SectionHeader(label: 'languageSection'.tr),
              _SettingsCard(
                children: _buildLanguageTiles(state, cubit),
              ),
              const SizedBox(height: AppSizes.md),

              // Notifications section
              _SectionHeader(label: 'notifications'.tr),
              _SettingsCard(
                children: [
                  SwitchListTile(
                    value: state.notificationsEnabled,
                    onChanged: (val) => cubit.toggleNotifications(enabled: val),
                    title: Text(
                      'sleepReminder'.tr,
                      style: const TextStyle(color: AppColors.textPrimary),
                    ),
                    subtitle: Text(
                      'sleepReminderSub'.tr,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: AppSizes.fontSm,
                      ),
                    ),
                    activeColor: AppColors.primary,
                    inactiveTrackColor: AppColors.border,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.md,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.md),

              // Bedtime section
              _SectionHeader(label: 'sleepSchedule'.tr),
              _SettingsCard(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.md,
                    ),
                    leading: const Text('🌙', style: TextStyle(fontSize: 24)),
                    title: Text(
                      'bedtime'.tr,
                      style: const TextStyle(color: AppColors.textPrimary),
                    ),
                    trailing: Text(
                      '${state.bedtimeHour.toString().padLeft(2, '0')}:${state.bedtimeMinute.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: AppSizes.fontLg,
                        fontWeight: FontWeight.w600,
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
                  const Divider(color: AppColors.divider, height: 1),
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
                            const Text('⏱️', style: TextStyle(fontSize: 20)),
                            const SizedBox(width: AppSizes.sm),
                            Text(
                              'sleepGoal'.tr,
                              style:
                                  const TextStyle(color: AppColors.textPrimary),
                            ),
                            const Spacer(),
                            Text(
                              '${state.sleepGoalHours.toStringAsFixed(1)} ${'hours'.tr}',
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
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
                          inactiveColor: AppColors.border,
                          onChanged: cubit.setSleepGoal,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.md),

              // Account section
              _SectionHeader(label: 'account'.tr),
              _SettingsCard(
                children: [
                  _ActionTile(
                    emoji: '🔒',
                    label: 'privacyPolicy'.tr,
                    onTap: () {
                      /* TODO: open webview */
                    },
                  ),
                  const Divider(color: AppColors.divider, height: 1),
                  _ActionTile(
                    emoji: '📋',
                    label: 'termsOfService'.tr,
                    onTap: () {
                      /* TODO: open webview */
                    },
                  ),
                  const Divider(color: AppColors.divider, height: 1),
                  _ActionTile(
                    emoji: '🚪',
                    label: 'logout'.tr,
                    labelColor: AppColors.error,
                    onTap: () {
                      showDialog<void>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          backgroundColor: AppColors.backgroundCard,
                          title: Text(
                            'logout'.tr,
                            style:
                                const TextStyle(color: AppColors.textPrimary),
                          ),
                          content: Text(
                            'logoutConfirm'.tr,
                            style:
                                const TextStyle(color: AppColors.textSecondary),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: Text(
                                'cancel'.tr,
                                style:
                                    const TextStyle(color: AppColors.textMuted),
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
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.xl),

              // Version
              const Center(
                child: Text(
                  'SleepyApp v${AppStrings.appVersion}',
                  style: TextStyle(color: AppColors.textDisabled),
                ),
              ),
              const SizedBox(height: AppSizes.xxl),
            ],
          );
        },
      ),
    );
  }

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

  List<Widget> _buildLanguageTiles(SettingsState state, SettingsCubit cubit) {
    final tiles = <Widget>[];
    for (int i = 0; i < _languages.length; i++) {
      if (i > 0) tiles.add(const Divider(color: AppColors.divider, height: 1));
      final lang = _languages[i];
      tiles.add(
        _LanguageTile(
          label: lang.name,
          flagEmoji: lang.flag,
          isSelected: state.locale.languageCode == lang.code,
          onTap: () => cubit.setLocale(lang.code),
        ),
      );
    }
    return tiles;
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSizes.xs,
        bottom: AppSizes.sm,
        top: AppSizes.sm,
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.textMuted,
          fontSize: AppSizes.fontSm,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: children),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.label,
    required this.flagEmoji,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final String flagEmoji;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      leading: Text(flagEmoji, style: const TextStyle(fontSize: 24)),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_rounded, color: AppColors.primary)
          : null,
      onTap: onTap,
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.emoji,
    required this.label,
    required this.onTap,
    this.labelColor,
  });

  final String emoji;
  final String label;
  final VoidCallback onTap;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      leading: Text(emoji, style: const TextStyle(fontSize: 20)),
      title: Text(
        label,
        style: TextStyle(color: labelColor ?? AppColors.textPrimary),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.textMuted,
      ),
      onTap: onTap,
    );
  }
}
