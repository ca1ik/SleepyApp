import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sleepy_ai/core/constants/app_constants.dart';
import 'package:sleepy_ai/features/rewards/cubit/rewards_cubit.dart';
import 'package:sleepy_ai/shared/models/app_models.dart';

// ── Sheep ─────────────────────────────────────────────────────────────────────

class _Sheep {
  _Sheep(math.Random rng, double w, double h)
      : x = w + rng.nextDouble() * w * 0.6,
        lane = 0.45 + rng.nextDouble() * 0.25,
        speed = 28 + rng.nextDouble() * 22,
        size = 1.0 + rng.nextDouble() * 0.4,
        counted = false,
        bouncePhase = rng.nextDouble() * math.pi * 2;
  double x;
  final double lane, speed, size, bouncePhase;
  bool counted;
}

// ── Sheep painter ─────────────────────────────────────────────────────────────

class _SheepPainter extends CustomPainter {
  _SheepPainter(this.sheep, this.t) : super(repaint: null);
  final List<_Sheep> sheep;
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    for (final s in sheep) {
      final cx = s.x;
      final bounce = math.sin(t * 4.5 + s.bouncePhase) * 3 * s.size;
      final cy = size.height * s.lane + bounce;
      final sc = s.size * 22.0; // base body radius

      // Body (fluffy cloud shape using overlapping circles)
      final bodyPaint = Paint()..color = const Color(0xFFF0EEF8);
      canvas.drawCircle(Offset(cx, cy), sc, bodyPaint);
      canvas.drawCircle(
          Offset(cx - sc * 0.6, cy + sc * 0.15), sc * 0.7, bodyPaint);
      canvas.drawCircle(
          Offset(cx + sc * 0.6, cy + sc * 0.15), sc * 0.7, bodyPaint);
      canvas.drawCircle(
          Offset(cx - sc * 0.3, cy - sc * 0.5), sc * 0.65, bodyPaint);
      canvas.drawCircle(
          Offset(cx + sc * 0.3, cy - sc * 0.5), sc * 0.65, bodyPaint);

      // Head
      final headCx = cx + sc * 0.9;
      final headCy = cy - sc * 0.3;
      final headR = sc * 0.42;
      canvas.drawCircle(
        Offset(headCx, headCy),
        headR,
        Paint()..color = const Color(0xFF3E3650),
      );

      // Eyes (tiny whites)
      canvas.drawCircle(
        Offset(headCx + headR * 0.3, headCy - headR * 0.2),
        headR * 0.2,
        Paint()..color = Colors.white,
      );
      canvas.drawCircle(
        Offset(headCx + headR * 0.3, headCy - headR * 0.2),
        headR * 0.1,
        Paint()..color = Colors.black,
      );

      // Legs
      final legPaint = Paint()
        ..color = const Color(0xFF3E3650)
        ..strokeWidth = sc * 0.2
        ..strokeCap = StrokeCap.round;
      // Walk cycle
      final legAngle = math.sin(t * 6 + s.bouncePhase) * 0.3;
      final legY = cy + sc * 0.8;
      canvas.drawLine(
        Offset(cx - sc * 0.35, cy + sc * 0.5),
        Offset(cx - sc * 0.35 + math.sin(legAngle) * sc * 0.3,
            legY + math.cos(legAngle) * sc * 0.3),
        legPaint,
      );
      canvas.drawLine(
        Offset(cx + sc * 0.35, cy + sc * 0.5),
        Offset(cx + sc * 0.35 - math.sin(legAngle) * sc * 0.3,
            legY + math.cos(legAngle) * sc * 0.3),
        legPaint,
      );

      // "ZZZ" if counted (sleepy vibe)
      if (s.counted) {
        const style = TextStyle(
            color: Color(0xFFB8A9D9),
            fontSize: 13,
            fontWeight: FontWeight.w300);
        final tp = TextPainter(
          text: const TextSpan(text: 'zzz', style: style),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, Offset(headCx, headCy - headR * 1.8));
      }
    }
  }

  @override
  bool shouldRepaint(_SheepPainter old) => true;
}

// ── Background: night sky with moon ──────────────────────────────────────────

class _NightSkyPainter extends CustomPainter {
  _NightSkyPainter(this.stars, this.t) : super(repaint: null);
  final List<_Star> stars;
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    // Soft rolling hills
    final hillPaint = Paint()..color = const Color(0xFF120A25);
    final hill = Path();
    hill.moveTo(0, size.height * 0.55);
    for (double x = 0; x <= size.width; x += 8) {
      final y = size.height * 0.55 +
          math.sin(x / size.width * math.pi * 2.5 + 0.5) * size.height * 0.07;
      hill.lineTo(x, y);
    }
    hill.lineTo(size.width, size.height);
    hill.lineTo(0, size.height);
    hill.close();
    canvas.drawPath(hill, hillPaint);

    // A second hill further back
    final hillPaint2 = Paint()..color = const Color(0xFF0F0820);
    final hill2 = Path();
    hill2.moveTo(0, size.height * 0.48);
    for (double x = 0; x <= size.width; x += 8) {
      final y = size.height * 0.48 +
          math.sin(x / size.width * math.pi * 3.2 + 1.0) * size.height * 0.05;
      hill2.lineTo(x, y);
    }
    hill2.lineTo(size.width, size.height * 0.52);
    hill2.lineTo(0, size.height * 0.52);
    hill2.close();
    canvas.drawPath(hill2, hillPaint2);

    // Fence
    final fencePaint = Paint()
      ..color = Colors.white.withAlpha(50)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    final fenceY = size.height * 0.52;
    canvas.drawLine(Offset(0, fenceY), Offset(size.width, fenceY), fencePaint);
    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(
          Offset(x + 20, fenceY - 14), Offset(x + 20, fenceY + 6), fencePaint);
    }

    // Stars
    final sp = Paint();
    for (final s in stars) {
      final tw = 0.4 + 0.6 * ((math.sin(t * math.pi * 2 + s.phase) + 1) / 2);
      sp.color = Colors.white.withAlpha((s.opacity * tw * 170).round());
      canvas.drawCircle(
          Offset(s.x * size.width, s.y * size.height * 0.5), s.r, sp);
    }

    // Moon
    canvas.drawCircle(
      Offset(size.width * 0.82, size.height * 0.13),
      28,
      Paint()..color = const Color(0xFFFFF3B8),
    );
    // Moon crescent shadow
    canvas.drawCircle(
      Offset(size.width * 0.82 + 10, size.height * 0.13 - 4),
      22,
      Paint()..color = const Color(0xFF0A0520),
    );
  }

  @override
  bool shouldRepaint(_NightSkyPainter old) => old.t != t;
}

class _Star {
  _Star(int seed) {
    final r = math.Random(seed);
    x = r.nextDouble();
    y = r.nextDouble();
    r2 = 0.4 + r.nextDouble() * 1.2;
    opacity = 0.1 + r.nextDouble() * 0.6;
    phase = r.nextDouble() * math.pi * 2;
  }
  late final double x, y, r2, opacity, phase;
  double get r => r2;
}

// ── Page ──────────────────────────────────────────────────────────────────────

class SheepCounterPage extends StatefulWidget {
  const SheepCounterPage({super.key});

  @override
  State<SheepCounterPage> createState() => _SheepCounterPageState();
}

class _SheepCounterPageState extends State<SheepCounterPage>
    with TickerProviderStateMixin {
  static const int _gameDuration = 180;
  static const int _badgeThreshold = 30;
  static const double _dt = 1 / 60;
  static const double _fencePct = 0.52;

  late final AnimationController _bgAnim;
  late final AnimationController _gameAnim;

  final _rng = math.Random();
  final List<_Star> _stars = List.generate(80, (i) => _Star(i + 500));
  final List<_Sheep> _sheep = [];

  int _counted = 0;
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
        AnimationController(vsync: this, duration: const Duration(seconds: 8))
          ..repeat();
    _gameAnim =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat();
    _gameAnim.addListener(_tick);
    // Pre-spawn a couple
    for (int i = 0; i < 3; i++) {
      final s = _Sheep(_rng, _screenW, _screenH);
      s.x -= i * (_screenW * 0.35);
      _sheep.add(s);
    }
  }

  void _tick() {
    if (_gameOver) return;
    _timeSec += _dt;

    final elapsed = (_gameDuration - _timeSec).ceil().clamp(0, _gameDuration);
    if (elapsed != _secondsLeft) {
      _secondsLeft = elapsed;
      if (_secondsLeft <= 0) {
        _endGame();
        return;
      }
    }

    final fenceX = _screenW * 0.35;

    for (final s in _sheep) {
      s.x -= s.speed * _dt;
      // Count when crossing the fence line (moving left past fenceX)
      if (!s.counted && s.x < fenceX) {
        s.counted = true;
        _counted++;
      }
    }
    _sheep.removeWhere((s) => s.x < -60);

    // Spawn new sheep
    if (_sheep.isEmpty ||
        (_sheep.last.x < _screenW * 0.85 && _sheep.length < 5)) {
      _sheep.add(_Sheep(_rng, _screenW, _screenH));
    }

    setState(() {});
  }

  void _endGame() {
    _gameAnim.stop();
    _gameOver = true;

    final cubit = context.read<RewardsCubit>();
    cubit.recordGameScore(GameScoreRecord(
      gameId: 'sheep_counter',
      score: _counted * 10,
      timestamp: DateTime.now(),
    ));

    if (_counted >= _badgeThreshold) {
      _badgeUnlocked = true;
      cubit.unlockBadge(BadgeType.sleepySheep);
    }

    setState(() {});
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
      backgroundColor: const Color(0xFF040012),
      body: _gameOver ? _buildFinish() : _buildGame(size),
    );
  }

  Widget _buildGame(Size size) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Night sky with hills
        AnimatedBuilder(
          animation: _bgAnim,
          builder: (_, __) => CustomPaint(
            painter: _NightSkyPainter(_stars, _bgAnim.value),
            size: size,
          ),
        ),

        // Sheep
        AnimatedBuilder(
          animation: _gameAnim,
          builder: (_, __) => CustomPaint(
            painter: _SheepPainter(_sheep, _timeSec),
            size: size,
          ),
        ),

        // HUD
        SafeArea(child: _buildHUD()),

        // Big counter in centre-bottom
        Positioned(
          bottom: _screenH * (1 - _fencePct) + 30,
          left: 0,
          right: 0,
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, anim) =>
                  ScaleTransition(scale: anim, child: child),
              child: Text(
                '$_counted',
                key: ValueKey(_counted),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 72,
                  fontWeight: FontWeight.w200,
                  shadows: [
                    Shadow(color: Color(0xFF9D64F5), blurRadius: 20),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Subtitle
        Positioned(
          bottom: _screenH * (1 - _fencePct) + 4,
          left: 0,
          right: 0,
          child: Center(
            child: Text('koyun sayıldı 🐑',
                style:
                    TextStyle(color: Colors.white.withAlpha(80), fontSize: 13)),
          ),
        ),
      ],
    );
  }

  Widget _buildHUD() {
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
                    color: Colors.white.withAlpha(18),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:
                      const Icon(Icons.close, color: Colors.white60, size: 20),
                ),
              ),
              const Text('Koyun Sayma',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
              Text('$_secondsLeft sn',
                  style: const TextStyle(color: Colors.white54, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Stack(
              children: [
                Container(height: 4, color: Colors.white10),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 4,
                  width: (MediaQuery.of(context).size.width - 40) * pct,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF7C3AED), Color(0xFF9D64F5)],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _counted < _badgeThreshold
                ? '${_badgeThreshold - _counted} koyun daha say →  🏅'
                : 'Rozet için yeterli! 🎉',
            style: TextStyle(
                color: _counted >= _badgeThreshold
                    ? Colors.greenAccent.withAlpha(200)
                    : Colors.white30,
                fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildFinish() {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topCenter,
          radius: 1.4,
          colors: [Color(0xFF120A25), Color(0xFF040012)],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🐑', style: TextStyle(fontSize: 80)),
              const SizedBox(height: 16),
              const Text('Koyun Sayma',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text('Uyku vakti… 💤',
                  style: TextStyle(
                      color: Colors.white.withAlpha(150), fontSize: 16)),
              const SizedBox(height: 36),
              _SheepStat(
                  label: 'Sayılan Koyun',
                  value: '$_counted 🐑',
                  color: const Color(0xFF9D64F5)),
              const SizedBox(height: 12),
              _SheepStat(
                  label: 'Puan',
                  value: '${_counted * 10}',
                  color: Colors.amber),
              const SizedBox(height: 12),
              _SheepStat(
                  label: 'Rozet Eşiği',
                  value: '30 koyun',
                  color: _counted >= 30 ? Colors.greenAccent : Colors.white38),
              if (_badgeUnlocked) ...[
                const SizedBox(height: 24),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.indigo.withAlpha(35),
                    border: Border.all(color: Colors.indigo.withAlpha(110)),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('🐑', style: TextStyle(fontSize: 28)),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Rozet Kazanıldı!',
                              style: TextStyle(
                                  color: Colors.indigoAccent,
                                  fontWeight: FontWeight.bold)),
                          Text('Uykulu Koyun',
                              style: TextStyle(
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
                      child: const Text('Geri',
                          style: TextStyle(color: Colors.white70)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B0764),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () =>
                          Get.offAndToNamed(AppStrings.routeSheepCounter),
                      child: const Text('Tekrar',
                          style: TextStyle(
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

class _SheepStat extends StatelessWidget {
  const _SheepStat(
      {required this.label, required this.value, required this.color});
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
