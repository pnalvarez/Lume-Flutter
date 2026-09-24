/// Stable Remote Config parameter keys used by the app.
///
/// Keep in sync with Firebase Console → Remote Config for project `lume-51a38`.
abstract final class RemoteConfigKeys {
  /// When `false`, hides the Arcade entry on Games Hub.
  ///
  /// In-app default: `true` (Arcade stays visible until the console turns it off).
  static const arcadeEnabled = 'arcade_enabled';

  /// When `false`, hides Achievements tab / unlock host / unlock toasts.
  ///
  /// In-app default: `false` (ship dark until the console turns it on).
  static const achievementsEnabled = 'achievements_enabled';
}
