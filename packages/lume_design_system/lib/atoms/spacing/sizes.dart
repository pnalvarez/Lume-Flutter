/// Fixed UI dimensions for [lume_design_system] (logical pixels).
library;

abstract final class AppSizes {
  AppSizes._();

  // --- Icons ----------------------------------------------------------------
  static const double iconXs = 16;
  static const double iconS = 20;
  static const double iconM = 24;
  static const double iconL = 32;
  static const double iconXl = 40;

  // --- Touch / hit targets (Material minimum 48) ----------------------------
  static const double touchMin = 48;
  static const double touchComfort = 56;

  // --- Avatars --------------------------------------------------------------
  static const double avatarS = 32;
  static const double avatarM = 40;
  static const double avatarL = 48;
  static const double avatarXl = 64;

  // --- Chrome ---------------------------------------------------------------
  static const double appBarHeight = 56;
  static const double bottomNavHeight = 56;
  static const double fabSize = 56;
  static const double dividerThickness = 1;

  // --- Media / illustration wells -------------------------------------------
  static const double mediaWellS = 48;
  static const double mediaWellM = 64;
  static const double mediaWellL = 72;

  /// Connector / divider stroke for vertical timelines.
  static const double connectorWidth = 4;

  /// Default stroke for circular progress rings.
  static const double progressRingStroke = 6;
}
