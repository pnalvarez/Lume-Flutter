/// Stable cache keys for data-source payloads.
abstract final class CacheKeys {
  static const profile = 'cache:profile';
  static const categoryPreferences = 'cache:category_preferences';
  static const trailBootstrap = 'cache:trail_bootstrap';
  static const trailProgress = 'cache:trail_progress';
  static const gameTrails = 'cache:game_trails';

  static String submoduleGames(int submoduleId) =>
      'cache:submodule_games:$submoduleId';
}
