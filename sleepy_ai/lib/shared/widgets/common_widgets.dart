import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sleepy_ai/core/constants/app_colors.dart';
import 'package:sleepy_ai/core/constants/app_sizes.dart';

/// Fixed random seed list for stable raindrop positions across rebuilds.
final _dropSeeds = List.unmodifiable(List.generate(55, (i) => i * 37 + 11));

/// Model for a single raindrop particle.
class _RaindropParticle {
  _RaindropParticle(int seed) {
    final rng = math.Random(seed);
    x = rng.nextDouble();
    y = rng.nextDouble();
    speed = 0.12 + rng.nextDouble() * 0.22; // slow 0.12–0.34
    length = 9.0 + rng.nextDouble() * 11.0; // 9–20 px
    opacity = 0.04 + rng.nextDouble() * 0.09; // very subtle
  }

  late final double x;
  late final double y;
  late final double speed;
  late final double length;
  late final double opacity;
}

/// CustomPainter that draws soft falling raindrops.
class _RaindropPainter extends CustomPainter {
  _RaindropPainter(this.drops, this.progress, Animation<double> repaint)
      : super(repaint: repaint);

  final List<_RaindropParticle> drops;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    for (final d in drops) {
      final yFrac = (d.y + progress * d.speed) % 1.0;
      final px = d.x * size.width;
      final py = yFrac * size.height;
      final paint = Paint()
        ..color = const Color(0xFF8FBCFF).withAlpha((d.opacity * 255).round())
        ..strokeWidth = 0.75
        ..style = PaintingStyle.stroke;
      // slight diagonal slant
      canvas.drawLine(Offset(px, py), Offset(px - 1.5, py + d.length), paint);
    }
  }

  @override
  bool shouldRepaint(_RaindropPainter old) => old.progress != progress;
}

/// Uygulamanın her sayfasında kullanılan mor gradient arka plan.
/// Tüm sayfalar bu widget ile sarılır.
/// Derin mor gradient + hafif deniz fotosu + yavaş düşen yağmur damlaları içerir.
class GradientBackground extends StatefulWidget {
  const GradientBackground({
    super.key,
    required this.child,
    this.gradient,
    this.padding,
  });

  final Widget child;
  final Gradient? gradient;
  final EdgeInsets? padding;

  @override
  State<GradientBackground> createState() => _GradientBackgroundState();
}

class _GradientBackgroundState extends State<GradientBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 12), // very slow cycle
  )..repeat();

  late final List<_RaindropParticle> _drops =
      _dropSeeds.map((s) => _RaindropParticle(s)).toList(growable: false);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final content = widget.padding != null
        ? Padding(padding: widget.padding!, child: widget.child)
        : widget.child;

    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. Purple gradient background
        Container(
          decoration: BoxDecoration(
            gradient: widget.gradient ?? AppColors.backgroundGradient,
          ),
        ),

        // 2. Very faint ocean photo overlay
        Positioned.fill(
          child: Image.network(
            'https://images.unsplash.com/photo-1505118380757-91f5f5632de0'
            '?w=800&q=80&fm=jpg',
            fit: BoxFit.cover,
            opacity: const AlwaysStoppedAnimation(0.06),
            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
          ),
        ),

        // 3. Animated slow raindrops
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedBuilder(
              animation: _ctrl,
              builder: (_, __) => CustomPaint(
                painter: _RaindropPainter(_drops, _ctrl.value, _ctrl),
              ),
            ),
          ),
        ),

        // 4. Page content
        content,
      ],
    );
  }
}

/// Mor gradient dolgulu birincil buton.
/// [isLoading] true iken spinner gösterir.
class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.gradient,
    this.height = AppSizes.buttonHeight,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Gradient? gradient;
  final double height;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: onPressed == null
              ? const LinearGradient(
                  colors: [AppColors.textDisabled, AppColors.textDisabled],
                )
              : gradient ?? AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusXl),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: AppSizes.iconSm),
                      const SizedBox(width: AppSizes.sm),
                    ],
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: AppSizes.fontLg,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

/// Cam efektli kart widget'ı — glassmorphism tarzı.
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.gradient,
    this.border,
    this.onTap,
  });

  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? borderRadius;
  final Gradient? gradient;
  final Border? border;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? AppSizes.radiusLg;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin,
        padding: padding ?? const EdgeInsets.all(AppSizes.md),
        decoration: BoxDecoration(
          gradient: gradient ?? AppColors.cardGradient,
          borderRadius: BorderRadius.circular(radius),
          border: border ??
              Border.all(
                color: AppColors.borderLight.withAlpha(80),
                width: 0.5,
              ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryDeep.withAlpha(60),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
