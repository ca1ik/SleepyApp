import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sleepy_ai/core/constants/app_colors.dart';
import 'package:sleepy_ai/core/constants/app_sizes.dart';
import 'package:sleepy_ai/features/rewards/cubit/rewards_cubit.dart';
import 'package:sleepy_ai/shared/models/app_models.dart';
import 'package:sleepy_ai/shared/widgets/common_widgets.dart';

// ── Breathing phases ─────────────────────────────────────────────────────────

enum _Phase { inhale, hold, exhale, rest }

class _PhaseInfo {
  const _PhaseInfo(this.phase, this.labelKey, this.seconds, this.color);
  final _Phase phase;
  final String labelKey;
  final int seconds;
  final Color color;
}

const _kPhases = [
  _PhaseInfo(_Phase.inhale, 'phaseInhale', 4, Color(0xFF7C3AED)),
  _PhaseInfo(_Phase.hold, 'phaseHold', 4, Color(0xFF9D64F5)),
  _PhaseInfo(_Phase.exhale, 'phaseExhale', 6, Color(0xFF3B82F6)),
  _PhaseInfo(_Phase.rest, 'phaseRest', 2, Color(0xFF1E1035)),
];

// ── Starfield ────────────────────────────────────────────────────────────────

class _StarData {
  _StarData(int seed) {
    final r = math.Random(seed);
    x = r.nextDouble();
    y = r.nextDouble();
    radius = 0.5 + r.nextDouble() * 1.5;
    opacity = 0.2 + r.nextDouble() * 0.7;
    twinkle = r.nextDouble() * math.pi * 2;
  }
  late final double x, y, radius, opacity, twinkle;
}

class _StarPainter extends CustomPainter {
  _StarPainter(this.stars, this.t) : super(repaint: null);
  final List<_StarData> stars;
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint();
    for (final s in stars) {
      final tw = 0.4 + 0.6 * ((math.sin(t * math.pi * 2 + s.twinkle) + 1) / 2);
      p.color = Colors.white.withAlpha((s.opacity * tw * 190).round());
      canvas.drawCircle(
          Offset(s.x * size.width, s.y * size.height), s.radius, p);
    }
  }

  @override
  bool shouldRepaint(_StarPainter o) => o.t != t;
}

// ── Particle ─────────────────────────────────────────────────────────────────

class _Particle {
  _Particle(math.Random rng, double cx, double cy)
      : x = cx,
        y = cy,
        vx = (rng.nextDouble() - 0.5) * 3.5,
        vy = -1 - rng.nextDouble() * 2.5,
        life = 1.0,
        maxLife = 0.6 + rng.nextDouble() * 0.9,
        radius = 1.5 + rng.nextDouble() * 3;
  double x, y, vx, vy, life;
  final double maxLife, radius;

  bool tick(double dt) {
    x += vx;
    y += vy;
    vy += 0.05;
    life -= dt;
    return life > 0;
  }
}

class _ParticlePainter extends CustomPainter {
  _ParticlePainter(this.particles, this.color);
  final List<_Particle> particles;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint();
    for (final pt in particles) {
      final a = ((pt.life / pt.maxLife) * 200).clamp(0, 255).toInt();
      p.color = color.withAlpha(a);
      canvas.drawCircle(Offset(pt.x, pt.y), pt.radius, p);
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter o) => true;
}

// ── Glow Painter ──────────────────────────────────────────────────────────────

class _GlowPainter extends CustomPainter {
  _GlowPainter(this.color, this.scale);
  final Color color;
  final double scale;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final maxR = size.shortestSide * 0.55 * scale;
    for (var i = 3; i >= 1; i--) {
      final r = maxR * (1.0 + i * 0.25);
      final alpha = (0.04 * i * scale).clamp(0.0, 0.15);
      canvas.drawCircle(
        Offset(cx, cy),
        r,
        Paint()
          ..shader = RadialGradient(
            colors: [
              color.withAlpha((alpha * 255).round()),
              Colors.transparent
            ],
          ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r)),
      );
    }
  }

  @override
  bool shouldRepaint(_GlowPainter o) => o.scale != scale || o.color != color;
}

// ── Main Page ─────────────────────────────────────────────────────────────────

class BreathingGamePage extends StatefulWidget {
  const BreathingGamePage({super.key});

  @override
  State<BreathingGamePage> createState() => _BreathingGamePageState();
}

class _BreathingGamePageState extends State<BreathingGamePage>
    with TickerProviderStateMixin {
  // Animation controllers
  late final AnimationController _starAnim =
      AnimationController(vsync: this, duration: const Duration(seconds: 8))
        ..repeat();
  late final AnimationController _breathAnim =
      AnimationController(vsync: this, duration: const Duration(seconds: 4));
  late final AnimationController _tickAnim = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 50))
    ..repeat();

  // Stable star list
  final _stars = List.generate(150, (i) => _StarData(i * 13 + 7));

  // Game state
  int _phaseIdx = 0;
  int _cycles = 0;
  int _secsLeft = _kPhases[0].seconds;
  bool _running = false;
  bool _done = false;
  int _score = 0;

  // Particles
  final _parts = <_Particle>[];
  final _rng = math.Random();

  _PhaseInfo get _cur => _kPhases[_phaseIdx];

  @override
  void initState() {
    super.initState();
    _tickAnim.addListener(_onTick);
  }

  @override
  void dispose() {
    _starAnim.dispose();
    _breathAnim.dispose();
    _tickAnim.dispose();
    super.dispose();
  }

  // ── Game Logic ─────────────────────────────────────────────────────────────

  void _start() {
    setState(() {
      _phaseIdx = 0;
      _cycles = 0;
      _secsLeft = _kPhases[0].seconds;
      _running = true;
      _done = false;
      _score = 0;
    });
    _advancePhase();
  }

  void _advancePhase() {
    if (!_running || !mounted) return;
    final cfg = _kPhases[_phaseIdx];

    _breathAnim.duration = Duration(seconds: cfg.seconds);
    if (cfg.phase == _Phase.inhale) {
      _breathAnim.forward(from: 0);
    } else if (cfg.phase == _Phase.exhale) {
      _breathAnim.reverse(from: 1);
    }

    _phaseTick(cfg.seconds);
  }

  Future<void> _phaseTick(int total) async {
    for (var remaining = total; remaining > 0; remaining--) {
      await Future<void>.delayed(const Duration(seconds: 1));
      if (!mounted || !_running) return;
      setState(() => _secsLeft = remaining - 1);
    }
    if (!mounted || !_running) return;
    _onPhaseComplete();
  }

  void _onPhaseComplete() {
    _phaseIdx = (_phaseIdx + 1) % _kPhases.length;

    if (_phaseIdx == 0) {
      // Completed one full breath cycle
      _cycles++;
      _score += 50;
      _burstParticles();

      if (_cycles >= 10) {
        _finish();
        return;
      }
    }

    setState(() => _secsLeft = _kPhases[_phaseIdx].seconds);
    _advancePhase();
  }

  void _finish() {
    if (!mounted) return;
    setState(() {
      _running = false;
      _done = true;
    });
    _breathAnim.stop();

    final rc = context.read<RewardsCubit>();
    rc.recordGameScore(
      GameScoreRecord(
          gameId: 'breathing', score: _score, timestamp: DateTime.now()),
    );
    if (_cycles >= 5) rc.unlockBadge(BadgeType.cosmicBreather);
  }

  void _onTick() {
    if (!_running || _parts.isEmpty) return;
    const dt = 0.05;
    setState(() => _parts.removeWhere((p) => !p.tick(dt)));
  }

  void _burstParticles() {
    final s = context.size ?? const Size(400, 700);
    for (var i = 0; i < 30; i++) {
      _parts.add(_Particle(_rng, s.width / 2, s.height * 0.42));
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: AppColors.textPrimary),
            onPressed: () => Get.back(),
          ),
          title: Text(
            'cosmicBreath'.tr,
            style: TextStyle(
                color: AppColors.textPrimary, fontWeight: FontWeight.bold),
          ),
          actions: [
            if (_running)
              Padding(
                padding: const EdgeInsets.only(right: AppSizes.md),
                child: Center(
                  child: Text(
                    '⭐ $_score',
                    style: const TextStyle(
                        color: AppColors.accentGold,
                        fontWeight: FontWeight.bold,
                        fontSize: AppSizes.fontLg),
                  ),
                ),
              ),
          ],
        ),
        body: _done
            ? _FinishedView(score: _score, cycles: _cycles)
            : _buildGame(),
      ),
    );
  }

  Widget _buildGame() {
    return AnimatedBuilder(
      animation: Listenable.merge([_starAnim, _breathAnim]),
      builder: (ctx, _) {
        final scale = _running ? (0.45 + 0.55 * _breathAnim.value) : 0.5;
        final color = _running ? _cur.color : AppColors.primary;

        return Stack(
          children: [
            // Starfield
            RepaintBoundary(
              child: CustomPaint(
                painter: _StarPainter(_stars, _starAnim.value),
                child: const SizedBox.expand(),
              ),
            ),
            // Glow
            CustomPaint(
              painter: _GlowPainter(color, scale),
              child: const SizedBox.expand(),
            ),
            // Particles
            if (_parts.isNotEmpty)
              CustomPaint(
                painter: _ParticlePainter(List.from(_parts), color),
                child: const SizedBox.expand(),
              ),
            // Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Orb
                  Transform.scale(
                    scale: scale,
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            color.withAlpha(230),
                            color.withAlpha(80),
                            Colors.transparent,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: color.withAlpha(110),
                            blurRadius: 55,
                            spreadRadius: 15,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _running ? '$_secsLeft' : '🌌',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: _running ? 64 : 52,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (_running) ...[
                    Text(
                      _cur.labelKey.tr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'cyclesProgress'.trParams(
                        {'current': '${_cycles + 1}', 'total': '10'},
                      ),
                      style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: AppSizes.fontMd),
                    ),
                  ] else ...[
                    Text(
                      'cosmicBreath'.tr,
                      style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        'cosmicBreathIntro'.tr,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: AppSizes.fontMd,
                            height: 1.5),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Phase guide
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _kPhases.map((p) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: p.color),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${p.labelKey.tr}\n${'secondsLeft'.trParams({
                                      'sec': '${p.seconds}'
                                    })}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: AppColors.textMuted, fontSize: 10),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 40),
                    GestureDetector(
                      onTap: _start,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 36, vertical: 14),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                                color: AppColors.primary.withAlpha(100),
                                blurRadius: 20)
                          ],
                        ),
                        child: Text(
                          'startCosmicBreath'.tr,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: AppSizes.fontXl,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

// ── Finished View ─────────────────────────────────────────────────────────────

class _FinishedView extends StatelessWidget {
  const _FinishedView({required this.score, required this.cycles});
  final int score;
  final int cycles;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🌌', style: TextStyle(fontSize: 80)),
            const SizedBox(height: AppSizes.lg),
            Text(
              'awesome'.tr,
              style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 36,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSizes.sm),
            Text(
              'cyclesCompleted'.trParams({'cycles': '$cycles'}),
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: AppSizes.fontLg),
            ),
            const SizedBox(height: AppSizes.xl),
            Container(
              padding: const EdgeInsets.all(AppSizes.xl),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              ),
              child: Column(
                children: [
                  Text('points'.tr,
                      style: const TextStyle(
                          color: Colors.white70,
                          fontSize: AppSizes.fontSm,
                          letterSpacing: 3)),
                  Text(
                    '$score',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 72,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            if (cycles >= 5) ...[
              const SizedBox(height: AppSizes.md),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.md, vertical: AppSizes.sm),
                decoration: BoxDecoration(
                  color: AppColors.accentGold.withAlpha(25),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  border: Border.all(color: AppColors.accentGold.withAlpha(80)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🌌', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Text(
                      'cosmicBreathBadge'.tr,
                      style: const TextStyle(
                          color: AppColors.accentGold,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: AppSizes.xxl),
            GradientButton(
              label: 'playAgain'.tr,
              onPressed: () => Get.offAndToNamed('/games/breathing'),
            ),
            const SizedBox(height: AppSizes.sm),
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                'backToGames'.tr,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
