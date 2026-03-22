// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';

/// SleepyApp renk paleti - mor gradient tema.
/// Tum UI renkleri bu tek siniftan yonetilir.
abstract final class AppColors {
  // Primary Purple Palette
  static const Color primary = Color(0xFF7C3AED);
  static const Color primaryLight = Color(0xFF9D64F5);
  static const Color primaryDark = Color(0xFF5B21B6);
  static const Color primaryDeep = Color(0xFF3B0764);

  // Accent
  static const Color accent = Color(0xFFEC4899);
  static const Color accentLight = Color(0xFFF472B6);
  static const Color accentBlue = Color(0xFF6366F1);
  static const Color accentTeal = Color(0xFF14B8A6);
  static const Color accentGold = Color(0xFFFFD700);

  // Background
  static const Color backgroundDark = Color(0xFF0A0118);
  static const Color backgroundMid = Color(0xFF130826);
  static const Color backgroundCard = Color(0xFF1E1035);
  static const Color backgroundCardLight = Color(0xFF2A1850);
  static const Color surface = Color(0xFF1E1035);
  static const Color surfaceVariant = Color(0xFF2D1A5E);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF7C3AED), Color(0xFFEC4899)],
  );
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF060012), // very dark midnight purple
      Color(0xFF1A0845), // deep electric purple
      Color(0xFF2D0A6B), // rich violet peak
      Color(0xFF12042E), // dark indigo base
    ],
    stops: [0.0, 0.35, 0.65, 1.0],
  );
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2A1850), Color(0xFF1E1035)],
  );
  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
  );
  static const LinearGradient proGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
  );
  static const LinearGradient sleepScoreGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6366F1), Color(0xFF7C3AED), Color(0xFFEC4899)],
  );
  static const LinearGradient nightSkyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0A0118), Color(0xFF1A0533), Color(0xFF2D0A6B)],
  );

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB8A9D9);
  static const Color textMuted = Color(0xFF6B5B93);
  static const Color textDisabled = Color(0xFF3D2E6B);

  // Status
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Sleep Score
  static const Color scorePoor = Color(0xFFEF4444);
  static const Color scoreFair = Color(0xFFF59E0B);
  static const Color scoreGood = Color(0xFF10B981);
  static const Color scoreExcellent = Color(0xFF7C3AED);

  // Borders
  static const Color divider = Color(0xFF2D1A5E);
  static const Color border = Color(0xFF3D2E6B);
  static const Color borderLight = Color(0xFF4A3580);

  // Overlay
  static const Color overlayDark = Color(0xCC000000);
  static const Color overlayPurple = Color(0x997C3AED);

  // Badges
  static const Color badgeGold = Color(0xFFFFD700);
  static const Color badgeSilver = Color(0xFFC0C0C0);
  static const Color badgeBronze = Color(0xFFCD7F32);
  static const Color badgeLocked = Color(0xFF3D2E6B);

  // Sound Category Colors
  static const Color soundRain = Color(0xFF3B82F6);
  static const Color soundForest = Color(0xFF10B981);
  static const Color soundOcean = Color(0xFF0EA5E9);
  static const Color soundFire = Color(0xFFEF4444);
  static const Color soundWind = Color(0xFF8B5CF6);
  static const Color soundBirds = Color(0xFF84CC16);
  static const Color soundLullaby = Color(0xFFF472B6);
  static const Color soundMedieval = Color(0xFFCD7F32);
  static const Color soundInstrument = Color(0xFF14B8A6);

  // Misc
  static const Color starYellow = Color(0xFFFDE68A);
  static const Color moonWhite = Color(0xFFE2D9F3);
  static const Color shimmerBase = Color(0xFF1E1035);
  static const Color shimmerHighlight = Color(0xFF2D1A5E);
  static const Color iconInactive = Color(0xFF5050A0);
  static const Color transparent = Colors.transparent;

  // Galaxy Theme
  static const Color galaxyCore = Color(0xFF4A0E8F);
  static const Color galaxyNebula = Color(0xFF8B5CF6);
  static const Color galaxyStardust = Color(0xFFD8B4FE);
  static const Color galaxyDeep = Color(0xFF0F0525);
  static const Color galaxyVoid = Color(0xFF06001A);
  static const Color cosmicPink = Color(0xFFFF6FD8);
  static const Color cosmicBlue = Color(0xFF3813C2);
  static const Color cosmicTeal = Color(0xFF00C9FF);
  static const Color astralGold = Color(0xFFFFE066);
  static const Color astralSilver = Color(0xFFB8C6DB);

  // Zodiac Sign Colors
  static const Color zodiacAries = Color(0xFFFF4444);
  static const Color zodiacTaurus = Color(0xFF4CAF50);
  static const Color zodiacGemini = Color(0xFFFFEB3B);
  static const Color zodiacCancer = Color(0xFFC0C0C0);
  static const Color zodiacLeo = Color(0xFFFF9800);
  static const Color zodiacVirgo = Color(0xFF8D6E63);
  static const Color zodiacLibra = Color(0xFFE91E63);
  static const Color zodiacScorpio = Color(0xFF9C27B0);
  static const Color zodiacSagittarius = Color(0xFF2196F3);
  static const Color zodiacCapricorn = Color(0xFF424242);
  static const Color zodiacAquarius = Color(0xFF00BCD4);
  static const Color zodiacPisces = Color(0xFF7C4DFF);

  // Galaxy Gradients
  static const LinearGradient galaxyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0F0525),
      Color(0xFF1A0845),
      Color(0xFF4A0E8F),
      Color(0xFF1A0845),
      Color(0xFF0F0525),
    ],
    stops: [0.0, 0.25, 0.5, 0.75, 1.0],
  );

  static const LinearGradient astralGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF0A0020),
      Color(0xFF1A0845),
      Color(0xFF3B0764),
      Color(0xFF7C3AED),
    ],
  );

  static const RadialGradient nebulaGradient = RadialGradient(
    center: Alignment.center,
    radius: 1.2,
    colors: [
      Color(0x66FF6FD8),
      Color(0x333813C2),
      Color(0x00000000),
    ],
  );

  AppColors._();
}
