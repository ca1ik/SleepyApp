import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sleepy_ai/core/constants/app_constants.dart';
import 'package:sleepy_ai/features/rewards/cubit/rewards_cubit.dart';
import 'package:sleepy_ai/shared/models/app_models.dart';

// ── Background star (static twinkle) ─────────────────────────────────────────

class _BgStar {
  _BgStar(int seed) {
    final r = math.Random(seed);
    x = r.nextDouble();
    y = r.nextDouble();
    radius = 0.3 + r.nextDouble() * 1.2;
    opacity = 0.15 + r.nextDouble() * 0.5;
    twinkle = r.nextDouble() * math.pi * 2;
  }
  late final double x, y, radius, opacity, twinkle;
}

class _BgStarPainter extends CustomPainter {
  _BgStarPainter(this.stars, this.t) : super(repaint: null);
  final List<_BgStar> stars;
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint();
    for (final s in stars) {
      final tw = 0.4 + 0.6 * ((math.sin(t * math.pi * 2 + s.twinkle) + 1) / 2);
      p.color = Colors.white.withAlpha((s.opacity * tw * 180).round());
      canvas.drawCircle(
          Offset(s.x * size.width, s.y * size.height), s.radius, p);
    }
  }

  @override
  bool shouldRepaint(_BgStarPainter old) => old.t != t;
}

// ── Falling star kinds ────────────────────────────────────────────────────────

enum _StarKind { normal, gold, rainbow }

// ── Falling star entity ───────────────────────────────────────────────────────

class _FallingStar {
  _FallingStar(math.Random rng, double screenH)
      : x = rng.nextDouble(),
        y = -(rng.nextDouble() * screenH * 0.5),
        speed = 60 + rng.nextDouble() * 130,
        radius = 6.0 + rng.nextDouble() * 8,
        kind = _pickKind(rng),
        hue = rng.nextDouble() * 360;

  double x; // 0..1 normalised
  double y; // absolute pixels from top
  final double speed; // px/sec
  final double radius;
  final _StarKind kind;
  final double hue;

  static _StarKind _pickKind(math.Random rng) {
    final v = rng.nextDouble();
    if (v < 0.08) return _StarKind.rainbow;
    if (v < 0.20) return _StarKind.gold;
    return _StarKind.normal;
  }

  Color colorAt(double t) => switch (kind) {
        _StarKind.gold => const Color(0xFFFFD700),
        _StarKind.rainbow =>
          HSVColor.fromAHSV(1, (hue + t * 80) % 360, 0.9, 1).toColor(),
        _StarKind.normal => Colors.white,
      };

  int get points => switch (kind) {
        _StarKind.gold => 25,
        _StarKind.rainbow => 50,
        _StarKind.normal => 10,
      };
}

// ── Falling stars painter ─────────────────────────────────────────────────────

class _FallingStarPainter extends CustomPainter {
  _FallingStarPainter(this.stars, this.t) : super(repaint: null);
  final List<_FallingStar> stars;
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    for (final s in stars) {
      final color = s.colorAt(t);
      final cx = s.x * size.width;
      final cy = s.y;

      // Glow halo
      canvas.drawCircle(
        Offset(cx, cy),
        s.radius * 2.2,
        Paint()
          ..color = color.withAlpha(55)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14),
      );

      // Solid body
      canvas.drawCircle(Offset(cx, cy), s.radius, Paint()..color = color);

      // 6-spike star outline
      final spike = Paint()
        ..color = color.withAlpha(200)
        ..strokeWidth = 1.4
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      final spikeLen = s.radius * 2.4;
      for (int i = 0; i < 6; i++) {
        final a = i * math.pi / 3;
        canvas.drawLine(
          Offset(cx, cy),
          Offset(cx + math.cos(a) * spikeLen, cy + math.sin(a) * spikeLen),
          spike,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_FallingStarPainter old) => true;
}

// ── Catch flash ───────────────────────────────────────────────────────────────

class _Flash {
  _Flash(this.x, this.y, this.color) : age = 0;
  final double x, y;
  final Color color;
  double age; // 0→1
}

class _FlashPainter extends CustomPainter {
  _FlashPainter(this.flashes) : super(repaint: null);
  final List<_Flash> flashes;

  @override
  void paint(Canvas canvas, Size size) {
    for (final f in flashes) {
      final alpha = ((1 - f.age) * 220).round();
      canvas.drawCircle(
        Offset(f.x, f.y),
        30 + 60 * f.age,
        Paint()
          ..color = f.color.withAlpha(alpha)
          ..maskFilter =
              MaskFilter.blur(BlurStyle.normal, 10 + 20 * (1 - f.age)),
      );
    }
  }

  @override
  bool shouldRepaint(_FlashPainter old) => true;
}

// ── Main page ─────────────────────────────────────────────────────────────────

class StarCatcherPage extends StatefulWidget {
  const StarCatcherPage({super.key});

  @override
  State<StarCatcherPage> createState() => _StarCatcherPageState();
}

class _StarCatcherPageState extends State<StarCatcherPage>
    with TickerProviderStateMixin {
  static const int _gameDuration = 90;
  static const int _maxStars = 10;
  static const int _badgeThreshold = 300;
  static const double _dt = 1 / 60;

  late final AnimationController _bgAnim;
  late final AnimationController _gameAnim;

  final _rng = math.Random();
  final List<_BgStar> _bgStars = List.generate(120, (i) => _BgStar(i + 77));
  final List<_FallingStar> _fallingStars = [];
  final List<_Flash> _flashes = [];

  int _score = 0;
  int _caught = 0;
  int _secondsLeft = _gameDuration;
  bool _gameOver = false;
  bool _badgeUnlocked = false;

  double _screenH = 700;
  double _screenW = 400;

  double _timeSec = 0;

  @override
  void initState() {
    super.initState();

    _bgAnim =
        AnimationController(vsync: this, duration: const Duration(seconds: 7))
          ..repeat();

    _gameAnim =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat();

    _gameAnim.addListener(_tick);
  }

  void _tick() {
    if (_gameOver) return;

    _timeSec += _dt;

    // Countdown
    final elapsed = (_gameDuration - _timeSec).ceil().clamp(0, _gameDuration);
    if (elapsed != _secondsLeft) {
      _secondsLeft = elapsed;
      if (_secondsLeft <= 0) {
        _endGame();
        return;
      }
    }

    // Move stars
    for (final s in _fallingStars) {
      s.y += s.speed * _dt;
    }
    _fallingStars.removeWhere((s) => s.y > _screenH + s.radius * 2);

    // Spawn to fill up
    while (_fallingStars.length < _maxStars) {
      _fallingStars.add(_FallingStar(_rng, _screenH));
    }

    // Age flashes
    for (final f in _flashes) {
      f.age += _dt * 2.5;
    }
    _flashes.removeWhere((f) => f.age >= 1);

    setState(() {});
  }

  void _endGame() {
    _gameAnim.stop();
    _gameOver = true;

    final cubit = context.read<RewardsCubit>();
    cubit.recordGameScore(GameScoreRecord(
      gameId: 'star_catcher',
      score: _score,
      timestamp: DateTime.now(),
    ));

    if (_score >= _badgeThreshold) {
      _badgeUnlocked = true;
      cubit.unlockBadge(BadgeType.starCatcher);
    }

    setState(() {});
  }

  void _onTapDown(TapDownDetails details) {
    if (_gameOver) return;
    final tap = details.localPosition;

    for (int i = _fallingStars.length - 1; i >= 0; i--) {
      final s = _fallingStars[i];
      final sx = s.x * _screenW;
      final sy = s.y;
      if ((Offset(sx, sy) - tap).distance <= s.radius + 24) {
        _flashes.add(_Flash(sx, sy, s.colorAt(_timeSec)));
        _score += s.points;
        _caught++;
        _fallingStars.removeAt(i);
        setState(() {});
        return;
      }
    }
  }

  @override
  void dispose() {
    _bgAnim.dispose();
    _gameAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _screenH = size.height;
    _screenW = size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF03000F),
      body: _gameOver ? _buildFinishScreen() : _buildGame(size),
    );
  }

  Widget _buildGame(Size size) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: _onTapDown,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Twinkling background
          AnimatedBuilder(
            animation: _bgAnim,
            builder: (_, __) => CustomPaint(
              painter: _BgStarPainter(_bgStars, _bgAnim.value),
              size: size,
            ),
          ),

          // Falling stars
          AnimatedBuilder(
            animation: _gameAnim,
            builder: (_, __) => CustomPaint(
              painter: _FallingStarPainter(_fallingStars, _timeSec),
              size: size,
            ),
          ),

          // Catch flashes
          AnimatedBuilder(
            animation: _gameAnim,
            builder: (_, __) => CustomPaint(
              painter: _FlashPainter(_flashes),
              size: size,
            ),
          ),

          // HUD
          SafeArea(child: _buildHUD()),
        ],
      ),
    );
  }

  Widget _buildHUD() {
    final pct = _secondsLeft / _gameDuration;
    final barW = _screenW - 40;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Close button
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:
                      const Icon(Icons.close, color: Colors.white70, size: 20),
                ),
              ),

              // Score
              Column(
                children: [
                  Text('score'.tr,
                      style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 11,
                          letterSpacing: 1.5)),
                  Text('$_score',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold)),
                ],
              ),

              // Caught count
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('caughtLabel'.tr,
                      style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 11,
                          letterSpacing: 1.2)),
                  Text('$_caught ⭐',
                      style: const TextStyle(
                          color: Colors.amber,
                          fontSize: 18,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Timer bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Stack(
              children: [
                Container(height: 6, color: Colors.white12),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 6,
                  width: barW * pct,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: pct > 0.4
                          ? [const Color(0xFF7C3AED), const Color(0xFF06B6D4)]
                          : [Colors.redAccent, Colors.orange],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 4),
          Text('secondsLeft'.trParams({'sec': '$_secondsLeft'}),
              style: const TextStyle(color: Colors.white54, fontSize: 12)),

          const SizedBox(height: 8),
          Text(
            'tapStars'.tr,
            style: const TextStyle(
                color: Colors.white38, fontSize: 12, letterSpacing: 0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildFinishScreen() {
    return _FinishedView(
      score: _score,
      caught: _caught,
      badgeUnlocked: _badgeUnlocked,
    );
  }
}

// ── Finish screen ─────────────────────────────────────────────────────────────

class _FinishedView extends StatelessWidget {
  const _FinishedView({
    required this.score,
    required this.caught,
    required this.badgeUnlocked,
  });

  final int score;
  final int caught;
  final bool badgeUnlocked;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topCenter,
          radius: 1.6,
          colors: [Color(0xFF1A0A3E), Color(0xFF03000F)],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('⭐', style: TextStyle(fontSize: 80)),
              const SizedBox(height: 20),
              Text(
                'starCatcherTitle'.tr,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                'gameOver'.tr,
                style:
                    TextStyle(color: Colors.white.withAlpha(150), fontSize: 16),
              ),
              const SizedBox(height: 40),
              _StatRow(
                  label: 'score'.tr,
                  value: '$score',
                  color: const Color(0xFF9D64F5)),
              const SizedBox(height: 12),
              _StatRow(
                  label: 'caughtStars'.tr,
                  value: '$caught ⭐',
                  color: Colors.amber),
              const SizedBox(height: 12),
              _StatRow(
                  label: 'targetScore'.tr,
                  value: 'threeHundredPoints'.tr,
                  color: score >= 300 ? Colors.greenAccent : Colors.white38),
              if (badgeUnlocked) ...[
                const SizedBox(height: 28),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.amber.withAlpha(30),
                    border: Border.all(color: Colors.amber.withAlpha(100)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('⭐', style: TextStyle(fontSize: 28)),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('badgeEarned'.tr,
                              style: const TextStyle(
                                  color: Colors.amber,
                                  fontWeight: FontWeight.bold)),
                          Text('starCatcherBadge'.tr,
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 48),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.white.withAlpha(80)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () => Get.back(),
                      child: Text('back'.tr,
                          style: const TextStyle(color: Colors.white70)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7C3AED),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () =>
                          Get.offAndToNamed(AppStrings.routeStarCatcher),
                      child: Text('again'.tr,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow(
      {required this.label, required this.value, required this.color});

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 15)),
          Text(value,
              style: TextStyle(
                  color: color, fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
