// ignore_for_file: public_member_api_docs
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleepy_ai/core/constants/app_colors.dart';
import 'package:sleepy_ai/core/constants/app_sizes.dart';
import 'package:sleepy_ai/features/level_system/cubit/level_cubit.dart';
import 'package:sleepy_ai/features/level_system/domain/level_models.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Level Up Kutlama Overlay'i
// ─────────────────────────────────────────────────────────────────────────────

class LevelUpOverlay extends StatefulWidget {
  const LevelUpOverlay({
    super.key,
    required this.newLevel,
    required this.oldLevel,
  });

  final int newLevel;
  final int oldLevel;

  @override
  State<LevelUpOverlay> createState() => _LevelUpOverlayState();
}

class _LevelUpOverlayState extends State<LevelUpOverlay>
    with TickerProviderStateMixin {
  late final AnimationController _mainCtrl;
  late final AnimationController _particleCtrl;

  // Ana animasyon aşamaları
  late final Animation<double> _bgFade;
  late final Animation<double> _badgeScale;
  late final Animation<double> _badgeOpacity;
  late final Animation<double> _textSlide;
  late final Animation<double> _titleFade;
  late final Animation<double> _btnFade;
  late final Animation<double> _glowPulse;

  @override
  void initState() {
    super.initState();

    _mainCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
    _particleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );

    // Aralıklı animasyonlar
    _bgFade = CurvedAnimation(
      parent: _mainCtrl,
      curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
    );
    _badgeScale = CurvedAnimation(
      parent: _mainCtrl,
      curve: const Interval(0.05, 0.5, curve: Curves.elasticOut),
    );
    _badgeOpacity = CurvedAnimation(
      parent: _mainCtrl,
      curve: const Interval(0.05, 0.35, curve: Curves.easeOut),
    );
    _textSlide = CurvedAnimation(
      parent: _mainCtrl,
      curve: const Interval(0.38, 0.68, curve: Curves.easeOutBack),
    );
    _titleFade = CurvedAnimation(
      parent: _mainCtrl,
      curve: const Interval(0.55, 0.82, curve: Curves.easeOut),
    );
    _btnFade = CurvedAnimation(
      parent: _mainCtrl,
      curve: const Interval(0.78, 1.0, curve: Curves.easeOut),
    );
    _glowPulse = CurvedAnimation(
      parent: _mainCtrl,
      curve: const Interval(0.05, 1.0, curve: Curves.linear),
    );

    Future.microtask(() {
      _mainCtrl.forward();
      _particleCtrl.repeat();
    });
  }

  @override
  void dispose() {
    _mainCtrl.dispose();
    _particleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final titleInfo = LevelHelper.titleForLevel(widget.newLevel);
    final oldTitleInfo = LevelHelper.titleForLevel(widget.oldLevel);
    final titleChanged = titleInfo.title != oldTitleInfo.title;

    return Material(
      color: Colors.transparent,
      child: AnimatedBuilder(
        animation: Listenable.merge([_mainCtrl, _particleCtrl]),
        builder: (_, __) {
          return Stack(
            children: [
              // ── Arka plan overlay ──────────────────────────────────────────
              Positioned.fill(
                child: Opacity(
                  opacity: _bgFade.value * 0.93,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.center,
                        radius: 1.6,
                        colors: [
                          titleInfo.color.withAlpha(45),
                          const Color(0xFF0A0118).withAlpha(235),
                          const Color(0xFF060012),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ── Parçacık patlaması ─────────────────────────────────────────
              Positioned.fill(
                child: RepaintBoundary(
                  child: CustomPaint(
                    painter: _LevelUpParticlePainter(
                      progress: _particleCtrl.value,
                      color: titleInfo.color,
                      bgOpacity: _bgFade.value,
                    ),
                  ),
                ),
              ),

              // ── İçerik ────────────────────────────────────────────────────
              SafeArea(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.xxl,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Rozet
                        Transform.scale(
                          scale: _badgeScale.value.clamp(0.0, 1.08),
                          child: Opacity(
                            opacity: _badgeOpacity.value.clamp(0.0, 1.0),
                            child: _LevelUpBadge(
                              level: widget.newLevel,
                              titleInfo: titleInfo,
                              glowStrength: _glowPulse.value,
                            ),
                          ),
                        ),

                        const SizedBox(height: 36),

                        // "SEVİYE ATLADINIZ!"
                        Transform.translate(
                          offset: Offset(0, 35 * (1 - _textSlide.value)),
                          child: Opacity(
                            opacity: _textSlide.value.clamp(0.0, 1.0),
                            child: Column(
                              children: [
                                ShaderMask(
                                  shaderCallback: (b) =>
                                      AppColors.primaryGradient.createShader(b),
                                  child: const Text(
                                    'SEVİYE ATLADINIZ!',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 2,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Seviye ${widget.oldLevel}  →  Seviye ${widget.newLevel}',
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: AppSizes.fontLg,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Yeni Unvan (değiştiyse)
                        if (titleChanged)
                          Opacity(
                            opacity: _titleFade.value.clamp(0.0, 1.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 22,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: titleInfo.color.withAlpha(18),
                                borderRadius:
                                    BorderRadius.circular(AppSizes.radiusLg),
                                border: Border.all(
                                  color: titleInfo.color.withAlpha(80),
                                  width: 1.5,
                                ),
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    '✨  Yeni Unvan Kazanıldı',
                                    style: TextStyle(
                                      color: AppColors.textMuted,
                                      fontSize: AppSizes.fontSm,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '${titleInfo.emoji}  ${titleInfo.title}',
                                    style: TextStyle(
                                      color: titleInfo.color,
                                      fontSize: AppSizes.fontXl,
                                      fontWeight: FontWeight.w800,
                                      shadows: [
                                        Shadow(
                                          color: titleInfo.glowColor,
                                          blurRadius: 12,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        const SizedBox(height: 36),

                        // Devam Et Butonu
                        Opacity(
                          opacity: _btnFade.value.clamp(0.0, 1.0),
                          child: Transform.translate(
                            offset: Offset(0, 22 * (1 - _btnFade.value)),
                            child: GestureDetector(
                              onTap: () {
                                context.read<LevelCubit>().acknowledgeLevelUp();
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 44,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      titleInfo.color,
                                      titleInfo.color.withAlpha(200),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: titleInfo.glowColor,
                                      blurRadius: 22,
                                      spreadRadius: 3,
                                    ),
                                  ],
                                ),
                                child: const Text(
                                  'Harika!  Devam Et  ✨',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: AppSizes.fontLg,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Level Up Rozeti
// ─────────────────────────────────────────────────────────────────────────────

class _LevelUpBadge extends StatelessWidget {
  const _LevelUpBadge({
    required this.level,
    required this.titleInfo,
    required this.glowStrength,
  });

  final int level;
  final LevelTitleInfo titleInfo;
  final double glowStrength;

  @override
  Widget build(BuildContext context) {
    final g = glowStrength;
    return Stack(
      alignment: Alignment.center,
      children: [
        // Dış parıltı halkası
        Container(
          width: 155 + g * 18,
          height: 155 + g * 18,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: titleInfo.color.withAlpha((8 * g).round()),
            boxShadow: [
              BoxShadow(
                color: titleInfo.glowColor,
                blurRadius: 50 * g,
                spreadRadius: 12 * g,
              ),
            ],
          ),
        ),
        // Orta halka
        Container(
          width: 128,
          height: 128,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: titleInfo.color.withAlpha(12),
            border: Border.all(
              color: titleInfo.color.withAlpha(70),
              width: 2,
            ),
          ),
        ),
        // İç rozet
        Container(
          width: 106,
          height: 106,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                titleInfo.color.withAlpha(90),
                const Color(0xFF1E1035),
              ],
            ),
            border: Border.all(
              color: titleInfo.color,
              width: 2.5,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Lv.',
                  style: TextStyle(
                    color: titleInfo.color.withAlpha(200),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '$level',
                  style: TextStyle(
                    color: titleInfo.color,
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    height: 1.0,
                    shadows: [
                      Shadow(
                        color: titleInfo.glowColor,
                        blurRadius: 18,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Emoji rozeti
        Positioned(
          bottom: 6,
          right: 6,
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFF1E1035),
              shape: BoxShape.circle,
              border: Border.all(color: titleInfo.color, width: 2),
            ),
            child: Center(
              child: Text(
                titleInfo.emoji,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Parçacık Patlaması Painter
// ─────────────────────────────────────────────────────────────────────────────

class _LevelUpParticlePainter extends CustomPainter {
  _LevelUpParticlePainter({
    required this.progress,
    required this.color,
    required this.bgOpacity,
  });

  final double progress;
  final Color color;
  final double bgOpacity;

  static final List<_Particle> _particles = _generateParticles();

  static List<_Particle> _generateParticles() {
    final rnd = math.Random(42);
    return List.generate(65, (i) {
      final angle = (i / 65) * math.pi * 2 + rnd.nextDouble() * 0.4 - 0.2;
      return _Particle(
        angle: angle,
        speed: 0.18 + rnd.nextDouble() * 0.82,
        size: 2.2 + rnd.nextDouble() * 5.0,
        rotSpeed: rnd.nextDouble() * 0.3 - 0.15,
        delay: rnd.nextDouble() * 0.28,
        isSquare: rnd.nextBool(),
      );
    });
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()..style = PaintingStyle.fill;

    // Yıldız çizgileri (patlama anında)
    if (progress < 0.45) {
      final lineOpacity = bgOpacity * (1 - progress / 0.45);
      final linePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = color.withAlpha((255 * lineOpacity * 0.6).round());
      for (int i = 0; i < 14; i++) {
        final angle = (i / 14) * math.pi * 2;
        final len = progress * size.height * 0.42;
        canvas.drawLine(
          center,
          Offset(
            center.dx + math.cos(angle) * len,
            center.dy + math.sin(angle) * len,
          ),
          linePaint,
        );
      }
    }

    // Parçacıklar
    for (final p in _particles) {
      final t = ((progress - p.delay) / (1 - p.delay)).clamp(0.0, 1.0);
      if (t <= 0) continue;

      final dist = t * p.speed * size.height * 0.58;
      final fall = t * t * 90; // yerçekimi
      final px = center.dx + math.cos(p.angle) * dist;
      final py = center.dy + math.sin(p.angle) * dist + fall;

      final opacity = (t < 0.55 ? 1.0 : (1.0 - (t - 0.55) / 0.45)) * bgOpacity;

      paint.color = Color.lerp(
        color.withAlpha((opacity * 255).round()),
        Colors.white.withAlpha((opacity * 200).round()),
        t * 0.7,
      )!;

      final particleSize = p.size * (1 - t * 0.45);

      if (p.isSquare) {
        canvas.save();
        canvas.translate(px, py);
        canvas.rotate(t * p.rotSpeed * math.pi * 5);
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset.zero,
            width: particleSize,
            height: particleSize,
          ),
          paint,
        );
        canvas.restore();
      } else {
        canvas.drawCircle(
          Offset(px, py),
          particleSize / 2,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_LevelUpParticlePainter old) =>
      old.progress != progress || old.bgOpacity != bgOpacity;
}

class _Particle {
  const _Particle({
    required this.angle,
    required this.speed,
    required this.size,
    required this.rotSpeed,
    required this.delay,
    required this.isSquare,
  });

  final double angle;
  final double speed;
  final double size;
  final double rotSpeed;
  final double delay;
  final bool isSquare;
}
