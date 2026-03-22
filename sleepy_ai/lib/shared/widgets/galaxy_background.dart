import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sleepy_ai/core/constants/app_colors.dart';

/// Galaxy particle model for deep-space canvas rendering.
class _GalaxyParticle {
  _GalaxyParticle(int seed) {
    final rng = math.Random(seed);
    x = rng.nextDouble();
    y = rng.nextDouble();
    radius = 0.3 + rng.nextDouble() * 2.5;
    baseOpacity = 0.08 + rng.nextDouble() * 0.55;
    phase = rng.nextDouble() * math.pi * 2;
    speed = 0.3 + rng.nextDouble() * 0.7;
    hue = rng.nextDouble() * 60 + 240; // 240–300 → purple–blue range
    isBright = rng.nextDouble() < 0.12;
  }

  late final double x, y, radius, baseOpacity, phase, speed, hue;
  late final bool isBright;
}

/// Nebula cloud rendered as radial gradients.
class _NebulaCloud {
  _NebulaCloud(int seed) {
    final rng = math.Random(seed);
    cx = 0.1 + rng.nextDouble() * 0.8;
    cy = 0.1 + rng.nextDouble() * 0.8;
    radiusFactor = 0.15 + rng.nextDouble() * 0.25;
    hue = rng.nextDouble() * 80 + 250; // purple–pink range
    alpha = 0.03 + rng.nextDouble() * 0.06;
    driftSpeed = 0.02 + rng.nextDouble() * 0.04;
  }

  late final double cx, cy, radiusFactor, hue, alpha, driftSpeed;
}

/// High-performance galaxy canvas painter with stars + nebula.
class GalaxyPainter extends CustomPainter {
  GalaxyPainter({
    required this.stars,
    required this.nebulae,
    required this.time,
    required Animation<double> animation,
  }) : super(repaint: animation);

  final List<_GalaxyParticle> stars;
  final List<_NebulaCloud> nebulae;
  final double time;

  @override
  void paint(Canvas canvas, Size size) {
    // Draw nebula clouds first (background layer)
    for (final n in nebulae) {
      final drift = math.sin(time * n.driftSpeed * math.pi * 2) * 0.02;
      final cx = (n.cx + drift) * size.width;
      final cy = (n.cy + drift * 0.5) * size.height;
      final r = n.radiusFactor * size.width;

      final color = HSVColor.fromAHSV(1, n.hue % 360, 0.6, 0.9).toColor();
      final gradient = RadialGradient(
        colors: [
          color.withAlpha((n.alpha * 255).round()),
          color.withAlpha((n.alpha * 0.3 * 255).round()),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      );

      final rect = Rect.fromCircle(center: Offset(cx, cy), radius: r);
      final paint = Paint()..shader = gradient.createShader(rect);
      canvas.drawCircle(Offset(cx, cy), r, paint);
    }

    // Draw stars
    final starPaint = Paint();
    for (final s in stars) {
      final twinkle = 0.3 +
          0.7 * ((math.sin(time * s.speed * math.pi * 2 + s.phase) + 1) / 2);
      final opacity = s.baseOpacity * twinkle;

      if (s.isBright) {
        // Glow effect for bright stars
        final glowColor =
            HSVColor.fromAHSV(opacity * 0.3, s.hue, 0.4, 1.0).toColor();
        starPaint.color = glowColor;
        starPaint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
        canvas.drawCircle(
          Offset(s.x * size.width, s.y * size.height),
          s.radius * 2.5,
          starPaint,
        );
        starPaint.maskFilter = null;
      }

      final color = HSVColor.fromAHSV(opacity.clamp(0.0, 1.0), s.hue, 0.15, 1.0)
          .toColor();
      starPaint.color = color;
      canvas.drawCircle(
        Offset(s.x * size.width, s.y * size.height),
        s.radius,
        starPaint,
      );
    }
  }

  @override
  bool shouldRepaint(GalaxyPainter old) => old.time != time;
}

/// Full-screen immersive galaxy background with animated stars,
/// nebula clouds, and floating cosmic dust.
class GalaxyBackground extends StatefulWidget {
  const GalaxyBackground({
    super.key,
    required this.child,
    this.starCount = 200,
    this.nebulaCount = 5,
    this.showShootingStars = true,
    this.intensity = 1.0,
  });

  final Widget child;
  final int starCount;
  final int nebulaCount;
  final bool showShootingStars;
  final double intensity;

  @override
  State<GalaxyBackground> createState() => _GalaxyBackgroundState();
}

class _GalaxyBackgroundState extends State<GalaxyBackground>
    with TickerProviderStateMixin {
  late final AnimationController _starCtrl;
  late final AnimationController _shootCtrl;
  late final List<_GalaxyParticle> _stars;
  late final List<_NebulaCloud> _nebulae;

  // Shooting star
  double _shootX = 0, _shootY = 0, _shootAngle = 0;
  bool _shootActive = false;

  @override
  void initState() {
    super.initState();
    _stars = List.generate(
      widget.starCount,
      (i) => _GalaxyParticle(i * 47 + 13),
    );
    _nebulae = List.generate(
      widget.nebulaCount,
      (i) => _NebulaCloud(i * 83 + 7),
    );

    _starCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();

    _shootCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    if (widget.showShootingStars) {
      _scheduleShootingStar();
    }
  }

  void _scheduleShootingStar() {
    Future.delayed(
      Duration(seconds: 4 + math.Random().nextInt(8)),
      () {
        if (!mounted) return;
        final rng = math.Random();
        _shootX = rng.nextDouble() * 0.6;
        _shootY = rng.nextDouble() * 0.4;
        _shootAngle = 0.3 + rng.nextDouble() * 0.5;
        _shootActive = true;
        _shootCtrl.forward(from: 0).then((_) {
          if (mounted) {
            _shootActive = false;
            _scheduleShootingStar();
          }
        });
      },
    );
  }

  @override
  void dispose() {
    _starCtrl.dispose();
    _shootCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      fit: StackFit.expand,
      children: [
        // Deep space gradient
        Container(
            decoration:
                const BoxDecoration(gradient: AppColors.galaxyGradient)),

        // Galaxy canvas
        AnimatedBuilder(
          animation: _starCtrl,
          builder: (_, __) => CustomPaint(
            painter: GalaxyPainter(
              stars: _stars,
              nebulae: _nebulae,
              time: _starCtrl.value,
              animation: _starCtrl,
            ),
            size: size,
          ),
        ),

        // Shooting star overlay
        if (widget.showShootingStars)
          AnimatedBuilder(
            animation: _shootCtrl,
            builder: (_, __) {
              if (!_shootActive) return const SizedBox.shrink();
              return CustomPaint(
                painter: _ShootingStarPainter(
                  progress: _shootCtrl.value,
                  startX: _shootX,
                  startY: _shootY,
                  angle: _shootAngle,
                ),
                size: size,
              );
            },
          ),

        // Content
        widget.child,
      ],
    );
  }
}

class _ShootingStarPainter extends CustomPainter {
  _ShootingStarPainter({
    required this.progress,
    required this.startX,
    required this.startY,
    required this.angle,
  });

  final double progress, startX, startY, angle;

  @override
  void paint(Canvas canvas, Size size) {
    final len = size.width * 0.3;
    final sx = startX * size.width;
    final sy = startY * size.height;
    final ex = sx + math.cos(angle) * len * progress;
    final ey = sy + math.sin(angle) * len * progress;

    final opacity = progress < 0.5 ? progress * 2 : (1 - progress) * 2;

    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.white.withAlpha((opacity * 220).round()),
          Colors.white.withAlpha((opacity * 80).round()),
          Colors.transparent,
        ],
      ).createShader(Rect.fromPoints(Offset(ex, ey), Offset(sx, sy)))
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(sx, sy), Offset(ex, ey), paint);

    // Head glow
    final headPaint = Paint()
      ..color = Colors.white.withAlpha((opacity * 200).round())
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(Offset(ex, ey), 3, headPaint);
  }

  @override
  bool shouldRepaint(_ShootingStarPainter old) => old.progress != progress;
}
