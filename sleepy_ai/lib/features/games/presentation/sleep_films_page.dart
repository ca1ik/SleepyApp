import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' hide Transition;
import 'package:get/get.dart';
import 'package:sleepy_ai/features/rewards/cubit/rewards_cubit.dart';

// ── Film definition ───────────────────────────────────────────────────────────

class _FilmDef {
  const _FilmDef({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.gradient,
    required this.scenes,
  });

  final String id;
  final String title;
  final String subtitle;
  final String emoji;
  final List<Color> gradient;
  final List<_SceneDef> scenes;
}

class _SceneDef {
  const _SceneDef(this.narration, this.accentColor);
  final String narration;
  final Color accentColor;
}

const _kFilms = [
  _FilmDef(
    id: 'stars',
    title: 'filmStarJourney',
    subtitle: 'filmStarJourneySub',
    emoji: '🌌',
    gradient: [Color(0xFF0D001A), Color(0xFF1A003A)],
    scenes: [
      _SceneDef('filmStar1', Color(0xFF9D64F5)),
      _SceneDef('filmStar2', Color(0xFF7C3AED)),
      _SceneDef('filmStar3', Color(0xFF4F46E5)),
      _SceneDef('filmStar4', Color(0xFF06B6D4)),
    ],
  ),
  _FilmDef(
    id: 'nebula',
    title: 'filmNebula',
    subtitle: 'filmNebulaSub',
    emoji: '🎨',
    gradient: [Color(0xFF0A0015), Color(0xFF1E0030)],
    scenes: [
      _SceneDef('filmNebula1', Color(0xFFEC4899)),
      _SceneDef('filmNebula2', Color(0xFFEF4444)),
      _SceneDef('filmNebula3', Color(0xFFF97316)),
      _SceneDef('filmNebula4', Color(0xFFFBBF24)),
    ],
  ),
  _FilmDef(
    id: 'moon',
    title: 'filmMoon',
    subtitle: 'filmMoonSub',
    emoji: '🌙',
    gradient: [Color(0xFF030B1A), Color(0xFF0A1A2E)],
    scenes: [
      _SceneDef('filmMoon1', Color(0xFFBAE6FD)),
      _SceneDef('filmMoon2', Color(0xFF7DD3FC)),
      _SceneDef('filmMoon3', Color(0xFF38BDF8)),
      _SceneDef('filmMoon4', Color(0xFF0EA5E9)),
    ],
  ),
  _FilmDef(
    id: 'aurora',
    title: 'filmAurora',
    subtitle: 'filmAuroraSub',
    emoji: '🌅',
    gradient: [Color(0xFF001A0D), Color(0xFF002A15)],
    scenes: [
      _SceneDef('filmAurora1', Color(0xFF34D399)),
      _SceneDef('filmAurora2', Color(0xFF10B981)),
      _SceneDef('filmAurora3', Color(0xFF6EE7B7)),
      _SceneDef('filmAurora4', Color(0xFF059669)),
    ],
  ),
  _FilmDef(
    id: 'ocean',
    title: 'filmOcean',
    subtitle: 'filmOceanSub',
    emoji: '🌊',
    gradient: [Color(0xFF000D1A), Color(0xFF001A33)],
    scenes: [
      _SceneDef('filmOcean1', Color(0xFF22D3EE)),
      _SceneDef('filmOcean2', Color(0xFF06B6D4)),
      _SceneDef('filmOcean3', Color(0xFF0891B2)),
      _SceneDef('filmOcean4', Color(0xFF0E7490)),
    ],
  ),
  _FilmDef(
    id: 'clouds',
    title: 'filmClouds',
    subtitle: 'filmCloudsSub',
    emoji: '☁️',
    gradient: [Color(0xFF1A0A1A), Color(0xFF0F0020)],
    scenes: [
      _SceneDef('filmCloud1', Color(0xFFFDA4AF)),
      _SceneDef('filmCloud2', Color(0xFFFB923C)),
      _SceneDef('filmCloud3', Color(0xFFF9A8D4)),
      _SceneDef('filmCloud4', Color(0xFFC084FC)),
    ],
  ),
  _FilmDef(
    id: 'crystal',
    title: 'filmCrystal',
    subtitle: 'filmCrystalSub',
    emoji: '💎',
    gradient: [Color(0xFF000A1A), Color(0xFF001530)],
    scenes: [
      _SceneDef('filmCrystal1', Color(0xFF818CF8)),
      _SceneDef('filmCrystal2', Color(0xFF6366F1)),
      _SceneDef('filmCrystal3', Color(0xFF8B5CF6)),
      _SceneDef('filmCrystal4', Color(0xFFA78BFA)),
    ],
  ),
  _FilmDef(
    id: 'void',
    title: 'filmVoid',
    subtitle: 'filmVoidSub',
    emoji: '∞',
    gradient: [Color(0xFF000000), Color(0xFF050005)],
    scenes: [
      _SceneDef('filmVoid1', Color(0xFF7C3AED)),
      _SceneDef('filmVoid2', Color(0xFF6D28D9)),
      _SceneDef('filmVoid3', Color(0xFF5B21B6)),
      _SceneDef('filmVoid4', Color(0xFF4C1D95)),
    ],
  ),
];

// ── Painting helpers ──────────────────────────────────────────────────────────

class _Particle {
  _Particle(math.Random rng, double w, double h)
      : x = rng.nextDouble() * w,
        y = rng.nextDouble() * h,
        vx = (rng.nextDouble() - 0.5) * 40,
        vy = (rng.nextDouble() - 0.5) * 40,
        r = 1.0 + rng.nextDouble() * 3,
        life = rng.nextDouble();
  double x, y, vx, vy, r, life;
}

// ── Film player page ──────────────────────────────────────────────────────────

class _FilmPlayerPage extends StatefulWidget {
  const _FilmPlayerPage({required this.film});
  final _FilmDef film;

  @override
  State<_FilmPlayerPage> createState() => _FilmPlayerPageState();
}

class _FilmPlayerPageState extends State<_FilmPlayerPage>
    with TickerProviderStateMixin {
  static const int _sceneDuration = 45; // seconds per scene
  static const double _dt = 1 / 60;

  late final AnimationController _anim;

  final _rng = math.Random();
  late List<_Particle> _particles;

  double _timeSec = 0;
  int _sceneIndex = 0;
  bool _finished = false;
  bool _badgeUnlocked = false;
  double _screenW = 400;
  double _screenH = 800;

  int get _totalScenes => widget.film.scenes.length;
  int get _totalDuration => _totalScenes * _sceneDuration;

  @override
  void initState() {
    super.initState();
    _anim =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat();
    _particles = List.generate(
        80, (i) => _Particle(_rng, 400, 800)); // increased for richer effect
    _anim.addListener(_tick);
  }

  void _tick() {
    if (_finished) return;
    _timeSec += _dt;

    // Update particles — gentle upward drift for dreamy feel
    for (final p in _particles) {
      p.x += p.vx * _dt;
      p.y += (p.vy - 12) * _dt; // upward bias
      p.life += _dt * 0.10; // slower fade = longer visible
      if (p.life >= 1) {
        p.x = _rng.nextDouble() * _screenW;
        p.y = _screenH + 8.0; // re-spawn at bottom
        p.vx = (_rng.nextDouble() - 0.5) * 28;
        p.vy = -8 - _rng.nextDouble() * 20; // upward
        p.life = 0;
      }
    }

    // Advance scene
    final newScene =
        (_timeSec / _sceneDuration).floor().clamp(0, _totalScenes - 1);
    if (newScene != _sceneIndex) {
      _sceneIndex = newScene;
    }

    // Film complete
    if (_timeSec >= _totalDuration) {
      _finishFilm();
      return;
    }

    setState(() {});
  }

  void _finishFilm() {
    _anim.stop();
    _finished = true;

    final cubit = context.read<RewardsCubit>();
    cubit.recordFilmWatched(widget.film.id);

    setState(() {});
  }

  /// Sağa kaydırıldığında bir sonraki sahneye atla.
  void _advanceScene() {
    if (_finished) return;
    final next = _sceneIndex + 1;
    if (next >= _totalScenes) {
      _finishFilm();
      return;
    }
    setState(() {
      _sceneIndex = next;
      _timeSec = (next * _sceneDuration).toDouble();
    });
  }

  void _onSwipe(DragEndDetails d) {
    if ((d.primaryVelocity ?? 0) > 250) _advanceScene();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _screenW = size.width;
    _screenH = size.height;

    // Refresh particle bounds
    if (_particles.length == 80) {
      for (final p in _particles) {
        if (p.x > size.width) p.x = _rng.nextDouble() * size.width;
        if (p.y < 0 && p.vy < 0) p.y = size.height;
      }
    }

    if (_finished) return _buildFinishScreen();

    final scene = widget.film.scenes[_sceneIndex];
    final sceneProgress =
        (_timeSec - _sceneIndex * _sceneDuration) / _sceneDuration;
    final totalProgress = _timeSec / _totalDuration;

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragEnd: _onSwipe,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Animated gradient background
            AnimatedContainer(
              duration: const Duration(seconds: 2),
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(math.sin(_timeSec * 0.2) * 0.5,
                      math.cos(_timeSec * 0.15) * 0.5),
                  radius: 1.5,
                  colors: [
                    widget.film.gradient[0]
                        .withAlpha((180 + sceneProgress * 70).round()),
                    widget.film.gradient[1],
                    Colors.black,
                  ],
                ),
              ),
            ),

            // Floating particles
            AnimatedBuilder(
              animation: _anim,
              builder: (_, __) => CustomPaint(
                painter: _ParticlePainter(_particles, scene.accentColor),
                size: size,
              ),
            ),

            // Aurora wave bands — active dreamy effect
            AnimatedBuilder(
              animation: _anim,
              builder: (_, __) => CustomPaint(
                painter: _AuraPainter(_timeSec, scene.accentColor),
                size: size,
              ),
            ),

            // Scene narration
            Positioned(
              bottom: 80,
              left: 28,
              right: 28,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 800),
                child: Text(
                  scene.narration.tr,
                  key: ValueKey(_sceneIndex),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withAlpha(210),
                    fontSize: 17,
                    height: 1.6,
                    fontWeight: FontWeight.w300,
                    shadows: [
                      Shadow(
                          color: scene.accentColor.withAlpha(120),
                          blurRadius: 12)
                    ],
                  ),
                ),
              ),
            ),

            // Top HUD
            SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(20),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.close,
                                color: Colors.white60, size: 20),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.film.title.tr,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'sceneLabel'.trParams({
                                  'current': '${_sceneIndex + 1}',
                                  'total': '$_totalScenes',
                                }),
                                style: const TextStyle(
                                    color: Colors.white54, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'secondsLeft'.trParams(
                            {'sec': '${(_totalDuration - _timeSec).ceil()}'},
                          ),
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Stack(
                        children: [
                          Container(height: 4, color: Colors.white12),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            height: 4,
                            width: (MediaQuery.of(context).size.width - 40) *
                                totalProgress,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  scene.accentColor,
                                  scene.accentColor.withAlpha(180)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Scene dots
            Positioned(
              bottom: 52,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _totalScenes,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: i == _sceneIndex ? 20 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color:
                          i == _sceneIndex ? scene.accentColor : Colors.white24,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ),

            // Swipe hint
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'swipeForNext'.tr,
                  style: TextStyle(
                      color: Colors.white.withAlpha(60),
                      fontSize: 11,
                      letterSpacing: 0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinishScreen() {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topCenter,
          radius: 1.5,
          colors: [
            widget.film.gradient[0],
            widget.film.gradient[1],
            Colors.black,
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.film.emoji, style: const TextStyle(fontSize: 80)),
              const SizedBox(height: 20),
              Text(
                widget.film.title.tr,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'filmCompleted'.tr,
                style:
                    TextStyle(color: Colors.white.withAlpha(150), fontSize: 16),
              ),
              if (_badgeUnlocked) ...[
                const SizedBox(height: 28),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.purple.withAlpha(40),
                    border: Border.all(color: Colors.purple.withAlpha(120)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('🎬', style: TextStyle(fontSize: 28)),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('badgeEarned'.tr,
                              style: const TextStyle(
                                  color: Colors.purpleAccent,
                                  fontWeight: FontWeight.bold)),
                          Text('dreamWeaver'.tr,
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
                      child: Text('filmList'.tr,
                          style: const TextStyle(color: Colors.white70)),
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

class _ParticlePainter extends CustomPainter {
  _ParticlePainter(this.particles, this.color) : super(repaint: null);
  final List<_Particle> particles;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint();
    for (final pt in particles) {
      final alpha = ((1 - pt.life) * 110).round().clamp(0, 255);
      p.color = color.withAlpha(alpha);
      p.maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
      canvas.drawCircle(Offset(pt.x, pt.y), pt.r + 0.5, p);
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => true;
}

// ── Aurora wave painter — active dreamy band effect ───────────────────────────

class _AuraPainter extends CustomPainter {
  _AuraPainter(this.t, this.color) : super(repaint: null);
  final double t;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < 6; i++) {
      final phase = t * 0.6 + i * 1.1;
      final cy = size.height * (0.15 + i * 0.15) +
          math.sin(phase) * size.height * 0.06;
      final alpha = (8 + 12 * ((math.sin(t * 0.8 + i * 0.7) + 1) / 2)).round();
      paint.color = color.withAlpha(alpha.clamp(0, 60));
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(size.width * 0.5, cy),
          width: size.width * (1.4 + math.sin(t * 0.4 + i) * 0.2),
          height: 55.0 + math.sin(t * 0.5 + i * 0.9) * 18,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_AuraPainter old) => old.t != t;
}

// ── Films list page ───────────────────────────────────────────────────────────

class SleepFilmsPage extends StatelessWidget {
  const SleepFilmsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF03000F),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            expandedHeight: 140,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white70),
              onPressed: () => Get.back(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'sleepFilmsAppbar'.tr,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1A003A), Color(0xFF03000F)],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'filmsCount'.trParams({'count': '${_kFilms.length}'}),
                style: const TextStyle(color: Colors.white38, fontSize: 13),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.85,
              ),
              delegate: SliverChildBuilderDelegate(
                (ctx, i) => _FilmCard(film: _kFilms[i]),
                childCount: _kFilms.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}

class _FilmCard extends StatelessWidget {
  const _FilmCard({required this.film});
  final _FilmDef film;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(
        () => _FilmPlayerPage(film: film),
        transition: Transition.fade,
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              film.gradient[0].withAlpha(220),
              film.gradient[1],
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: film.scenes[0].accentColor.withAlpha(60)),
          boxShadow: [
            BoxShadow(
              color: film.scenes[0].accentColor.withAlpha(30),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(film.emoji, style: const TextStyle(fontSize: 40)),
              const Spacer(),
              Text(
                film.title.tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                film.subtitle.tr,
                style: TextStyle(
                  color: Colors.white.withAlpha(140),
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.play_circle_outline_rounded,
                      color: film.scenes[0].accentColor, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    'minutesShort'.tr,
                    style: TextStyle(
                        color: film.scenes[0].accentColor, fontSize: 12),
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
