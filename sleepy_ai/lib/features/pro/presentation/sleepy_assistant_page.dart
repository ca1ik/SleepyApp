import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
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

  late final List<_ChatMessage> _messages = [
    _ChatMessage(
      text:
          'Merhaba! Ben Sleepy Assistant 🌙\n\nUyku sorunlarınız, uyku rutinleri veya daha iyi dinlenme için ipuçları hakkındaki sorularınızı yanıtlamaya hazırım.\n\nNasıl yardımcı olabilirim?',
      sender: _Sender.assistant,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty || _isTyping) return;

    setState(() {
      _messages.add(_ChatMessage(text: text, sender: _Sender.user));
      _isTyping = true;
    });
    _controller.clear();
    _scrollToBottom();

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

    // Uyku düzeni / saat
    if (_anyMatch(q, ['uyku', 'uyu', 'uyuya', 'uyumak', 'uyumam'])) {
      if (_anyMatch(q, ['saat', 'kaç', 'ne zaman', 'süre', 'uzun', 'kısa'])) {
        return 'Yetişkinlerin her gece **7-9 saat** uyuması önerilir.\n\n'
            'Her gün aynı saatte yatıp kalkmak, vücudunuzun biyolojik saatini düzenler. '
            'Hafta sonları bile bu rutinden sapmamaya çalışın. ⏰';
      }
      if (_anyMatch(
          q, ['sorun', 'problem', 'uyuyamıyorum', 'zor', 'güç', 'düzensiz'])) {
        return 'Uyku sorunları için birkaç öneri:\n\n'
            '• **Tutarlı saat:** Her gün aynı saatte yat ve kalk.\n'
            '• **Yatak odası**: Karanlık, serin (16–19°C) ve sessiz tutun.\n'
            '• **Ekran süresi**: Yatmadan 1 saat önce telefon/bilgisayarı bırakın.\n'
            '• **Kafein**: Öğleden sonra kahve/çay tüketimini azaltın. ☕\n\n'
            'Sorunlar devam ederse bir doktora danışmanızı öneririm.';
      }
    }

    // Meditasyon
    if (_anyMatch(
        q, ['meditasyon', 'nefes', 'rahatlama', 'stres', 'sakinleş'])) {
      return '**4-7-8 Nefes Tekniği** uyku öncesi harika çalışır:\n\n'
          '1. Burumdan 4 saniye nefes al.\n'
          '2. 7 saniye nefesi tut.\n'
          '3. Ağızdan 8 saniyede yavaşça ver.\n\n'
          'Bunu 3-4 kez tekrarlamak parasempatik sinir sisteminizi aktive eder ve zihninizi sakinleştirir. 🧘';
    }

    // Rüya
    if (_anyMatch(q, ['rüya', 'rüyalar', 'kabus', 'rem'])) {
      return 'Rüyalar genellikle **REM uykusu** sırasında görülür.\n\n'
          '• Canlı rüyalar için B6 vitamini alımını artırabilirsiniz (muz, avokado).\n'
          '• Kabuslar sıklaşıyorsa stres veya uyku düzensizliği işareti olabilir.\n'
          '• Rüya günlüğü tutmak, rüyalarınızı hatırlamanıza yardımcı olur. 📓';
    }

    // Alarm / uyanma
    if (_anyMatch(q, ['alarm', 'uyan', 'sabah', 'kalk', 'zinde'])) {
      return 'Zinde uyanmak için uyku döngülerinizi hesaplayın:\n\n'
          'Bir uyku döngüsü yaklaşık **90 dakika** sürer. '
          '4.5, 6, 7.5 veya 9 saatlik uyku sürelerinde uyanmayı deneyin.\n\n'
          'Doğal ışık alarmı veya güneş simülatörü de uyanışı kolaylaştırır. 🌅';
    }

    // Çevresel faktörler
    if (_anyMatch(
        q, ['oda', 'sıcaklık', 'ışık', 'karanlık', 'gürültü', 'ses'])) {
      return 'İdeal uyku ortamı için:\n\n'
          '🌡️ **Sıcaklık:** 16–19°C arası en uygun.\n'
          '🌑 **Işık:** Tamamen karanlık ya da uyku maskesi.\n'
          '🔇 **Ses:** Beyaz gürültü veya SleepyApp\'in ambient sesleri.\n'
          '🛏️ **Yatak:** Kaliteli yatak ve yastık uyku kalitesini ciddi artırır.';
    }

    // Beslenme
    if (_anyMatch(
        q, ['yemek', 'beslen', 'kahve', 'kafein', 'alkol', 'içki', 'su'])) {
      return 'Uyku ve beslenme ilişkisi:\n\n'
          '☕ **Kafein:** Yatmadan 6 saat önce kesin.\n'
          '🍷 **Alkol:** Uyku kalitesini düşürür; REM uykunuzu bozar.\n'
          '🍽️ **Ağır yemek:** Yatmadan 2-3 saat önce hafif bir şeyler yiyin.\n'
          '🍌 **Magnezyum & Triptofan:** Muz, badem, süt—doğal uyku destekçileri.';
    }

    // Egzersiz
    if (_anyMatch(q, ['spor', 'egzersiz', 'yürüyüş', 'hareket', 'koşu'])) {
      return 'Egzersiz uyku kalitesini artırır, ancak zamanlama önemli:\n\n'
          '✅ Sabah veya öğlen egzersizi ideáldır.\n'
          '⚠️ Yatmadan 3 saat içinde yoğun egzersiz yapmaktan kaçının; '
          'kortizol ve vücut ısısını yükseltir.\n'
          '🧘 Yatmadan önce yoga veya hafif germe hareketleri ise mükemmel! 🌙';
    }

    // Uyku hijyeni
    if (_anyMatch(q, ['hijyen', 'rutin', 'alışkanlık', 'öneri', 'ipucu'])) {
      return 'Altın uyku hijyeni kuralları:\n\n'
          '1. 📱 Yatmadan 1 saat önce ekranları kapat.\n'
          '2. 🛁 Sıcak duş sirkadyen ritmi destekler.\n'
          '3. 📚 Hafif okuma veya meditasyon yap.\n'
          '4. ☕ Öğleden sonra kafein alma.\n'
          '5. 🌡️ Oda sıcaklığını 16–19°C\'ye ayarla.\n'
          '6. ⏰ Her gün aynı saatte yat ve kalk.';
    }

    // Selam / teşekkür
    if (_anyMatch(
        q, ['merhaba', 'selam', 'nasılsın', 'iyi günler', 'günaydın'])) {
      return 'Merhaba! 🌙 Ben Sleepy Assistant.\n\n'
          'Uyku sağlığınız hakkında sorularınızı yanıtlamaya hazırım. '
          'Uyku süreniz, rutinleriniz, meditasyon veya uyku ortamı hakkında ne öğrenmek istersiniz?';
    }

    if (_anyMatch(q, ['teşekkür', 'sağol', 'thanks', 'eyvallah'])) {
      return 'Rica ederim! 😊\n\n'
          'Daha iyi uyku için başka sorularınız olursa buradayım. '
          'İyi geceler ve dinlendirici uykular dilerim. 🌙✨';
    }

    // Varsayılan
    return 'Bu konuda şunu söyleyebilirim:\n\n'
        'Kaliteli uyku, fiziksel ve mental sağlığın temel taşıdır. '
        'Düzenli uyku saatleri, rahatlatıcı bir ortam ve stres yönetimi '
        'uyku kalitenizi önemli ölçüde artırır. 🌙\n\n'
        'Daha spesifik bir konuda yardımcı olmamı ister misiniz? '
        'Örneğin: *uyku süresi*, *meditasyon teknikleri*, *uyku rutini* veya *uyku ortamı* hakkında sorabilirsiniz.';
  }

  bool _anyMatch(String text, List<String> keywords) {
    return keywords.any((k) => text.contains(k));
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
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sleepy Assistant',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: AppSizes.fontMd,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'YZ destekli uyku danışmanı',
                        style: TextStyle(
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
            body: proState.isPro
                ? _ChatBody(
                    messages: _messages,
                    isTyping: _isTyping,
                    controller: _controller,
                    scrollController: _scrollController,
                    focusNode: _focusNode,
                    onSend: _sendMessage,
                  )
                : _ProGateBody(),
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
            const Text(
              'YZ destekli kişisel uyku danışmanınıza erişmek için PRO üye olun.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: AppSizes.fontMd,
                height: 1.5,
              ),
            ),
            const SizedBox(height: AppSizes.xl),
            _FeatureBadge(
              emoji: '💬',
              text: 'Uyku sorunlarınız için kişisel tavsiyeler',
            ),
            const SizedBox(height: AppSizes.sm),
            _FeatureBadge(
              emoji: '🧠',
              text: 'Meditasyon ve nefes teknikleri rehberliği',
            ),
            const SizedBox(height: AppSizes.sm),
            _FeatureBadge(
              emoji: '📊',
              text: 'Uyku rutini oluşturma desteği',
            ),
            const SizedBox(height: AppSizes.xxl),
            GradientButton(
              label: '✨ PRO\'ya Geç',
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
  });

  final List<_ChatMessage> messages;
  final bool isTyping;
  final TextEditingController controller;
  final ScrollController scrollController;
  final FocusNode focusNode;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                  hintText: 'Uyku hakkında bir şey sorun…',
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
