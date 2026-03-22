import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:sleepy_ai/core/constants/app_colors.dart';
import 'package:sleepy_ai/core/constants/app_sizes.dart';
import 'package:sleepy_ai/features/stories/domain/story_models.dart';

class StoryPlayerPage extends StatefulWidget {
  const StoryPlayerPage({super.key});

  @override
  State<StoryPlayerPage> createState() => _StoryPlayerPageState();
}

class _StoryPlayerPageState extends State<StoryPlayerPage>
    with TickerProviderStateMixin {
  late final SleepStory _story;
  late final AnimationController _walkCtrl;
  late final AnimationController _bobCtrl;
  late final AnimationController _lampCtrl;
  late final AnimationController _textFadeCtrl;
  late final AnimationController _parallaxCtrl;

  final FlutterTts _tts = FlutterTts();
  bool _isSpeaking = false;
  int _currentScene = 0;
  bool _isPlaying = true;
  final _rng = Random();

  // Parallax layers
  late List<_TreeData> _trees;
  late List<_ParticleData> _particles;

  @override
  void initState() {
    super.initState();
    _story = Get.arguments as SleepStory;

    _walkCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    _bobCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _lampCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _textFadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _parallaxCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();

    _generateScenery();
    _initTts();
    _scheduleNextScene();
  }

  void _generateScenery() {
    _trees = List.generate(
        18,
        (i) => _TreeData(
              x: _rng.nextDouble(),
              height: 0.3 + _rng.nextDouble() * 0.4,
              layer: _rng.nextInt(3),
              width: 0.02 + _rng.nextDouble() * 0.03,
            ));
    _particles = List.generate(
        30,
        (i) => _ParticleData(
              x: _rng.nextDouble(),
              y: _rng.nextDouble() * 0.7,
              speed: 0.2 + _rng.nextDouble() * 0.5,
              size: 2 + _rng.nextDouble() * 3,
              phase: _rng.nextDouble() * 2 * pi,
            ));
  }

  Future<void> _initTts() async {
    await _tts.setLanguage(Get.locale?.languageCode ?? 'en');
    await _tts.setSpeechRate(0.42);
    await _tts.setPitch(1.0);
    await _tts.setVolume(0.85);
    _tts.setCompletionHandler(() {
      if (mounted) setState(() => _isSpeaking = false);
    });
  }

  void _scheduleNextScene() {
    if (!mounted || _currentScene >= _story.scenes.length) return;
    final scene = _story.scenes[_currentScene];
    Future.delayed(Duration(seconds: scene.durationSeconds), () {
      if (!mounted || !_isPlaying) return;
      if (_currentScene < _story.scenes.length - 1) {
        setState(() {
          _currentScene++;
          _textFadeCtrl.reset();
          _textFadeCtrl.forward();
        });
        _scheduleNextScene();
      }
    });
  }

  Future<void> _toggleVoice() async {
    if (_isSpeaking) {
      await _tts.stop();
      setState(() => _isSpeaking = false);
    } else {
      final text = _story.scenes[_currentScene].text.tr;
      setState(() => _isSpeaking = true);
      await _tts.speak(text);
    }
  }

  void _togglePause() {
    setState(() => _isPlaying = !_isPlaying);
    if (_isPlaying) {
      _walkCtrl.repeat(reverse: true);
      _parallaxCtrl.repeat();
      _scheduleNextScene();
    } else {
      _walkCtrl.stop();
      _parallaxCtrl.stop();
      _tts.stop();
      _isSpeaking = false;
    }
  }

  @override
  void dispose() {
    _walkCtrl.dispose();
    _bobCtrl.dispose();
    _lampCtrl.dispose();
    _textFadeCtrl.dispose();
    _parallaxCtrl.dispose();
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scene = _story.scenes[_currentScene];

    return Scaffold(
      backgroundColor: _story.bgGradientColors.first,
      body: Stack(
        children: [
          // ─── Sky gradient ────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: _story.bgGradientColors,
              ),
            ),
          ),

          // ─── Stars ───────────────────────────────────────────
          AnimatedBuilder(
            animation: _lampCtrl,
            builder: (_, __) => CustomPaint(
              size: size,
              painter: _StarsPainter(
                twinkle: _lampCtrl.value,
                rng: _rng,
              ),
            ),
          ),

          // ─── Parallax trees & scenery ────────────────────────
          AnimatedBuilder(
            animation: _parallaxCtrl,
            builder: (_, __) => CustomPaint(
              size: size,
              painter: _SceneryPainter(
                trees: _trees,
                scrollOffset: _parallaxCtrl.value,
                treeColor: _story.treeColor,
                groundColor: _story.groundColor,
                isWalking: _isPlaying && scene.sceneType == SceneType.walking,
              ),
            ),
          ),

          // ─── Floating particles (fireflies / sparkles) ──────
          AnimatedBuilder(
            animation: _parallaxCtrl,
            builder: (_, __) => CustomPaint(
              size: size,
              painter: _ParticlesPainter(
                particles: _particles,
                time: _parallaxCtrl.value * 60,
                color: _story.particleColor,
              ),
            ),
          ),

          // ─── Ground path ─────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: size.height * 0.18,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    _story.groundColor.withAlpha(0),
                    _story.groundColor,
                    _story.groundColor,
                  ],
                  stops: const [0.0, 0.3, 1.0],
                ),
              ),
            ),
          ),

          // ─── CHARACTER (walking + lamp) ──────────────────────
          Positioned(
            bottom: size.height * 0.13,
            left: size.width * 0.15,
            child: AnimatedBuilder(
              animation: Listenable.merge([_walkCtrl, _bobCtrl, _lampCtrl]),
              builder: (_, __) {
                final walkOffset =
                    _isPlaying && scene.sceneType == SceneType.walking
                        ? sin(_walkCtrl.value * pi) * 4
                        : 0.0;
                final bobOffset = sin(_bobCtrl.value * pi) * 2;
                return Transform.translate(
                  offset: Offset(0, -walkOffset - bobOffset),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Lamp glow
                      Container(
                        width: 30 + _lampCtrl.value * 8,
                        height: 30 + _lampCtrl.value * 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: _story.lampColor.withAlpha(
                                (80 + _lampCtrl.value * 40).toInt(),
                              ),
                              blurRadius: 30 + _lampCtrl.value * 15,
                              spreadRadius: 10 + _lampCtrl.value * 8,
                            ),
                          ],
                        ),
                        child: const Text('🏮',
                            style: TextStyle(fontSize: 22),
                            textAlign: TextAlign.center),
                      ),
                      // Character
                      Text(
                        _story.characterEmoji,
                        style: const TextStyle(fontSize: 44),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // ─── STORY TEXT ──────────────────────────────────────
          Positioned(
            top: size.height * 0.08,
            left: 24,
            right: 24,
            child: SafeArea(
              child: FadeTransition(
                opacity: CurvedAnimation(
                  parent: _textFadeCtrl,
                  curve: Curves.easeIn,
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(120),
                    borderRadius: BorderRadius.circular(AppSizes.radiusXl),
                    border: Border.all(
                      color: _story.particleColor.withAlpha(40),
                    ),
                  ),
                  child: Text(
                    scene.text.tr,
                    style: TextStyle(
                      color: Colors.white.withAlpha(230),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 1.6,
                      letterSpacing: 0.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),

          // ─── Progress dots ───────────────────────────────────
          Positioned(
            bottom: size.height * 0.38,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_story.scenes.length, (i) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: i == _currentScene ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: i == _currentScene
                        ? _story.particleColor
                        : _story.particleColor.withAlpha(60),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),

          // ─── CONTROLS ────────────────────────────────────────
          Positioned(
            bottom: size.height * 0.04,
            left: 24,
            right: 24,
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Back
                  _ControlButton(
                    icon: Icons.arrow_back_rounded,
                    color: _story.particleColor,
                    onTap: () {
                      if (_currentScene > 0) {
                        setState(() {
                          _currentScene--;
                          _textFadeCtrl.reset();
                          _textFadeCtrl.forward();
                        });
                      }
                    },
                  ),

                  // Play/Pause
                  _ControlButton(
                    icon: _isPlaying
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    color: _story.particleColor,
                    size: 56,
                    onTap: _togglePause,
                  ),

                  // Voice (TTS)
                  _ControlButton(
                    icon: _isSpeaking
                        ? Icons.volume_up_rounded
                        : Icons.record_voice_over_rounded,
                    color:
                        _isSpeaking ? _story.lampColor : _story.particleColor,
                    onTap: _toggleVoice,
                  ),

                  // Forward
                  _ControlButton(
                    icon: Icons.arrow_forward_rounded,
                    color: _story.particleColor,
                    onTap: () {
                      if (_currentScene < _story.scenes.length - 1) {
                        setState(() {
                          _currentScene++;
                          _textFadeCtrl.reset();
                          _textFadeCtrl.forward();
                        });
                        _scheduleNextScene();
                      }
                    },
                  ),

                  // Close
                  _ControlButton(
                    icon: Icons.close_rounded,
                    color: Colors.white54,
                    onTap: () => Get.back(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// CONTROL BUTTON
// ═════════════════════════════════════════════════════════════════════════════

class _ControlButton extends StatelessWidget {
  const _ControlButton({
    required this.icon,
    required this.color,
    required this.onTap,
    this.size = 44,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withAlpha(25),
          border: Border.all(color: color.withAlpha(80)),
        ),
        child: Icon(icon, color: color, size: size * 0.5),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// CUSTOM PAINTERS
// ═════════════════════════════════════════════════════════════════════════════

class _TreeData {
  _TreeData({
    required this.x,
    required this.height,
    required this.layer,
    required this.width,
  });
  final double x;
  final double height;
  final int layer; // 0=far, 1=mid, 2=near
  final double width;
}

class _ParticleData {
  _ParticleData({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.phase,
  });
  final double x;
  final double y;
  final double speed;
  final double size;
  final double phase;
}

class _StarsPainter extends CustomPainter {
  _StarsPainter({required this.twinkle, required this.rng});
  final double twinkle;
  final Random rng;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    // Use fixed seed for consistent stars
    final starRng = Random(42);
    for (int i = 0; i < 60; i++) {
      final x = starRng.nextDouble() * size.width;
      final y = starRng.nextDouble() * size.height * 0.5;
      final brightness = 0.3 + sin(twinkle * pi * 2 + i * 0.5) * 0.3;
      paint.color = Colors.white.withAlpha((brightness * 255).toInt());
      final r = 0.5 + starRng.nextDouble() * 1.5;
      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _StarsPainter old) => true;
}

class _SceneryPainter extends CustomPainter {
  _SceneryPainter({
    required this.trees,
    required this.scrollOffset,
    required this.treeColor,
    required this.groundColor,
    required this.isWalking,
  });

  final List<_TreeData> trees;
  final double scrollOffset;
  final Color treeColor;
  final Color groundColor;
  final bool isWalking;

  @override
  void paint(Canvas canvas, Size size) {
    final treePaint = Paint();

    for (final tree in trees) {
      // Parallax speed based on layer
      final speed = (tree.layer + 1) * 0.3;
      final scrollDelta =
          isWalking ? scrollOffset * speed : scrollOffset * speed * 0.1;
      var x = ((tree.x + scrollDelta) % 1.2) * size.width - size.width * 0.1;

      final alpha = tree.layer == 0 ? 120 : (tree.layer == 1 ? 170 : 220);
      treePaint.color = treeColor.withAlpha(alpha);

      final trunkW = size.width * tree.width;
      final trunkH = size.height * tree.height;
      final bottom = size.height * 0.85;

      // Trunk
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x - trunkW / 2, bottom - trunkH, trunkW, trunkH),
          Radius.circular(trunkW * 0.3),
        ),
        treePaint,
      );

      // Canopy (triangles)
      final canopyPaint = Paint()..color = treeColor.withAlpha(alpha + 20);
      final canopyPath = Path();
      final canopyW = trunkW * 4;
      final canopyTop = bottom - trunkH - size.height * 0.08;
      canopyPath.moveTo(x, canopyTop);
      canopyPath.lineTo(x - canopyW / 2, bottom - trunkH * 0.5);
      canopyPath.lineTo(x + canopyW / 2, bottom - trunkH * 0.5);
      canopyPath.close();
      canvas.drawPath(canopyPath, canopyPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _SceneryPainter old) => true;
}

class _ParticlesPainter extends CustomPainter {
  _ParticlesPainter({
    required this.particles,
    required this.time,
    required this.color,
  });

  final List<_ParticleData> particles;
  final double time;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (final p in particles) {
      final alpha = (0.3 + sin(time * p.speed + p.phase) * 0.4).clamp(0.0, 1.0);
      paint.color = color.withAlpha((alpha * 180).toInt());
      final x = (p.x + sin(time * 0.3 + p.phase) * 0.02) * size.width;
      final y =
          (p.y + cos(time * p.speed * 0.5 + p.phase) * 0.015) * size.height;
      canvas.drawCircle(Offset(x, y), p.size, paint);

      // Glow
      paint.color = color.withAlpha((alpha * 40).toInt());
      canvas.drawCircle(Offset(x, y), p.size * 3, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlesPainter old) => true;
}
