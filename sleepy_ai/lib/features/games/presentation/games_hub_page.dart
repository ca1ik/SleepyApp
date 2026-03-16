import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sleepy_ai/core/constants/app_colors.dart';
import 'package:sleepy_ai/core/constants/app_constants.dart';
import 'package:sleepy_ai/features/rewards/cubit/rewards_cubit.dart';
import 'package:sleepy_ai/features/rewards/cubit/rewards_state.dart';
import 'package:sleepy_ai/shared/models/app_models.dart';

// ── Twinkling background ──────────────────────────────────────────────────────

class _Star {
  _Star(int seed) {
    final r = math.Random(seed);
    x = r.nextDouble();
    y = r.nextDouble();
    radius = 0.3 + r.nextDouble() * 1.5;
    opacity = 0.1 + r.nextDouble() * 0.5;
    twinkle = r.nextDouble() * math.pi * 2;
  }
  late final double x, y, radius, opacity, twinkle;
}

class _StarfieldPainter extends CustomPainter {
  _StarfieldPainter(this.stars, this.t) : super(repaint: null);
  final List<_Star> stars;
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
  bool shouldRepaint(_StarfieldPainter old) => old.t != t;
}

// ── Games Hub Page ────────────────────────────────────────────────────────────

class GamesHubPage extends StatefulWidget {
  const GamesHubPage({super.key});

  @override
  State<GamesHubPage> createState() => _GamesHubPageState();
}

class _GamesHubPageState extends State<GamesHubPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _starAnim;
  final List<_Star> _stars = List.generate(150, (i) => _Star(i + 99));

  @override
  void initState() {
    super.initState();
    _starAnim =
        AnimationController(vsync: this, duration: const Duration(seconds: 8))
          ..repeat();
  }

  @override
  void dispose() {
    _starAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          // Starfield background
          AnimatedBuilder(
            animation: _starAnim,
            builder: (_, __) => CustomPaint(
              painter: _StarfieldPainter(_stars, _starAnim.value),
              size: size,
            ),
          ),

          // Dark gradient overlay
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x99000000),
                  Color(0x44000000),
                  Color(0x99000000),
                ],
              ),
            ),
          ),

          // Content
          SafeArea(
            child: BlocBuilder<RewardsCubit, RewardsState>(
              builder: (context, state) => CustomScrollView(
                slivers: [
                  _buildHeader(),
                  _buildScoreCard(state),
                  _buildSectionTitle('🎮 Oyunlar'),
                  _buildGameCards(),
                  _buildSectionTitle('🎬 Uyku Filmleri'),
                  _buildFilmsRow(),
                  _buildSectionTitle('🏆 Oyun Rozetleri'),
                  _buildBadgeRow(state),
                  const SliverToBoxAdapter(child: SizedBox(height: 40)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white70, size: 18),
              ),
            ),
            const SizedBox(width: 14),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Uzay Oyunlar & Filmler',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'Rahatlamak için oyna, izle, keşfet',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCard(RewardsState state) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF2D0B6E), Color(0xFF1A003A)],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.primaryLight.withAlpha(60)),
          ),
          child: Row(
            children: [
              const Text('🚀', style: TextStyle(fontSize: 40)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Toplam Oyun Puanı',
                        style: TextStyle(color: Colors.white70, fontSize: 13)),
                    Text(
                      '${state.totalGameScore}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('İzlenen Film',
                      style: TextStyle(color: Colors.white54, fontSize: 11)),
                  Text(
                    '${state.watchedFilmIds.length} 🎬',
                    style: const TextStyle(
                        color: Colors.amber,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        child: Text(
          title,
          style: const TextStyle(
              color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildGameCards() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          _GameCard(
            emoji: '🌌',
            title: 'Kozmik Nefes',
            subtitle: '4-4-6-2 nefes tekniği • Stres azaltır',
            gradient: const [Color(0xFF3B0764), Color(0xFF1E1035)],
            accentColor: AppColors.primaryLight,
            route: AppStrings.routeBreathingGame,
            badgeName: 'Kozmik Nefes Ustası',
          ),
          const SizedBox(height: 12),
          _GameCard(
            emoji: '⭐',
            title: 'Yıldız Avcısı',
            subtitle: 'Düşen yıldızları yakala • 90 saniye',
            gradient: const [Color(0xFF1A0A3E), Color(0xFF0D0026)],
            accentColor: Colors.amber,
            route: AppStrings.routeStarCatcher,
            badgeName: 'Yıldız Avcısı',
          ),
          const SizedBox(height: 12),
          _GameCard(
            emoji: '🫧',
            title: 'Balon Bahçesi',
            subtitle: '3 dakika • Yavaş yavaş patlat • Stressiz',
            gradient: const [Color(0xFF0A001A), Color(0xFF1E0030)],
            accentColor: Color(0xFF9D64F5),
            route: AppStrings.routeBubblePop,
            badgeName: 'Balon Patlatıcı',
          ),
          const SizedBox(height: 12),
          _GameCard(
            emoji: '🐑',
            title: 'Koyun Sayma',
            subtitle: 'Klasik uyku ritüeli • Oldukça sakin',
            gradient: const [Color(0xFF001020), Color(0xFF001A35)],
            accentColor: Color(0xFF7DD3FC),
            route: AppStrings.routeSheepCounter,
            badgeName: 'Uykulu Koyun',
          ),
          const SizedBox(height: 12),
        ]),
      ),
    );
  }

  Widget _buildFilmsRow() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GestureDetector(
          onTap: () => Get.toNamed(AppStrings.routeSleepFilms),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0A0015), Color(0xFF1E0030)],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.accent.withAlpha(50)),
            ),
            child: Row(
              children: [
                const Text('🎬', style: TextStyle(fontSize: 36)),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Uyku Filmleri',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text(
                          '8 animasyon • Uzay, okyanus, aurora ve daha fazlası',
                          style:
                              TextStyle(color: Colors.white54, fontSize: 12)),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded,
                    color: AppColors.accent.withAlpha(180), size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadgeRow(RewardsState state) {
    final gameBadges = state.gameBadges;
    if (gameBadges.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Oyun oynayarak ve film izleyerek rozet kazan!',
            style: TextStyle(color: Colors.white38, fontSize: 13),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.9,
        ),
        delegate: SliverChildBuilderDelegate(
          (_, i) => _BadgeTile(badge: gameBadges[i]),
          childCount: gameBadges.length,
        ),
      ),
    );
  }
}

// ── Game card ─────────────────────────────────────────────────────────────────

class _GameCard extends StatelessWidget {
  const _GameCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.accentColor,
    required this.route,
    required this.badgeName,
  });

  final String emoji;
  final String title;
  final String subtitle;
  final List<Color> gradient;
  final Color accentColor;
  final String route;
  final String badgeName;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(route),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: accentColor.withAlpha(60)),
          boxShadow: [
            BoxShadow(
              color: accentColor.withAlpha(25),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 44)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: TextStyle(
                          color: Colors.white.withAlpha(140), fontSize: 12)),
                  const SizedBox(height: 10),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: accentColor.withAlpha(30),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Oyna →',
                      style: TextStyle(
                          color: accentColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Badge tile ────────────────────────────────────────────────────────────────

class _BadgeTile extends StatelessWidget {
  const _BadgeTile({required this.badge});
  final BadgeModel badge;

  @override
  Widget build(BuildContext context) {
    final earned = badge.isEarned;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: earned ? AppColors.backgroundCard : AppColors.backgroundDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              earned ? AppColors.primaryLight.withAlpha(100) : Colors.white12,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            badge.emoji,
            style: TextStyle(
                fontSize: 28, color: earned ? null : const Color(0xFF000000)),
          ),
          const SizedBox(height: 6),
          Text(
            badge.titleTr,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: earned ? Colors.white : Colors.white30,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (earned) ...[
            const SizedBox(height: 4),
            const Text('✓',
                style: TextStyle(
                    color: AppColors.success,
                    fontSize: 11,
                    fontWeight: FontWeight.bold)),
          ],
        ],
      ),
    );
  }
}
