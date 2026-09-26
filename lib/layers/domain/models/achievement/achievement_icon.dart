/// Named achievement icons returned by `get_achievements` / unlock events.
///
/// Wire values are Lucide-style names or short aliases (`trophy`, `Zap`).
/// Unknown strings (including module emojis) map to [unknown].
enum AchievementIcon {
  trophy,
  star,
  flame,
  gamepad,
  zap,
  explore,
  brain,
  landmark,
  layers,
  checkCircle,
  clock,
  gavel,
  globe,
  image,
  mapPin,
  rewind,
  swords,
  user,
  compass,
  package,
  repeat,
  sparkles,
  unknown;

  /// Parses a backend `icon` string. Null or blank → [trophy].
  static AchievementIcon fromWire(String? value) {
    final raw = value?.trim();
    if (raw == null || raw.isEmpty) return AchievementIcon.trophy;

    final key = raw.toLowerCase().replaceAll(RegExp(r'[\s_-]+'), '');
    return switch (key) {
      'trophy' || 'emoji_events' || 'award' => AchievementIcon.trophy,
      'star' => AchievementIcon.star,
      'flame' || 'fire' => AchievementIcon.flame,
      'gamepad' || 'sportsesports' => AchievementIcon.gamepad,
      'zap' || 'bolt' => AchievementIcon.zap,
      'explore' => AchievementIcon.explore,
      'brain' => AchievementIcon.brain,
      'landmark' => AchievementIcon.landmark,
      'layers' => AchievementIcon.layers,
      'checkcircle2' || 'checkcircle' => AchievementIcon.checkCircle,
      'clock' => AchievementIcon.clock,
      'gavel' => AchievementIcon.gavel,
      'globe' => AchievementIcon.globe,
      'image' => AchievementIcon.image,
      'mappin' => AchievementIcon.mapPin,
      'rewind' => AchievementIcon.rewind,
      'swords' => AchievementIcon.swords,
      'user' => AchievementIcon.user,
      'compass' => AchievementIcon.compass,
      'package' => AchievementIcon.package,
      'repeat' => AchievementIcon.repeat,
      'sparkles' || 'sparkle' => AchievementIcon.sparkles,
      _ => AchievementIcon.unknown,
    };
  }
}
