import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sleepy_ai/core/constants/app_constants.dart';
import 'package:sleepy_ai/features/rewards/cubit/rewards_cubit.dart';
import 'package:sleepy_ai/shared/models/app_models.dart';

// ── Bubble entity ─────────────────────────────────────────────────────────────

class _Bubble {
  _Bubble(math.Random rng, double w, double h)
      : x = rng.nextDouble() * w,
        y = h + rng.nextDouble() * h * 0.5,
        radius = 14.0 + rng.nextDouble() * 22,
        speed = 22 + rng.nextDouble() * 35,
        hue = rng.nextDouble() * 360,
        wobble = rng.nextDouble() * math.pi * 2,
        wobbleSpeed = 0.6 + rng.nextDouble() * 1.0;

  double x, y;
  final double radius, speed, hue, wobble, wobbleSpeed;
  double age = 0; // 0→1

  Color get color => HSVColor.fromAHSV(0.55, hue, 0.6, 0.95).toColor();
  Color get shimmer =>
      HSVColor.fromAHSV(0.85, (hue + 40) % 360, 0.3, 1).toColor();
}

// ── Pop burst ─────────────────────────────────────────────────────────────────

class _PopBurst {
  _PopBurst(this.x, this.y, this.color) : age = 0;
  final double x, y;
  final Color color;
  double age;
}

// ── Bubble painter ────────────────────────────────────────────────────────────

class _BubblePainter extends CustomPainter {
  _BubblePainter(this.bubbles, this.t) : super(repaint: null);
  final List<_Bubble> bubbles;
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    for (final b in bubbles) {
      final cx = b.x + math.sin(t * b.wobbleSpeed * math.pi * 2 + b.wobble) * 6;
      final cy = b.y;
      final r = b.radius;

      // Soft glow halo
      canvas.drawCircle(
        Offset(cx, cy),
        r * 1.6,
        Paint()
          ..color = b.color.withAlpha(22)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14),
      );

      // Bubble body (translucent)
      canvas.drawCircle(
        Offset(cx, cy),
        r,
        Paint()
          ..color = b.color.withAlpha(75)
          ..style = PaintingStyle.fill,
      );

      // Bubble rim
      canvas.drawCircle(
        Offset(cx, cy),
        r,
        Paint()
          ..color = b.shimmer.withAlpha(160)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2,
      );

      // Shimmer highlight top-left
      final hlX = cx - r * 0.28;
      final hlY = cy - r * 0.32;
      canvas.drawCircle(
        Offset(hlX, hlY),
        r * 0.22,
        Paint()..color = Colors.white.withAlpha(130),
      );
    }
  }

  @override
  bool shouldRepaint(_BubblePainter old) => true;
}

// ── Pop burst painter ─────────────────────────────────────────────────────────

class _BurstPainter extends CustomPainter {
  _BurstPainter(this.bursts) : super(repaint: null);
  final List<_PopBurst> bursts;

  @override
  void paint(Canvas canvas, Size size) {
    for (final b in bursts) {
      final expand = b.age * 50;
      final alpha = ((1 - b.age) * 180).round().clamp(0, 255);
      canvas.drawCircle(
        Offset(b.x, b.y),
        expand,
        Paint()
          ..color = b.color.withAlpha(alpha)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8 + expand * 0.3),
      );
      // Tiny dots radiating
      final paint = Paint()..color = b.color.withAlpha((alpha * 0.7).round());
      for (int i = 0; i < 8; i++) {
        final a = i * math.pi / 4;
        final dist = expand * 0.8;
        canvas.drawCircle(
          Offset(b.x + math.cos(a) * dist, b.y + math.sin(a) * dist),
          3.0 * (1 - b.age),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_BurstPainter old) => true;
}

// ── Starfield background ──────────────────────────────────────────────────────

class _BgDot {
  _BgDot(int seed) {
    final r = math.Random(seed);
    x = r.nextDouble();
    y = r.nextDouble();
    radius = 0.3 + r.nextDouble() * 1.0;
    opacity = 0.1 + r.nextDouble() * 0.35;
    phase = r.nextDouble() * math.pi * 2;
  }
  late final double x, y, radius, opacity, phase;
}

class _BgDotPainter extends CustomPainter {
  _BgDotPainter(this.dots, this.t) : super(repaint: null);
  final List<_BgDot> dots;
  final double t;
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint();
    for (final d in dots) {
      final tw = 0.4 + 0.6 * ((math.sin(t * math.pi * 2 + d.phase) + 1) / 2);
      p.color = Colors.white.withAlpha((d.opacity * tw * 160).round());
      canvas.drawCircle(
          Offset(d.x * size.width, d.y * size.height), d.radius, p);
    }
  }

  @override
  bool shouldRepaint(_BgDotPainter old) => old.t != t;
}

// ── Page ──────────────────────────────────────────────────────────────────────

class BubblePopPage extends StatefulWidget {
  const BubblePopPage({super.key});

  @override
  State<BubblePopPage> createState() => _BubblePopPageState();
}

class _BubblePopPageState extends State<BubblePopPage>
    with TickerProviderStateMixin {
  static const int _gameDuration = 180; // 3 minutes
  static const int _maxBubbles = 12;
  static const int _badgeThreshold = 50;
  static const double _dt = 1 / 60;

  late final AnimationController _bgAnim;
  late final AnimationController _gameAnim;

  final _rng = math.Random();
  final List<_BgDot> _bgDots = List.generate(100, (i) => _BgDot(i + 200));
  final List<_Bubble> _bubbles = [];
  final List<_PopBurst> _bursts = [];

  int _popped = 0;
  int _secondsLeft = _gameDuration;
  bool _gameOver = false;
  bool _badgeUnlocked = false;
  double _timeSec = 0;
  double _screenW = 400;
  double _screenH = 800;

  @override
  void initState() {
    super.initState();
    _bgAnim =
        AnimationController(vsync: this, duration: const Duration(seconds: 6))
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

    // Move bubbles up with wobble
    for (final b in _bubbles) {
      b.y -= b.speed * _dt;
      b.age += _dt * 0.08;
    }
    _bubbles.removeWhere((b) => b.y < -b.radius * 2);

    // Spawn to maintain count
    while (_bubbles.length < _maxBubbles) {
      _bubbles.add(_Bubble(_rng, _screenW, _screenH));
    }

    // Age bursts
    for (final b in _bursts) {
      b.age += _dt * 2.0;
    }
    _bursts.removeWhere((b) => b.age >= 1);

    setState(() {});
  }

  void _endGame() {
    _gameAnim.stop();
    _gameOver = true;

    final cubit = context.read<RewardsCubit>();
    cubit.recordGameScore(GameScoreRecord(
      gameId: 'bubble_pop',
      score: _popped * 5,
      timestamp: DateTime.now(),
    ));

    if (_popped >= _badgeThreshold) {
      _badgeUnlocked = true;
      cubit.unlockBadge(BadgeType.bubblePopper);
    }

    setState(() {});
  }

  void _onTapDown(TapDownDetails details) {
    if (_gameOver) return;
    final tap = details.localPosition;
    for (int i = _bubbles.length - 1; i >= 0; i--) {
      final b = _bubbles[i];
      final cx =
          b.x + math.sin(_timeSec * b.wobbleSpeed * math.pi * 2 + b.wobble) * 6;
      if ((Offset(cx, b.y) - tap).distance <= b.radius + 18) {
        _bursts.add(_PopBurst(cx, b.y, b.color));
        _bubbles.removeAt(i);
        _popped++;
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
    _screenW = size.width;
    _screenH = size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF030010),
      body: _gameOver ? _buildFinish() : _buildGame(size),
    );
  }

  Widget _buildGame(Size size) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: _onTapDown,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Starfield
          AnimatedBuilder(
            animation: _bgAnim,
            builder: (_, __) => CustomPaint(
              painter: _BgDotPainter(_bgDots, _bgAnim.value),
              size: size,
            ),
          ),

          // Bubbles
          AnimatedBuilder(
            animation: _gameAnim,
            builder: (_, __) => CustomPaint(
              painter: _BubblePainter(_bubbles, _timeSec),
              size: size,
            ),
          ),

          // Pop bursts
          AnimatedBuilder(
            animation: _gameAnim,
            builder: (_, __) => CustomPaint(
              painter: _BurstPainter(_bursts),
              size: size,
            ),
          ),

          // HUD
          SafeArea(child: _buildHUD(size.width)),
        ],
      ),
    );
  }

  Widget _buildHUD(double w) {
    final pct = _secondsLeft / _gameDuration;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(20),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:
                      const Icon(Icons.close, color: Colors.white60, size: 20),
                ),
              ),
              Column(
                children: [
                  Text('balloonCountLabel'.tr,
                      style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 11,
                          letterSpacing: 1.5)),
                  Text('$_popped 🫧',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('goalLabel'.tr,
                      style:
                          const TextStyle(color: Colors.white38, fontSize: 11)),
                  Text('$_badgeThreshold 🏅',
                      style: TextStyle(
                          color: _popped >= _badgeThreshold
                              ? Colors.greenAccent
                              : Colors.white54,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Stack(
              children: [
                Container(height: 5, color: Colors.white10),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 5,
                  width: (w - 40) * pct,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF9D64F5), Color(0xFF06B6D4)],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text('secondsLeft'.trParams({'sec': '$_secondsLeft'}),
              style: const TextStyle(color: Colors.white38, fontSize: 12)),
          const SizedBox(height: 6),
          Text('tapBubbles'.tr,
              style: const TextStyle(color: Colors.white30, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildFinish() {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topCenter,
          radius: 1.5,
          colors: [Color(0xFF1A003A), Color(0xFF030010)],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🫧', style: TextStyle(fontSize: 80)),
              const SizedBox(height: 20),
              Text('balloonGardenTitle'.tr,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text('sessionOver'.tr,
                  style: TextStyle(
                      color: Colors.white.withAlpha(150), fontSize: 16)),
              const SizedBox(height: 36),
              _Stat(
                  label: 'poppedBalloons'.tr,
                  value: '$_popped 🫧',
                  color: const Color(0xFF9D64F5)),
              const SizedBox(height: 12),
              _Stat(
                  label: 'score'.tr,
                  value: '${_popped * 5}',
                  color: Colors.amber),
              const SizedBox(height: 12),
              _Stat(
                  label: 'badgeThreshold'.tr,
                  value: 'fiftyBalloons'.tr,
                  color: _popped >= 50 ? Colors.greenAccent : Colors.white38),
              if (_badgeUnlocked) ...[
                const SizedBox(height: 24),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.purple.withAlpha(35),
                    border: Border.all(color: Colors.purple.withAlpha(100)),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('🫧', style: TextStyle(fontSize: 28)),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('badgeEarned'.tr,
                              style: const TextStyle(
                                  color: Colors.purpleAccent,
                                  fontWeight: FontWeight.bold)),
                          Text('balloonPopper'.tr,
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.white.withAlpha(70)),
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
                          Get.offAndToNamed(AppStrings.routeBubblePop),
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

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value, required this.color});
  final String label;
  final String value;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(10),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 15)),
          Text(value,
              style: TextStyle(
                  color: color, fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
