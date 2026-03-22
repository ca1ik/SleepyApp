import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sleepy_ai/core/constants/app_colors.dart';
import 'package:sleepy_ai/shared/widgets/galaxy_background.dart';
import 'package:sleepy_ai/shared/widgets/cosmic_particles.dart';

/// Cosmic Flow – A relaxing rhythm game where cosmic energy pulses
/// flow toward the center. Tap nodes in sync with the rhythm to
/// build a sleep-inducing energy chain. Progressively slower = sleepier.
class CosmicFlowPage extends StatefulWidget {
  const CosmicFlowPage({super.key});

  @override
  State<CosmicFlowPage> createState() => _CosmicFlowPageState();
}

class _CosmicFlowPageState extends State<CosmicFlowPage>
    with TickerProviderStateMixin {
  late final AnimationController _ringCtrl;
  late final AnimationController _pulseCtrl;

  // Game state
  bool _isPlaying = false;
  int _score = 0;
  int _streak = 0;
  int _maxStreak = 0;
  int _level = 1;
  double _bpm = 80; // Beats per minute, slows down over time (sleep-inducing)
  final List<_FlowNode> _nodes = [];
  final math.Random _rng = math.Random();
  static const int _nodeCount = 8; // positions around circle
  DateTime _lastBeat = DateTime.now();

  @override
  void initState() {
    super.initState();
    _ringCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _ringCtrl.addListener(_gameTick);
  }

  void _gameTick() {
    if (!_isPlaying) return;

    final now = DateTime.now();
    final beatInterval = Duration(milliseconds: (60000 / _bpm).round());

    if (now.difference(_lastBeat) >= beatInterval) {
      _lastBeat = now;
      _spawnNode();

      // Gradually slow down (sleep-inducing mechanic)
      if (_bpm > 40) {
        _bpm -= 0.3;
      }

      // Level up every 10 successful taps
      if (_score > 0 && _score % 10 == 0) {
        _level = (_score ~/ 10) + 1;
      }
    }

    // Age out nodes
    setState(() {
      _nodes.removeWhere((n) {
        if (n.age > 1.0 && !n.tapped) {
          _streak = 0;
          return true;
        }
        n.age += 0.008;
        return false;
      });
    });
  }

  void _spawnNode() {
    final position = _rng.nextInt(_nodeCount);
    // Avoid stacking on same position
    if (_nodes.any((n) => n.position == position && !n.tapped)) return;

    _nodes.add(_FlowNode(
      position: position,
      hue: 240 + _rng.nextDouble() * 80, // purple-pink range
      size: 30 + _rng.nextDouble() * 20,
    ));
  }

  void _onNodeTap(int nodeIndex) {
    if (!_isPlaying) return;
    final node = _nodes[nodeIndex];
    if (node.tapped) return;

    setState(() {
      node.tapped = true;
      _score++;
      _streak++;
      if (_streak > _maxStreak) _maxStreak = _streak;

      // Remove after animation
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() => _nodes.remove(node));
        }
      });
    });
  }

  void _startGame() {
    setState(() {
      _isPlaying = true;
      _score = 0;
      _streak = 0;
      _maxStreak = 0;
      _level = 1;
      _bpm = 80;
      _nodes.clear();
      _lastBeat = DateTime.now();
    });
  }

  @override
  void dispose() {
    _ringCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final radius = size.width * 0.35;

    return Scaffold(
      backgroundColor: AppColors.galaxyDeep,
      body: GalaxyBackground(
        starCount: 160,
        nebulaCount: 4,
        child: Stack(
          children: [
            const CosmicParticleOverlay(
              particleCount: 40,
              baseColor: Color(0xFF7C3AED),
              secondaryColor: Color(0xFFEC4899),
              speed: 0.4,
            ),
            SafeArea(
              child: Column(
                children: [
                  _buildAppBar(),
                  _buildHud(),
                  Expanded(
                    child: Center(
                      child: SizedBox(
                        width: radius * 2.5,
                        height: radius * 2.5,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Center cosmic orb
                            AnimatedBuilder(
                              animation: _pulseCtrl,
                              builder: (_, __) => Container(
                                width: 80 + _pulseCtrl.value * 20,
                                height: 80 + _pulseCtrl.value * 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      AppColors.primary.withAlpha(120),
                                      AppColors.cosmicPink.withAlpha(40),
                                      Colors.transparent,
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withAlpha(40),
                                      blurRadius: 30,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    '$_score',
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Outer ring
                            AnimatedBuilder(
                              animation: _ringCtrl,
                              builder: (_, __) => CustomPaint(
                                painter: _RingPainter(
                                  time: _ringCtrl.value,
                                  nodeCount: _nodeCount,
                                  radius: radius,
                                ),
                                size: Size(radius * 2.5, radius * 2.5),
                              ),
                            ),

                            // Active nodes
                            ..._nodes.asMap().entries.map((e) {
                              final i = e.key;
                              final node = e.value;
                              final angle =
                                  (node.position / _nodeCount) * math.pi * 2 -
                                      math.pi / 2;
                              final nx = math.cos(angle) * radius;
                              final ny = math.sin(angle) * radius;

                              return Positioned(
                                left: radius * 1.25 + nx - node.size / 2,
                                top: radius * 1.25 + ny - node.size / 2,
                                child: GestureDetector(
                                  onTap: () => _onNodeTap(i),
                                  child: AnimatedOpacity(
                                    duration: const Duration(milliseconds: 200),
                                    opacity: node.tapped
                                        ? 0.0
                                        : (1.0 - node.age).clamp(0.3, 1.0),
                                    child: Container(
                                      width: node.size,
                                      height: node.size,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: RadialGradient(
                                          colors: [
                                            HSVColor.fromAHSV(
                                                    0.9, node.hue, 0.7, 1.0)
                                                .toColor(),
                                            HSVColor.fromAHSV(
                                                    0.4, node.hue, 0.5, 0.8)
                                                .toColor(),
                                          ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: HSVColor.fromAHSV(
                                                    0.3, node.hue, 0.8, 1.0)
                                                .toColor(),
                                            blurRadius: 12,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (!_isPlaying)
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: GestureDetector(
                        onTap: _startGame,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            'start'.tr,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios_rounded,
                color: AppColors.textPrimary),
          ),
          Expanded(
            child: Text(
              'game_cosmic_flow'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildHud() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _FlowStat(
              label: 'streak'.tr,
              value: '$_streak',
              icon: Icons.local_fire_department_rounded),
          _FlowStat(
              label: 'level'.tr, value: '$_level', icon: Icons.auto_awesome),
          _FlowStat(
              label: 'bpm'.tr,
              value: '${_bpm.round()}',
              icon: Icons.favorite_rounded),
          _FlowStat(
              label: 'best'.tr,
              value: '$_maxStreak',
              icon: Icons.emoji_events_rounded),
        ],
      ),
    );
  }
}

class _FlowNode {
  _FlowNode({
    required this.position,
    required this.hue,
    required this.size,
  });

  final int position;
  final double hue, size;
  double age = 0;
  bool tapped = false;
}

class _RingPainter extends CustomPainter {
  _RingPainter(
      {required this.time, required this.nodeCount, required this.radius});
  final double time, radius;
  final int nodeCount;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Outer ring
    final ringPaint = Paint()
      ..color = AppColors.primary.withAlpha(30)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(Offset(cx, cy), radius, ringPaint);

    // Node positions
    for (int i = 0; i < nodeCount; i++) {
      final angle = (i / nodeCount) * math.pi * 2 - math.pi / 2;
      final nx = cx + math.cos(angle) * radius;
      final ny = cy + math.sin(angle) * radius;

      final dotPaint = Paint()..color = AppColors.border.withAlpha(60);
      canvas.drawCircle(Offset(nx, ny), 4, dotPaint);
    }

    // Rotating energy arc
    final arcPaint = Paint()
      ..color = AppColors.primary.withAlpha(60)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: radius),
      time * math.pi * 2,
      math.pi * 0.5,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.time != time;
}

class _FlowStat extends StatelessWidget {
  const _FlowStat(
      {required this.label, required this.value, required this.icon});
  final String label, value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.accent, size: 18),
        const SizedBox(height: 2),
        Text(value,
            style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700)),
        Text(label,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 9)),
      ],
    );
  }
}
