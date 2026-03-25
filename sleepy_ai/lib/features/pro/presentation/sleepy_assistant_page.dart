import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleepy_ai/core/constants/app_colors.dart';
import 'package:sleepy_ai/core/constants/app_constants.dart';
import 'package:sleepy_ai/core/constants/app_sizes.dart';
import 'package:sleepy_ai/features/pro/cubit/pro_cubit.dart';
import 'package:sleepy_ai/features/pro/cubit/pro_state.dart';
import 'package:sleepy_ai/shared/widgets/common_widgets.dart';

// --------------------------------------------------------------------------
// Data
// --------------------------------------------------------------------------

enum _Sender { user, assistant }

class _ChatMessage {
  _ChatMessage({
    required this.text,
    required this.sender,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  final String text;
  final _Sender sender;
  final DateTime timestamp;
}

// --------------------------------------------------------------------------
// Page
// --------------------------------------------------------------------------

class SleepyAssistantPage extends StatefulWidget {
  const SleepyAssistantPage({super.key});

  @override
  State<SleepyAssistantPage> createState() => _SleepyAssistantPageState();
}

class _SleepyAssistantPageState extends State<SleepyAssistantPage> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();
  bool _isTyping = false;
  bool _dailyLimitReached = false;

  /// Free kullanıcılar günde 1 mesaj gönderebilir.
  static const int _freeDailyLimit = 1;

  late final List<_ChatMessage> _messages = [
    _ChatMessage(
      text: 'assistantGreeting'.tr,
      sender: _Sender.assistant,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _checkDailyLimit();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _checkDailyLimit() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final savedDate = prefs.getString(AppStrings.prefAiDailyUsageDate) ?? '';
    final count = prefs.getInt(AppStrings.prefAiDailyUsageCount) ?? 0;

    if (savedDate == today && count >= _freeDailyLimit) {
      setState(() => _dailyLimitReached = true);
    }
  }

  Future<bool> _incrementDailyUsage() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final savedDate = prefs.getString(AppStrings.prefAiDailyUsageDate) ?? '';
    int count = prefs.getInt(AppStrings.prefAiDailyUsageCount) ?? 0;

    if (savedDate != today) {
      count = 0;
      await prefs.setString(AppStrings.prefAiDailyUsageDate, today);
    }

    if (count >= _freeDailyLimit) return false;

    count++;
    await prefs.setInt(AppStrings.prefAiDailyUsageCount, count);

    if (count >= _freeDailyLimit) {
      setState(() => _dailyLimitReached = true);
    }
    return true;
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty || _isTyping) return;

    final isPro = context.read<ProCubit>().state.isPro;

    if (!isPro && _dailyLimitReached) {
      _showDailyLimitDialog();
      return;
    }

    setState(() {
      _messages.add(_ChatMessage(text: text, sender: _Sender.user));
      _isTyping = true;
    });
    _controller.clear();
    _scrollToBottom();

    // Free kullanıcı için günlük kullanımı artır
    if (!isPro) {
      _incrementDailyUsage();
    }

    // Simulate AI thinking delay
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      final response = _generateResponse(text);
      setState(() {
        _messages.add(_ChatMessage(text: response, sender: _Sender.assistant));
        _isTyping = false;
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _generateResponse(String input) {
    final q = input.toLowerCase();

    if (_anyMatch(q, ['sleep', 'uyku', 'uyu', 'uyumak'])) {
      if (_anyMatch(q, ['hour', 'long', 'duration', 'saat', 'kaç', 'süre'])) {
        return 'respSleepHours'.tr;
      }
      if (_anyMatch(
          q, ['problem', 'issue', 'can\'t', 'sorun', 'uyuyamıyorum', 'zor'])) {
        return 'respSleepProblems'.tr;
      }
    }

    if (_anyMatch(q, [
      'meditation',
      'breath',
      'relax',
      'stress',
      'meditasyon',
      'nefes',
      'rahatlama',
      'stres'
    ])) {
      return 'respMeditation'.tr;
    }

    if (_anyMatch(q, ['dream', 'nightmare', 'rem', 'rüya', 'kabus'])) {
      return 'respDreams'.tr;
    }

    if (_anyMatch(
        q, ['alarm', 'wake', 'morning', 'uyan', 'sabah', 'kalk', 'zinde'])) {
      return 'respAlarm'.tr;
    }

    if (_anyMatch(q, [
      'room',
      'temperature',
      'light',
      'dark',
      'noise',
      'oda',
      'sıcaklık',
      'ışık',
      'karanlık',
      'gürültü'
    ])) {
      return 'respEnvironment'.tr;
    }

    if (_anyMatch(q, [
      'food',
      'coffee',
      'caffeine',
      'alcohol',
      'nutrition',
      'yemek',
      'beslen',
      'kahve',
      'kafein',
      'alkol'
    ])) {
      return 'respNutrition'.tr;
    }

    if (_anyMatch(q, [
      'exercise',
      'sport',
      'walk',
      'run',
      'workout',
      'spor',
      'egzersiz',
      'yürüyüş',
      'koşu'
    ])) {
      return 'respExercise'.tr;
    }

    if (_anyMatch(q, [
      'hygiene',
      'routine',
      'habit',
      'tip',
      'hijyen',
      'rutin',
      'alışkanlık',
      'öneri',
      'ipucu'
    ])) {
      return 'respHygiene'.tr;
    }

    if (_anyMatch(q, [
      'hello',
      'hi',
      'hey',
      'good morning',
      'merhaba',
      'selam',
      'nasılsın',
      'günaydın'
    ])) {
      return 'respGreeting'.tr;
    }

    if (_anyMatch(q, ['thank', 'thanks', 'teşekkür', 'sağol', 'eyvallah'])) {
      return 'respThanks'.tr;
    }

    return 'respDefault'.tr;
  }

  bool _anyMatch(String text, List<String> keywords) {
    return keywords.any((k) => text.contains(k));
  }

  void _showDailyLimitDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.backgroundCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        ),
        title: Row(
          children: [
            const Text('🌙', style: TextStyle(fontSize: 24)),
            const SizedBox(width: AppSizes.sm),
            Expanded(
              child: Text(
                'dailyLimitTitle'.tr,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: AppSizes.fontLg,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          'dailyLimitDesc'.tr,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: AppSizes.fontSm,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'ok'.tr,
              style: const TextStyle(color: AppColors.textMuted),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              Get.toNamed(AppStrings.routePro);
            },
            child: Text(
              'goPro'.tr,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProCubit, ProState>(
      builder: (context, proState) {
        return GradientBackground(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.textPrimary,
                ),
                onPressed: () => Get.back(),
              ),
              title: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withAlpha(80),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text('🌙', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Sleepy Assistant',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: AppSizes.fontMd,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'aiSleepConsultant'.tr,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                if (proState.isPro)
                  Container(
                    margin: const EdgeInsets.only(right: AppSizes.md),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.sm,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppColors.goldGradient,
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    ),
                    child: const Text(
                      'PRO',
                      style: TextStyle(
                        color: AppColors.backgroundDark,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            body: _ChatBody(
              messages: _messages,
              isTyping: _isTyping,
              controller: _controller,
              scrollController: _scrollController,
              focusNode: _focusNode,
              onSend: _sendMessage,
              showDailyLimitBanner: !proState.isPro && _dailyLimitReached,
            ),
          ),
        );
      },
    );
  }
}

// --------------------------------------------------------------------------
// PRO Gate
// --------------------------------------------------------------------------

class _ProGateBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withAlpha(100),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Center(
                child: Text('🌙', style: TextStyle(fontSize: 48)),
              ),
            ),
            const SizedBox(height: AppSizes.xl),
            const Text(
              'Sleepy Assistant',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: AppSizes.fontXxl,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            Text(
              'proGateDesc'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: AppSizes.fontMd,
                height: 1.5,
              ),
            ),
            const SizedBox(height: AppSizes.xl),
            _FeatureBadge(
              emoji: '💬',
              text: 'proGateFeature1'.tr,
            ),
            const SizedBox(height: AppSizes.sm),
            _FeatureBadge(
              emoji: '🧠',
              text: 'proGateFeature2'.tr,
            ),
            const SizedBox(height: AppSizes.sm),
            _FeatureBadge(
              emoji: '📊',
              text: 'proGateFeature3'.tr,
            ),
            const SizedBox(height: AppSizes.xxl),
            GradientButton(
              label: 'goPro'.tr,
              onPressed: () => Get.toNamed(AppStrings.routePro),
              height: 52,
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureBadge extends StatelessWidget {
  const _FeatureBadge({required this.emoji, required this.text});
  final String emoji;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withAlpha(25),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.primary.withAlpha(60)),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: AppSizes.fontSm,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --------------------------------------------------------------------------
// Chat Body
// --------------------------------------------------------------------------

class _ChatBody extends StatelessWidget {
  const _ChatBody({
    required this.messages,
    required this.isTyping,
    required this.controller,
    required this.scrollController,
    required this.focusNode,
    required this.onSend,
    this.showDailyLimitBanner = false,
  });

  final List<_ChatMessage> messages;
  final bool isTyping;
  final TextEditingController controller;
  final ScrollController scrollController;
  final FocusNode focusNode;
  final VoidCallback onSend;
  final bool showDailyLimitBanner;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showDailyLimitBanner)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(
              horizontal: AppSizes.md,
              vertical: AppSizes.xs,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.md,
              vertical: AppSizes.sm,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.warning.withAlpha(30),
                  AppColors.warning.withAlpha(15),
                ],
              ),
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              border: Border.all(color: AppColors.warning.withAlpha(60)),
            ),
            child: Row(
              children: [
                const Text('⚡', style: TextStyle(fontSize: 16)),
                const SizedBox(width: AppSizes.sm),
                Expanded(
                  child: Text(
                    'dailyLimitBanner'.tr,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.toNamed(AppStrings.routePro),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.sm,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppColors.goldGradient,
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    ),
                    child: const Text(
                      'PRO',
                      style: TextStyle(
                        color: AppColors.backgroundDark,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.md,
              vertical: AppSizes.sm,
            ),
            itemCount: messages.length + (isTyping ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == messages.length && isTyping) {
                return const _TypingIndicator();
              }
              return _ChatBubble(message: messages[index]);
            },
          ),
        ),
        _InputBar(
          controller: controller,
          focusNode: focusNode,
          isTyping: isTyping,
          onSend: onSend,
        ),
      ],
    );
  }
}

// --------------------------------------------------------------------------
// Chat Bubble
// --------------------------------------------------------------------------

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.message});
  final _ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == _Sender.user;
    final bubbleColor = isUser
        ? AppColors.primary.withAlpha(200)
        : AppColors.backgroundCardLight;
    final textColor = AppColors.textPrimary;
    final alignment =
        isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(AppSizes.radiusLg),
      topRight: const Radius.circular(AppSizes.radiusLg),
      bottomLeft: Radius.circular(isUser ? AppSizes.radiusLg : 4),
      bottomRight: Radius.circular(isUser ? 4 : AppSizes.radiusLg),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.sm),
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          if (!isUser) ...[
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text('🌙', style: TextStyle(fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'Sleepy Assistant',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
          ],
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.78,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.md,
              vertical: AppSizes.sm,
            ),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: borderRadius,
              border: isUser
                  ? null
                  : Border.all(
                      color: AppColors.borderLight.withAlpha(60),
                      width: 0.5,
                    ),
            ),
            child: _MarkdownText(text: message.text, color: textColor),
          ),
        ],
      ),
    );
  }
}

/// Very simple **bold** text renderer (no external package needed).
class _MarkdownText extends StatelessWidget {
  const _MarkdownText({required this.text, required this.color});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final spans = <TextSpan>[];
    final regex = RegExp(r'\*\*(.+?)\*\*');
    int lastIndex = 0;
    for (final match in regex.allMatches(text)) {
      if (match.start > lastIndex) {
        spans.add(
          TextSpan(text: text.substring(lastIndex, match.start)),
        );
      }
      spans.add(
        TextSpan(
          text: match.group(1),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );
      lastIndex = match.end;
    }
    if (lastIndex < text.length) {
      spans.add(TextSpan(text: text.substring(lastIndex)));
    }
    return Text.rich(
      TextSpan(
        children: spans,
        style: TextStyle(
          color: color,
          fontSize: AppSizes.fontSm,
          height: 1.5,
        ),
      ),
    );
  }
}

// --------------------------------------------------------------------------
// Typing Indicator
// --------------------------------------------------------------------------

class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.sm),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('🌙', style: TextStyle(fontSize: 12)),
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.backgroundCardLight,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppSizes.radiusLg),
                topRight: Radius.circular(AppSizes.radiusLg),
                bottomRight: Radius.circular(AppSizes.radiusLg),
                bottomLeft: Radius.circular(4),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                return AnimatedBuilder(
                  animation: _ctrl,
                  builder: (_, __) {
                    final t = (_ctrl.value - i * 0.2).clamp(0.0, 1.0);
                    final opacity = math.sin(t * math.pi).clamp(0.3, 1.0);
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryLight.withAlpha(
                          (opacity * 255).round(),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// --------------------------------------------------------------------------
// Input Bar
// --------------------------------------------------------------------------

class _InputBar extends StatelessWidget {
  const _InputBar({
    required this.controller,
    required this.focusNode,
    required this.isTyping,
    required this.onSend,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isTyping;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: AppSizes.md,
        right: AppSizes.md,
        top: AppSizes.sm,
        bottom: AppSizes.sm + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: AppColors.backgroundMid,
        border: const Border(
          top: BorderSide(color: AppColors.divider, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.backgroundCard,
                borderRadius: BorderRadius.circular(AppSizes.radiusXl),
                border: Border.all(
                  color: AppColors.borderLight.withAlpha(80),
                ),
              ),
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => isTyping ? null : onSend(),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: AppSizes.fontSm,
                ),
                maxLines: 3,
                minLines: 1,
                decoration: InputDecoration(
                  hintText: 'askAboutSleep'.tr,
                  hintStyle: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: AppSizes.fontSm,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.md,
                    vertical: 10,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSizes.sm),
          GestureDetector(
            onTap: isTyping ? null : onSend,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: isTyping ? null : AppColors.primaryGradient,
                color: isTyping ? AppColors.backgroundCard : null,
                shape: BoxShape.circle,
                boxShadow: isTyping
                    ? null
                    : [
                        BoxShadow(
                          color: AppColors.primary.withAlpha(80),
                          blurRadius: 8,
                        ),
                      ],
              ),
              child: isTyping
                  ? const Center(
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                          strokeWidth: 2,
                        ),
                      ),
                    )
                  : const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
