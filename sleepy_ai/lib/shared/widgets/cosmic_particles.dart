import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Reusable cosmic particle effect overlay.
/// Renders floating light particles for astral/zodiac screens.
class CosmicParticleOverlay extends StatefulWidget {
  const CosmicParticleOverlay({
    super.key,
    this.particleCount = 80,
    this.baseColor = const Color(0xFF8B5CF6),
    this.secondaryColor = const Color(0xFFFF6FD8),
    this.maxRadius = 3.0,
    this.speed = 1.0,
  });

  final int particleCount;
  final Color baseColor;
  final Color secondaryColor;
  final double maxRadius;
  final double speed;

  @override
  State<CosmicParticleOverlay> createState() => _CosmicParticleOverlayState();
}

class _CosmicParticleOverlayState extends State<CosmicParticleOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final List<_Particle> _particles;

  @override
  void initState() {
    super.initState();
    _particles = List.generate(
      widget.particleCount,
      (i) => _Particle(i * 31 + 7, widget.maxRadius),
    );
    _ctrl = AnimationController(
      vsync: this,
      duration: Duration(seconds: (20 / widget.speed).round()),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => CustomPaint(
        painter: _ParticlePainter(
          particles: _particles,
          time: _ctrl.value,
          baseColor: widget.baseColor,
          secondaryColor: widget.secondaryColor,
        ),
        size: MediaQuery.of(context).size,
      ),
    );
  }
}

class _Particle {
  _Particle(int seed, double maxR) {
    final rng = math.Random(seed);
    x = rng.nextDouble();
    y = rng.nextDouble();
    radius = 0.5 + rng.nextDouble() * maxR;
    opacity = 0.1 + rng.nextDouble() * 0.4;
    phase = rng.nextDouble() * math.pi * 2;
    driftX = (rng.nextDouble() - 0.5) * 0.08;
    driftY = (rng.nextDouble() - 0.5) * 0.06;
    useSecondary = rng.nextDouble() < 0.3;
  }

  late final double x, y, radius, opacity, phase, driftX, driftY;
  late final bool useSecondary;
}

class _ParticlePainter extends CustomPainter {
  _ParticlePainter({
    required this.particles,
    required this.time,
    required this.baseColor,
    required this.secondaryColor,
  });

  final List<_Particle> particles;
  final double time;
  final Color baseColor, secondaryColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (final p in particles) {
      final t2 = time * math.pi * 2;
      final drift = math.sin(t2 + p.phase);
      final px = ((p.x + p.driftX * drift) % 1.0) * size.width;
      final py = ((p.y + p.driftY * drift) % 1.0) * size.height;
      final alpha = p.opacity * (0.5 + 0.5 * math.sin(t2 * 0.7 + p.phase));

      final color = p.useSecondary ? secondaryColor : baseColor;
      paint.color = color.withAlpha((alpha * 255).round().clamp(0, 255));

      // Subtle glow
      if (p.radius > 1.5) {
        paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
        canvas.drawCircle(Offset(px, py), p.radius * 1.5, paint);
        paint.maskFilter = null;
      }

      paint.color = color.withAlpha(
        (alpha * 255 * 1.2).round().clamp(0, 255),
      );
      canvas.drawCircle(Offset(px, py), p.radius, paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => old.time != time;
}
