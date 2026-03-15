import 'package:flutter/material.dart';

/// SleepyApp renk paleti — mor/lacivert gradient tema.
/// Tüm UI renkler bu tek yerden yönetilir.
abstract final class AppColors {
  // ── Brand gradients ──────────────────────────────────────────────────────
  static const Color primaryPurple = Color(0xFF6C3DE0);
  static const Color secondaryPurple = Color(0xFF9B59B6);
  static const Color deepPurple = Color(0xFF2D1B69);
  static const Color midnightBlue = Color(0xFF0D0D2B);
  static const Color navyBlue = Color(0xFF1A1A4E);

  // ── Background gradient (koyu, sakin uyku hissi) ─────────────────────────
  static const List<Color> backgroundGradient = [
    Color(0xFF0D0D2B),
    Color(0xFF1A1A4E),
    Color(0xFF2D1B69),
  ];

  // ── Card gradient ─────────────────────────────────────────────────────────
  static const List<Color> cardGradient = [
    Color(0xFF1E1B4B),
    Color(0xFF312E81),
  ];

  // ── Accent colors ─────────────────────────────────────────────────────────
  static const Color accentGold = Color(0xFFFFD700);
  static const Color accentCyan = Color(0xFF00E5FF);
  static const Color accentPink = Color(0xFFE91E8C);
  static const Color accentGreen = Color(0xFF4CAF50);

  // ── Text ──────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0D0);
  static const Color textMuted = Color(0xFF7070A0);

  // ── UI Elements ───────────────────────────────────────────────────────────
  static const Color cardSurface = Color(0xFF1E1B4B);
  static const Color divider = Color(0xFF2D2D60);
  static const Color iconInactive = Color(0xFF5050A0);
  static const Color shimmerBase = Color(0xFF1E1B4B);
  static const Color shimmerHighlight = Color(0xFF2D2B6B);

  // ── Status ────────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // ── Sleep quality score renkleri ─────────────────────────────────────────
  static const Color scoreExcellent = Color(0xFF4CAF50);
  static const Color scoreGood = Color(0xFF8BC34A);
  static const Color scoreFair = Color(0xFFFFC107);
  static const Color scorePoor = Color(0xFFF44336);

  // ── PRO badge ─────────────────────────────────────────────────────────────
  static const List<Color> proGradient = [Color(0xFFFFD700), Color(0xFFFF8C00)];
}
