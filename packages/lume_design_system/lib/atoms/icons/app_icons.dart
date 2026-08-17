/// SVG icon path constants for [lume_design_system].
///
/// Paths are relative to the package asset bundle.
/// Load with: `SvgPicture.asset(AppIcons.star, package: 'lume_design_system')`.
///
/// Names describe the glyph, not a product feature.
library;

abstract final class AppIcons {
  AppIcons._();

  static const String _base = 'assets/icons';

  // --- Navigation glyphs ---------------------------------------------------
  static const String home = '$_base/home.svg';
  static const String path = '$_base/path.svg';
  static const String gallery = '$_base/gallery.svg';
  static const String profile = '$_base/profile.svg';

  // --- Decorative glyphs ---------------------------------------------------
  static const String star = '$_base/star.svg';
  static const String bolt = '$_base/bolt.svg';
  static const String box = '$_base/box.svg';
  static const String sparkle = '$_base/sparkle.svg';
  static const String flame = '$_base/flame.svg';
  static const String trophy = '$_base/trophy.svg';

  // --- Status glyphs -------------------------------------------------------
  static const String statusNew = '$_base/status_new.svg';
  static const String statusActive = '$_base/status_active.svg';
  static const String statusRefresh = '$_base/status_refresh.svg';
  static const String statusDone = '$_base/status_done.svg';
  static const String statusAlert = '$_base/status_alert.svg';

  // --- Actions -------------------------------------------------------------
  static const String check = '$_base/check.svg';
  static const String close = '$_base/close.svg';
  static const String back = '$_base/back.svg';
  static const String forward = '$_base/forward.svg';
  static const String settings = '$_base/settings.svg';
  static const String search = '$_base/search.svg';
  static const String lock = '$_base/lock.svg';
}
