// ignore_for_file: public_member_api_docs
/// Uygulama genelinde kullanılan spacing, radius ve font boyutları.
/// Magic number kullanımını engellemek için tüm sayısal sabitler burada.
abstract final class AppSizes {
  // ── Spacing ─────────────────────────────────────────────────────────
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;

  // ── Border Radius ────────────────────────────────────────────────────
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
  static const double radiusXxl = 24.0;
  static const double radiusFull = 100.0;

  // ── Font Sizes ───────────────────────────────────────────────────────
  static const double fontXs = 10.0;
  static const double fontSm = 12.0;
  static const double fontMd = 14.0;
  static const double fontLg = 16.0;
  static const double fontXl = 18.0;
  static const double fontXxl = 22.0;
  static const double fontTitle = 28.0;
  static const double fontDisplay = 36.0;
  static const double fontHero = 48.0;

  // ── Icon Sizes ───────────────────────────────────────────────────────
  static const double iconSm = 16.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 48.0;

  // ── Component Heights ────────────────────────────────────────────────
  static const double buttonHeight = 52.0;
  static const double buttonHeightSm = 40.0;
  static const double inputHeight = 52.0;
  static const double appBarHeight = 60.0;
  static const double bottomNavHeight = 68.0;
  static const double cardMinHeight = 100.0;
  static const double metricCardHeight = 120.0;
  static const double soundCardSize = 100.0;
  static const double badgeCardSize = 90.0;

  // ── Avatar / Image ───────────────────────────────────────────────────
  static const double avatarSm = 32.0;
  static const double avatarMd = 48.0;
  static const double avatarLg = 80.0;

  // ── Elevation ────────────────────────────────────────────────────────
  static const double elevationNone = 0.0;
  static const double elevationSm = 2.0;
  static const double elevationMd = 4.0;
  static const double elevationLg = 8.0;

  // ── Padding presets ──────────────────────────────────────────────────
  static const double pagePaddingH = 20.0;
  static const double pagePaddingV = 24.0;

  AppSizes._();
}
