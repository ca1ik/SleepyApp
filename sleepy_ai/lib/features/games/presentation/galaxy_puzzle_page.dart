import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sleepy_ai/core/constants/app_colors.dart';
import 'package:sleepy_ai/shared/widgets/galaxy_background.dart';

/// Galaxy Puzzle – Sliding tile puzzle with cosmic nebula imagery.
/// Rearrange tiles to form the complete galaxy image.
class GalaxyPuzzlePage extends StatefulWidget {
  const GalaxyPuzzlePage({super.key});

  @override
  State<GalaxyPuzzlePage> createState() => _GalaxyPuzzlePageState();
}

class _GalaxyPuzzlePageState extends State<GalaxyPuzzlePage>
    with SingleTickerProviderStateMixin {
  static const int _size = 4; // 4x4 grid
  late List<int> _tiles; // 0 = empty, 1-15 = tiles
  int _moves = 0;
  bool _solved = false;
  late final AnimationController _glowCtrl;
  late final Stopwatch _timer;

  // Each tile has a unique nebula color
  static const List<Color> _tileColors = [
    Color(0xFF7C3AED),
    Color(0xFF6366F1),
    Color(0xFFEC4899),
    Color(0xFF14B8A6),
    Color(0xFF3B82F6),
    Color(0xFF8B5CF6),
    Color(0xFFFF6FD8),
    Color(0xFF10B981),
    Color(0xFFF59E0B),
    Color(0xFF9D64F5),
    Color(0xFF0EA5E9),
    Color(0xFFE11D48),
    Color(0xFF84CC16),
    Color(0xFFFF9800),
    Color(0xFF00BCD4),
  ];

  @override
  void initState() {
    super.initState();
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _timer = Stopwatch()..start();
    _initPuzzle();
  }

  void _initPuzzle() {
    _tiles = List.generate(_size * _size, (i) => i);
    // Shuffle with valid moves to ensure solvability
    final rng = math.Random();
    for (int i = 0; i < 200; i++) {
      final emptyIdx = _tiles.indexOf(0);
      final neighbors = _getMovableNeighbors(emptyIdx);
      final pick = neighbors[rng.nextInt(neighbors.length)];
      _tiles[emptyIdx] = _tiles[pick];
      _tiles[pick] = 0;
    }
    _moves = 0;
    _solved = false;
  }

  List<int> _getMovableNeighbors(int emptyIdx) {
    final row = emptyIdx ~/ _size;
    final col = emptyIdx % _size;
    final neighbors = <int>[];
    if (row > 0) neighbors.add((row - 1) * _size + col);
    if (row < _size - 1) neighbors.add((row + 1) * _size + col);
    if (col > 0) neighbors.add(row * _size + col - 1);
    if (col < _size - 1) neighbors.add(row * _size + col + 1);
    return neighbors;
  }

  void _onTileTap(int index) {
    if (_solved) return;
    final emptyIdx = _tiles.indexOf(0);
    final neighbors = _getMovableNeighbors(emptyIdx);
    if (!neighbors.contains(index)) return;

    setState(() {
      _tiles[emptyIdx] = _tiles[index];
      _tiles[index] = 0;
      _moves++;

      // Check if solved
      bool isSolved = true;
      for (int i = 0; i < _tiles.length; i++) {
        if (_tiles[i] != i) {
          isSolved = false;
          break;
        }
      }
      if (isSolved) {
        _solved = true;
        _timer.stop();
      }
    });
  }

  @override
  void dispose() {
    _glowCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.galaxyDeep,
      body: GalaxyBackground(
        starCount: 130,
        nebulaCount: 4,
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              _buildHud(),
              const SizedBox(height: 20),
              Expanded(child: _buildPuzzleGrid()),
              if (_solved) _buildWinBanner(),
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
              'game_galaxy_puzzle'.tr,
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
                _initPuzzle();
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
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              const Icon(Icons.swap_calls_rounded,
                  color: AppColors.accent, size: 20),
              Text('$_moves',
                  style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w700)),
              Text('moves'.tr,
                  style: const TextStyle(
                      color: AppColors.textMuted, fontSize: 11)),
            ],
          ),
          Column(
            children: [
              const Icon(Icons.timer_outlined,
                  color: AppColors.accentTeal, size: 20),
              Text('${_timer.elapsed.inSeconds}s',
                  style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w700)),
              Text('time'.tr,
                  style: const TextStyle(
                      color: AppColors.textMuted, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPuzzleGrid() {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: AnimatedBuilder(
            animation: _glowCtrl,
            builder: (_, __) => GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _size,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
              ),
              itemCount: _size * _size,
              itemBuilder: (_, i) => _buildTile(i),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTile(int index) {
    final value = _tiles[index];
    if (value == 0) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.galaxyVoid.withAlpha(100),
          borderRadius: BorderRadius.circular(10),
        ),
      );
    }

    final isCorrect = _tiles[index] == index;
    final color = _tileColors[value - 1];

    return GestureDetector(
      onTap: () => _onTileTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              color.withAlpha(180),
              color.withAlpha(100),
            ],
          ),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isCorrect
                ? AppColors.success.withAlpha(150)
                : color.withAlpha(80),
            width: isCorrect ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withAlpha((20 + 15 * _glowCtrl.value).round()),
              blurRadius: 8,
            ),
          ],
        ),
        child: Center(
          child: Text(
            '$value',
            style: TextStyle(
              color: Colors.white.withAlpha(220),
              fontSize: 22,
              fontWeight: FontWeight.w800,
              shadows: [
                Shadow(color: color, blurRadius: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWinBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text('🌌', style: TextStyle(fontSize: 40)),
          Text(
            'game_won'.tr,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            '${'moves'.tr}: $_moves | ${'time'.tr}: ${_timer.elapsed.inSeconds}s',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
