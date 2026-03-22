import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sleepy_ai/core/constants/app_colors.dart';
import 'package:sleepy_ai/shared/widgets/galaxy_background.dart';

/// Moon Runner – Endless runner on the lunar surface.
/// Dodge craters, collect stars, survive as long as possible.
class MoonRunnerPage extends StatefulWidget {
  const MoonRunnerPage({super.key});

  @override
  State<MoonRunnerPage> createState() => _MoonRunnerPageState();
}

class _MoonRunnerPageState extends State<MoonRunnerPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _gameLoop;
  static const int _lanes = 3;
  int _currentLane = 1; // 0=left, 1=center, 2=right
  double _distance = 0;
  int _score = 0;
  bool _isPlaying = false;
  bool _gameOver = false;
  final List<_Obstacle> _obstacles = [];
  final List<_StarCollectible> _stars = [];
  final math.Random _rng = math.Random();
  double _lastSpawnDistance = 0;
  double _speed = 200; // px/sec

  @override
  void initState() {
    super.initState();
    _gameLoop = AnimationController(
      vsync: this,
      duration: const Duration(days: 1), // infinite
    );
    _gameLoop.addListener(_tick);
  }

  DateTime _lastTick = DateTime.now();

  void _tick() {
    if (!_isPlaying || _gameOver) return;
    final now = DateTime.now();
    final dt =
        (now.difference(_lastTick).inMicroseconds / 1000000).clamp(0, 0.05);
    _lastTick = now;

    setState(() {
      _distance += _speed * dt;
      _speed = 200 + _distance * 0.015; // accelerate

      // Spawn obstacles
      if (_distance - _lastSpawnDistance > 120) {
        _lastSpawnDistance = _distance;
        final lane = _rng.nextInt(_lanes);
        _obstacles.add(_Obstacle(lane: lane, y: -60));

        // Star in different lane
        final starLane = (lane + 1 + _rng.nextInt(2)) % _lanes;
        if (_rng.nextDouble() < 0.6) {
          _stars.add(_StarCollectible(lane: starLane, y: -60));
        }
      }

      // Move obstacles down
      for (final o in _obstacles) {
        o.y += _speed * dt;
      }
      for (final s in _stars) {
        s.y += _speed * dt;
      }

      // Collision check
      for (final o in _obstacles) {
        if (o.lane == _currentLane && o.y > 500 && o.y < 580) {
          _gameOver = true;
          _isPlaying = false;
          _gameLoop.stop();
        }
      }

      // Star collection
      _stars.removeWhere((s) {
        if (s.lane == _currentLane && s.y > 500 && s.y < 580 && !s.collected) {
          s.collected = true;
          _score += 10;
          return false;
        }
        return s.y > 800;
      });

      // Remove off-screen obstacles
      _obstacles.removeWhere((o) => o.y > 800);
    });
  }

  void _startGame() {
    setState(() {
      _isPlaying = true;
      _gameOver = false;
      _currentLane = 1;
      _distance = 0;
      _score = 0;
      _speed = 200;
      _obstacles.clear();
      _stars.clear();
      _lastSpawnDistance = 0;
      _lastTick = DateTime.now();
    });
    _gameLoop.repeat();
  }

  void _swipe(DragEndDetails details) {
    if (!_isPlaying || _gameOver) return;
    final dx = details.velocity.pixelsPerSecond.dx;
    setState(() {
      if (dx < -100 && _currentLane > 0) _currentLane--;
      if (dx > 100 && _currentLane < _lanes - 1) _currentLane++;
    });
  }

  @override
  void dispose() {
    _gameLoop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final laneWidth = size.width / _lanes;

    return Scaffold(
      backgroundColor: AppColors.galaxyDeep,
      body: GalaxyBackground(
        starCount: 100,
        nebulaCount: 2,
        showShootingStars: false,
        child: GestureDetector(
          onHorizontalDragEnd: _swipe,
          onTapDown: (d) {
            if (!_isPlaying && !_gameOver) return;
            final tapX = d.localPosition.dx;
            final lane = (tapX / laneWidth).floor().clamp(0, _lanes - 1);
            setState(() => _currentLane = lane);
          },
          child: SafeArea(
            child: Stack(
              children: [
                // Game canvas
                CustomPaint(
                  painter: _MoonRunnerPainter(
                    lanes: _lanes,
                    currentLane: _currentLane,
                    obstacles: _obstacles,
                    stars: _stars,
                    laneWidth: laneWidth,
                    distance: _distance,
                  ),
                  size: size,
                ),

                // HUD
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.arrow_back_ios_rounded,
                            color: AppColors.textPrimary),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundCard.withAlpha(180),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star_rounded,
                                color: AppColors.accentGold, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              '$_score',
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Start / Game Over overlay
                if (!_isPlaying)
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundCard.withAlpha(220),
                        borderRadius: BorderRadius.circular(24),
                        border:
                            Border.all(color: AppColors.primary.withAlpha(60)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _gameOver ? 'game_over'.tr : 'game_moon_runner'.tr,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          if (_gameOver) ...[
                            const SizedBox(height: 8),
                            Text(
                              '${'score'.tr}: $_score',
                              style: const TextStyle(
                                color: AppColors.accent,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: _startGame,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 14),
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                _gameOver ? 'play_again'.tr : 'start'.tr,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
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
      ),
    );
  }
}

class _Obstacle {
  _Obstacle({required this.lane, required this.y});
  final int lane;
  double y;
}

class _StarCollectible {
  _StarCollectible({required this.lane, required this.y});
  final int lane;
  double y;
  bool collected = false;
}

class _MoonRunnerPainter extends CustomPainter {
  _MoonRunnerPainter({
    required this.lanes,
    required this.currentLane,
    required this.obstacles,
    required this.stars,
    required this.laneWidth,
    required this.distance,
  });

  final int lanes, currentLane;
  final List<_Obstacle> obstacles;
  final List<_StarCollectible> stars;
  final double laneWidth, distance;

  @override
  void paint(Canvas canvas, Size size) {
    // Lane dividers
    final linePaint = Paint()
      ..color = AppColors.border.withAlpha(40)
      ..strokeWidth = 1;
    for (int i = 1; i < lanes; i++) {
      final x = i * laneWidth;
      // Dashed line effect
      for (double y = (distance % 40); y < size.height; y += 40) {
        canvas.drawLine(Offset(x, y), Offset(x, y + 20), linePaint);
      }
    }

    // Player
    final px = currentLane * laneWidth + laneWidth / 2;
    const py = 540.0;
    final playerGlow = Paint()
      ..color = AppColors.primary.withAlpha(50)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
    canvas.drawCircle(Offset(px, py), 28, playerGlow);

    final playerPaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFF9D64F5), Color(0xFF7C3AED)],
      ).createShader(Rect.fromCircle(center: Offset(px, py), radius: 20));
    canvas.drawCircle(Offset(px, py), 20, playerPaint);
    canvas.drawCircle(
      Offset(px, py),
      6,
      Paint()..color = Colors.white.withAlpha(180),
    );

    // Obstacles (craters)
    for (final o in obstacles) {
      final ox = o.lane * laneWidth + laneWidth / 2;
      final oy = o.y;
      // Crater glow
      final craterGlow = Paint()
        ..color = AppColors.error.withAlpha(40)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(Offset(ox, oy), 22, craterGlow);

      final craterPaint = Paint()..color = AppColors.error.withAlpha(150);
      canvas.drawCircle(Offset(ox, oy), 16, craterPaint);

      final innerPaint = Paint()..color = AppColors.error.withAlpha(80);
      canvas.drawCircle(Offset(ox, oy), 8, innerPaint);
    }

    // Stars
    for (final s in stars) {
      if (s.collected) continue;
      final sx = s.lane * laneWidth + laneWidth / 2;
      final sy = s.y;
      final starGlow = Paint()
        ..color = AppColors.accentGold.withAlpha(50)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(Offset(sx, sy), 16, starGlow);

      final starPaint = Paint()..color = AppColors.accentGold;
      _drawStar(canvas, Offset(sx, sy), 10, 5, 5, starPaint);
    }
  }

  void _drawStar(Canvas canvas, Offset center, double outerR, double innerR,
      int points, Paint paint) {
    final path = Path();
    for (int i = 0; i < points * 2; i++) {
      final r = i.isEven ? outerR : innerR;
      final angle = (i * math.pi / points) - math.pi / 2;
      final p = Offset(
        center.dx + r * math.cos(angle),
        center.dy + r * math.sin(angle),
      );
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_MoonRunnerPainter old) => true;
}
