import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sleepy_ai/core/constants/app_colors.dart';
import 'package:sleepy_ai/shared/widgets/galaxy_background.dart';

/// Nebula Match – Memory card matching game with cosmic themes.
/// Flip cards to find matching constellation pairs.
class NebulaMatchPage extends StatefulWidget {
  const NebulaMatchPage({super.key});

  @override
  State<NebulaMatchPage> createState() => _NebulaMatchPageState();
}

class _NebulaMatchPageState extends State<NebulaMatchPage>
    with TickerProviderStateMixin {
  static const List<String> _symbols = [
    '🌙',
    '⭐',
    '🪐',
    '☄️',
    '🌌',
    '🔮',
    '💫',
    '🌠',
  ];

  late List<_MatchCard> _cards;
  int? _firstFlipped;
  int? _secondFlipped;
  int _matchesFound = 0;
  int _attempts = 0;
  bool _isChecking = false;
  bool _gameComplete = false;
  late final Stopwatch _timer;
  late final AnimationController _sparkleCtrl;

  @override
  void initState() {
    super.initState();
    _sparkleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    _timer = Stopwatch()..start();
    _initCards();
  }

  void _initCards() {
    // Create pairs
    final pairs = <_MatchCard>[];
    for (int i = 0; i < _symbols.length; i++) {
      pairs.add(_MatchCard(id: i, symbol: _symbols[i]));
      pairs.add(_MatchCard(id: i, symbol: _symbols[i]));
    }
    pairs.shuffle(math.Random());
    _cards = pairs;
    _matchesFound = 0;
    _attempts = 0;
    _firstFlipped = null;
    _secondFlipped = null;
    _gameComplete = false;
    _isChecking = false;
  }

  void _onCardTap(int index) {
    if (_isChecking) return;
    if (_cards[index].isMatched || _cards[index].isFlipped) return;

    setState(() {
      _cards[index].isFlipped = true;

      if (_firstFlipped == null) {
        _firstFlipped = index;
      } else {
        _secondFlipped = index;
        _attempts++;
        _isChecking = true;

        // Check match
        if (_cards[_firstFlipped!].id == _cards[_secondFlipped!].id) {
          _cards[_firstFlipped!].isMatched = true;
          _cards[_secondFlipped!].isMatched = true;
          _matchesFound++;
          _firstFlipped = null;
          _secondFlipped = null;
          _isChecking = false;

          if (_matchesFound == _symbols.length) {
            _gameComplete = true;
            _timer.stop();
          }
        } else {
          // Flip back after delay
          Future.delayed(const Duration(milliseconds: 800), () {
            if (!mounted) return;
            setState(() {
              _cards[_firstFlipped!].isFlipped = false;
              _cards[_secondFlipped!].isFlipped = false;
              _firstFlipped = null;
              _secondFlipped = null;
              _isChecking = false;
            });
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _sparkleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.galaxyDeep,
      body: GalaxyBackground(
        starCount: 140,
        nebulaCount: 3,
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              _buildHud(),
              const SizedBox(height: 16),
              Expanded(child: _buildGrid()),
              if (_gameComplete) _buildWinOverlay(),
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
              'game_nebula_match'.tr,
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
                _initCards();
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
          _StatChip(
              icon: Icons.touch_app_rounded,
              label: 'attempts'.tr,
              value: '$_attempts'),
          _StatChip(
              icon: Icons.check_circle_outline,
              label: 'matches'.tr,
              value: '$_matchesFound/${_symbols.length}'),
          _StatChip(
              icon: Icons.timer_outlined,
              label: 'time'.tr,
              value: '${_timer.elapsed.inSeconds}s'),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: _cards.length,
        itemBuilder: (_, i) => _buildCard(i),
      ),
    );
  }

  Widget _buildCard(int index) {
    final card = _cards[index];
    return GestureDetector(
      onTap: () => _onCardTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: card.isFlipped || card.isMatched
              ? LinearGradient(
                  colors: [
                    card.isMatched
                        ? AppColors.success.withAlpha(40)
                        : AppColors.primary.withAlpha(40),
                    AppColors.backgroundCard,
                  ],
                )
              : null,
          color: card.isFlipped || card.isMatched
              ? null
              : AppColors.backgroundCard.withAlpha(180),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: card.isMatched
                ? AppColors.success.withAlpha(120)
                : card.isFlipped
                    ? AppColors.primary.withAlpha(100)
                    : AppColors.border.withAlpha(60),
            width: card.isMatched ? 2 : 1,
          ),
          boxShadow: card.isMatched
              ? [
                  BoxShadow(
                    color: AppColors.success.withAlpha(30),
                    blurRadius: 10,
                  ),
                ]
              : null,
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: card.isFlipped || card.isMatched
                ? Text(
                    card.symbol,
                    key: ValueKey('${card.id}_shown'),
                    style: TextStyle(
                      fontSize: 32,
                      shadows: card.isMatched
                          ? [
                              const Shadow(
                                color: AppColors.success,
                                blurRadius: 10,
                              ),
                            ]
                          : null,
                    ),
                  )
                : AnimatedBuilder(
                    animation: _sparkleCtrl,
                    builder: (_, __) => Icon(
                      Icons.auto_awesome,
                      key: const ValueKey('hidden'),
                      color: AppColors.primary.withAlpha(
                        (80 +
                                40 *
                                    math.sin(_sparkleCtrl.value * math.pi * 2 +
                                        index))
                            .round()
                            .clamp(0, 255),
                      ),
                      size: 24,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildWinOverlay() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text('🎉', style: TextStyle(fontSize: 40)),
          const SizedBox(height: 8),
          Text(
            'game_won'.tr,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            '${'attempts'.tr}: $_attempts | ${'time'.tr}: ${_timer.elapsed.inSeconds}s',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _MatchCard {
  _MatchCard({required this.id, required this.symbol});
  final int id;
  final String symbol;
  bool isFlipped = false;
  bool isMatched = false;
}

class _StatChip extends StatelessWidget {
  const _StatChip(
      {required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label, value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard.withAlpha(140),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.accent, size: 16),
          const SizedBox(width: 6),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(value,
                  style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700)),
              Text(label,
                  style:
                      const TextStyle(color: AppColors.textMuted, fontSize: 9)),
            ],
          ),
        ],
      ),
    );
  }
}
