import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sleepy_ai/core/constants/app_colors.dart';
import 'package:sleepy_ai/shared/widgets/galaxy_background.dart';

/// Dream Labyrinth – Navigate through a procedurally generated
/// dream maze using tilt/swipe. Collect moon fragments to unlock the exit.
class DreamLabyrinthPage extends StatefulWidget {
  const DreamLabyrinthPage({super.key});

  @override
  State<DreamLabyrinthPage> createState() => _DreamLabyrinthPageState();
}

class _DreamLabyrinthPageState extends State<DreamLabyrinthPage>
    with TickerProviderStateMixin {
  static const int _gridSize = 9;
  late final AnimationController _glowCtrl;
  late final AnimationController _particleCtrl;
  late List<List<bool>> _walls; // true = wall
  late int _playerX, _playerY;
  late int _exitX, _exitY;
  late List<_MoonFragment> _fragments;
  int _collected = 0;
  int _totalFragments = 5;
  bool _gameWon = false;
  int _moveCount = 0;
  late final Stopwatch _timer;

  @override
  void initState() {
    super.initState();
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _particleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    _timer = Stopwatch()..start();
    _generateMaze();
  }

  void _generateMaze() {
    final rng = math.Random();
    _walls = List.generate(
      _gridSize,
      (y) => List.generate(_gridSize, (x) {
        // Borders are always walls
        if (x == 0 || y == 0 || x == _gridSize - 1 || y == _gridSize - 1) {
          return true;
        }
        // Interior: ~30% walls for a navigable maze
        return rng.nextDouble() < 0.3;
      }),
    );

    // Ensure start and exit are open
    _playerX = 1;
    _playerY = 1;
    _walls[1][1] = false;
    _exitX = _gridSize - 2;
    _exitY = _gridSize - 2;
    _walls[_exitY][_exitX] = false;

    // Ensure a clear path exists (simple corridor carving)
    int cx = 1, cy = 1;
    while (cx != _exitX || cy != _exitY) {
      if (cx < _exitX) {
        cx++;
      } else if (cy < _exitY) {
        cy++;
      }
      _walls[cy][cx] = false;
    }

    // Place moon fragments
    _fragments = [];
    int placed = 0;
    while (placed < _totalFragments) {
      final fx = 1 + rng.nextInt(_gridSize - 2);
      final fy = 1 + rng.nextInt(_gridSize - 2);
      if (!_walls[fy][fx] &&
          !(fx == _playerX && fy == _playerY) &&
          !(fx == _exitX && fy == _exitY) &&
          !_fragments.any((f) => f.x == fx && f.y == fy)) {
        _fragments.add(_MoonFragment(x: fx, y: fy));
        placed++;
      }
    }

    _collected = 0;
    _gameWon = false;
    _moveCount = 0;
  }

  void _move(int dx, int dy) {
    if (_gameWon) return;
    final nx = _playerX + dx;
    final ny = _playerY + dy;

    if (nx < 0 || nx >= _gridSize || ny < 0 || ny >= _gridSize) return;
    if (_walls[ny][nx]) return;

    setState(() {
      _playerX = nx;
      _playerY = ny;
      _moveCount++;

      // Check fragment collection
      final frag = _fragments.firstWhereOrNull(
        (f) => f.x == nx && f.y == ny && !f.collected,
      );
      if (frag != null) {
        frag.collected = true;
        _collected++;
      }

      // Check exit
      if (nx == _exitX && ny == _exitY && _collected >= _totalFragments) {
        _gameWon = true;
        _timer.stop();
      }
    });
  }

  @override
  void dispose() {
    _glowCtrl.dispose();
    _particleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.galaxyDeep,
      body: GalaxyBackground(
        starCount: 120,
        nebulaCount: 3,
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              _buildHud(),
              const SizedBox(height: 8),
              Expanded(child: _buildMazeGrid()),
              _buildControls(),
              const SizedBox(height: 16),
            ],
          ),
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
              'game_dream_labyrinth'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _generateMaze();
                _timer.reset();
                _timer.start();
              });
            },
            icon: const Icon(Icons.refresh_rounded,
                color: AppColors.textSecondary),
          ),
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
          _HudItem(
              icon: Icons.nightlight_round,
              value: '$_collected/$_totalFragments',
              label: 'moons'.tr),
          _HudItem(
              icon: Icons.swap_calls_rounded,
              value: '$_moveCount',
              label: 'moves'.tr),
          _HudItem(
            icon: Icons.timer_outlined,
            value: '${_timer.elapsed.inSeconds}s',
            label: 'time'.tr,
          ),
        ],
      ),
    );
  }

  Widget _buildMazeGrid() {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: LayoutBuilder(
          builder: (_, constraints) {
            final cellSize = constraints.maxWidth / _gridSize;
            return AnimatedBuilder(
              animation: _glowCtrl,
              builder: (_, __) => CustomPaint(
                painter: _MazePainter(
                  walls: _walls,
                  playerX: _playerX,
                  playerY: _playerY,
                  exitX: _exitX,
                  exitY: _exitY,
                  fragments: _fragments,
                  cellSize: cellSize,
                  glowT: _glowCtrl.value,
                  gameWon: _gameWon,
                  collected: _collected,
                  totalFragments: _totalFragments,
                ),
                size: Size(constraints.maxWidth, constraints.maxWidth),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildControls() {
    if (_gameWon) {
      return Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              'game_won'.tr,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              '${'moves'.tr}: $_moveCount | ${'time'.tr}: ${_timer.elapsed.inSeconds}s',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: Column(
        children: [
          _DpadButton(icon: Icons.keyboard_arrow_up, onTap: () => _move(0, -1)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _DpadButton(
                  icon: Icons.keyboard_arrow_left, onTap: () => _move(-1, 0)),
              const SizedBox(width: 50),
              _DpadButton(
                  icon: Icons.keyboard_arrow_right, onTap: () => _move(1, 0)),
            ],
          ),
          _DpadButton(
              icon: Icons.keyboard_arrow_down, onTap: () => _move(0, 1)),
        ],
      ),
    );
  }
}

class _MoonFragment {
  _MoonFragment({required this.x, required this.y});
  final int x, y;
  bool collected = false;
}

class _MazePainter extends CustomPainter {
  _MazePainter({
    required this.walls,
    required this.playerX,
    required this.playerY,
    required this.exitX,
    required this.exitY,
    required this.fragments,
    required this.cellSize,
    required this.glowT,
    required this.gameWon,
    required this.collected,
    required this.totalFragments,
  });

  final List<List<bool>> walls;
  final int playerX, playerY, exitX, exitY;
  final List<_MoonFragment> fragments;
  final double cellSize, glowT;
  final bool gameWon;
  final int collected, totalFragments;

  @override
  void paint(Canvas canvas, Size size) {
    final gridSize = walls.length;

    // Draw walls
    final wallPaint = Paint()..color = AppColors.galaxyNebula.withAlpha(60);
    final pathPaint = Paint()..color = AppColors.galaxyDeep.withAlpha(200);

    for (int y = 0; y < gridSize; y++) {
      for (int x = 0; x < gridSize; x++) {
        final rect = Rect.fromLTWH(
          x * cellSize,
          y * cellSize,
          cellSize,
          cellSize,
        );
        canvas.drawRect(rect, walls[y][x] ? wallPaint : pathPaint);

        // Grid lines
        final linePaint = Paint()
          ..color = AppColors.border.withAlpha(20)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5;
        canvas.drawRect(rect, linePaint);
      }
    }

    // Draw fragments
    for (final f in fragments) {
      if (f.collected) continue;
      final cx = f.x * cellSize + cellSize / 2;
      final cy = f.y * cellSize + cellSize / 2;
      final r = cellSize * 0.25;

      // Glow
      final glowPaint = Paint()
        ..color = AppColors.accentGold.withAlpha((40 + 30 * glowT).round())
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(Offset(cx, cy), r * 2, glowPaint);

      // Moon
      final moonPaint = Paint()..color = AppColors.accentGold;
      canvas.drawCircle(Offset(cx, cy), r, moonPaint);
    }

    // Draw exit
    if (collected >= totalFragments) {
      final ex = exitX * cellSize + cellSize / 2;
      final ey = exitY * cellSize + cellSize / 2;
      final exitGlow = Paint()
        ..color = AppColors.success.withAlpha((60 + 40 * glowT).round())
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
      canvas.drawCircle(Offset(ex, ey), cellSize * 0.4, exitGlow);

      final exitPaint = Paint()..color = AppColors.success;
      canvas.drawCircle(Offset(ex, ey), cellSize * 0.25, exitPaint);
    } else {
      // Locked exit
      final ex = exitX * cellSize + cellSize / 2;
      final ey = exitY * cellSize + cellSize / 2;
      final lockedPaint = Paint()
        ..color = AppColors.error.withAlpha(80)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawCircle(Offset(ex, ey), cellSize * 0.25, lockedPaint);
    }

    // Draw player
    final px = playerX * cellSize + cellSize / 2;
    final py = playerY * cellSize + cellSize / 2;
    final playerGlow = Paint()
      ..color = AppColors.primary.withAlpha((40 + 30 * glowT).round())
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(Offset(px, py), cellSize * 0.4, playerGlow);

    final playerPaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFF9D64F5), Color(0xFF7C3AED)],
      ).createShader(
        Rect.fromCircle(center: Offset(px, py), radius: cellSize * 0.3),
      );
    canvas.drawCircle(Offset(px, py), cellSize * 0.3, playerPaint);

    // Inner white dot
    canvas.drawCircle(
      Offset(px, py),
      cellSize * 0.08,
      Paint()..color = Colors.white.withAlpha(200),
    );
  }

  @override
  bool shouldRepaint(_MazePainter old) => true;
}

class _DpadButton extends StatelessWidget {
  const _DpadButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.backgroundCard.withAlpha(150),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.primary.withAlpha(60)),
        ),
        child: Icon(icon, color: AppColors.textPrimary, size: 32),
      ),
    );
  }
}

class _HudItem extends StatelessWidget {
  const _HudItem(
      {required this.icon, required this.value, required this.label});
  final IconData icon;
  final String value, label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.accent, size: 20),
        Text(value,
            style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700)),
        Text(label,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
      ],
    );
  }
}
