import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sleepy_ai/core/constants/app_colors.dart';
import 'package:sleepy_ai/features/zodiac/bloc/zodiac_bloc.dart';
import 'package:sleepy_ai/features/zodiac/bloc/zodiac_event.dart';
import 'package:sleepy_ai/features/zodiac/bloc/zodiac_state.dart';
import 'package:sleepy_ai/features/zodiac/domain/zodiac_models.dart';
import 'package:sleepy_ai/shared/widgets/galaxy_background.dart';
import 'package:sleepy_ai/shared/widgets/cosmic_particles.dart';

class ZodiacCompatibilityPage extends StatefulWidget {
  const ZodiacCompatibilityPage({super.key});

  @override
  State<ZodiacCompatibilityPage> createState() =>
      _ZodiacCompatibilityPageState();
}

class _ZodiacCompatibilityPageState extends State<ZodiacCompatibilityPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseCtrl;
  ZodiacSign? _partnerSign;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Load all compatibilities for the selected sign
    final bloc = context.read<ZodiacBloc>();
    if (bloc.state.selectedSign != null) {
      bloc.add(ZodiacLoadAllCompatibilities(bloc.state.selectedSign!));
    }
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.galaxyDeep,
      body: GalaxyBackground(
        starCount: 150,
        nebulaCount: 3,
        child: Stack(
          children: [
            const CosmicParticleOverlay(
              particleCount: 40,
              baseColor: Color(0xFFEC4899),
              secondaryColor: Color(0xFF6366F1),
              speed: 0.5,
            ),
            SafeArea(
              child: Column(
                children: [
                  _buildAppBar(),
                  Expanded(
                    child: BlocBuilder<ZodiacBloc, ZodiacState>(
                      builder: (_, state) {
                        if (state.selectedSign == null) {
                          return const Center(
                            child: Text('No sign selected',
                                style:
                                    TextStyle(color: AppColors.textSecondary)),
                          );
                        }
                        return _buildContent(state);
                      },
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
              'zodiac_compatibility'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildContent(ZodiacState state) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Sign selector for partner
          _buildPartnerSelector(state),
          const SizedBox(height: 20),

          // Specific comparison
          if (_partnerSign != null) ...[
            _buildComparisonResult(state),
            const SizedBox(height: 24),
          ],

          // All compatibilities ranking
          _buildAllCompatibilities(state),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildPartnerSelector(ZodiacState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard.withAlpha(120),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border.withAlpha(50)),
      ),
      child: Column(
        children: [
          Text(
            'select_partner_sign'.tr,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: ZodiacSign.values
                .where((s) => s != state.selectedSign)
                .map((sign) => GestureDetector(
                      onTap: () {
                        setState(() => _partnerSign = sign);
                        context.read<ZodiacBloc>().add(
                              ZodiacCalculateCompatibility(
                                state.selectedSign!,
                                sign,
                              ),
                            );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _partnerSign == sign
                              ? sign.color.withAlpha(50)
                              : AppColors.backgroundCard,
                          border: Border.all(
                            color: _partnerSign == sign
                                ? sign.color
                                : AppColors.border.withAlpha(60),
                            width: _partnerSign == sign ? 2 : 1,
                          ),
                        ),
                        child: Center(
                          child: Text(sign.symbol,
                              style: const TextStyle(fontSize: 22)),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonResult(ZodiacState state) {
    final compat = state.compatibility;
    if (compat == null) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _pulseCtrl,
      builder: (_, __) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              compat.sign1.color.withAlpha(25),
              AppColors.backgroundCard.withAlpha(140),
              compat.sign2.color.withAlpha(25),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Color.lerp(
              compat.sign1.color,
              compat.sign2.color,
              _pulseCtrl.value,
            )!
                .withAlpha(80),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Color.lerp(
                compat.sign1.color,
                compat.sign2.color,
                _pulseCtrl.value,
              )!
                  .withAlpha(20),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            // Signs face-off
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _SignBubble(sign: compat.sign1),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    '${compat.overallScore}%',
                    style: TextStyle(
                      color: _scoreColor(compat.overallScore),
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                _SignBubble(sign: compat.sign2),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              compat.levelKey.tr,
              style: TextStyle(
                color: _scoreColor(compat.overallScore),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),

            // Sub-scores
            _ScoreBar(
                label: 'love'.tr,
                score: compat.loveScore,
                color: AppColors.accent),
            _ScoreBar(
                label: 'friendship'.tr,
                score: compat.friendshipScore,
                color: AppColors.accentTeal),
            _ScoreBar(
                label: 'sleep_harmony'.tr,
                score: compat.sleepHarmonyScore,
                color: AppColors.primary),
            _ScoreBar(
                label: 'astral_connection'.tr,
                score: compat.astralConnectionScore,
                color: AppColors.accentGold),
          ],
        ),
      ),
    );
  }

  Widget _buildAllCompatibilities(ZodiacState state) {
    if (state.allCompatibilities.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'all_compatibilities'.tr,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        ...state.allCompatibilities.map((c) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.backgroundCard.withAlpha(100),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border.withAlpha(40)),
                ),
                child: Row(
                  children: [
                    Text(c.sign2.symbol, style: const TextStyle(fontSize: 24)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c.sign2.nameKey.tr,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            c.levelKey.tr,
                            style: TextStyle(
                              color: _scoreColor(c.overallScore),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${c.overallScore}%',
                      style: TextStyle(
                        color: _scoreColor(c.overallScore),
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  Color _scoreColor(int score) {
    if (score >= 80) return AppColors.success;
    if (score >= 60) return AppColors.accentTeal;
    if (score >= 40) return AppColors.warning;
    return AppColors.error;
  }
}

class _SignBubble extends StatelessWidget {
  const _SignBubble({required this.sign});
  final ZodiacSign sign;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: sign.color.withAlpha(30),
        border: Border.all(color: sign.color.withAlpha(80), width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(sign.symbol, style: const TextStyle(fontSize: 24)),
          Text(
            sign.nameKey.tr,
            style: TextStyle(
                color: sign.color, fontSize: 8, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _ScoreBar extends StatelessWidget {
  const _ScoreBar({
    required this.label,
    required this.score,
    required this.color,
  });

  final String label;
  final int score;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundCard,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: score / 100,
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color.withAlpha(150), color],
                      ),
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: color.withAlpha(40),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$score',
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
