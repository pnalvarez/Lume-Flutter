/// Catalog slugs served by the shared visual-choice play path.
///
/// New visual games reuse the same stack by adding their slug here (hub
/// section `visual`) and a [VisualChoiceGameEventPrefix] entry so their
/// analytics log under their own prefix.
abstract final class VisualChoiceGameSlugs {
  /// Galeria do Conhecimento.
  static const knowledgeGallery = 'galeria_conhecimento';

  /// Rostos da História. In the default slug allowlist; tile visibility
  /// still depends on the catalog row being returned by `get_hub_games`.
  /// Logs under the `faces_of_history_*` analytics prefix.
  static const facesOfHistory = 'rostos_historia';
}

/// Questions in one visual-choice hub match.
const visualChoiceGameRoundsPerMatch = 5;

/// Slugs the Arcade draw may serve as a visual-choice round.
///
/// The hub does not use this set: it follows the catalog `visual` section,
/// so any allowlisted visual tile takes the same play path. Arcade only
/// receives slugs, so it needs the known visual ones listed here.
const visualChoiceGameSlugs = <String>{
  VisualChoiceGameSlugs.knowledgeGallery,
  VisualChoiceGameSlugs.facesOfHistory,
};

/// Firebase event-name prefix for a visual-choice game.
///
/// Each visual game logs its own funnel under its prefix, so a new game
/// only needs a slug entry here to get distinct analytics.
enum VisualChoiceGameEventPrefix {
  knowledgeGallery('knowledge_gallery_'),
  facesOfHistory('faces_of_history_');

  const VisualChoiceGameEventPrefix(this.value);

  /// Prefix prepended to every analytics event suffix of the game.
  final String value;

  /// The prefix for [gameSlug]; unknown slugs keep the Galeria prefix.
  static VisualChoiceGameEventPrefix forSlug(String gameSlug) {
    return switch (gameSlug) {
      VisualChoiceGameSlugs.facesOfHistory => facesOfHistory,
      _ => knowledgeGallery,
    };
  }
}

/// Analytics events of the shared visual-choice funnel.
///
/// The full Firebase event name is the game's
/// [VisualChoiceGameEventPrefix] plus the event [suffix], e.g.
/// `faces_of_history_round_started`.
enum VisualChoiceGameAnalyticsEvent {
  roundStarted('round_started'),
  questionAnswered('question_answered'),
  sessionCompleted('session_completed'),
  sessionAbandoned('session_abandoned'),
  imageFailed('image_failed');

  const VisualChoiceGameAnalyticsEvent(this.suffix);

  /// Event-name part after the game's prefix.
  final String suffix;

  /// Full Firebase event name of this event for [gameSlug].
  String eventName(String gameSlug) =>
      '${VisualChoiceGameEventPrefix.forSlug(gameSlug).value}$suffix';
}

/// Play configuration for one visual-choice game.
///
/// Carries the catalog [gameSlug] into the data / match layers (nothing
/// below the hub or the Arcade draw hardcodes a slug). The analytics event
/// names are derived from the slug via [VisualChoiceGameAnalyticsEvent],
/// so each game logs under its own prefix; Galeria do Conhecimento keeps
/// its original `knowledge_gallery_*` wire names.
final class VisualChoiceGameConfig {
  const VisualChoiceGameConfig({
    required this.gameSlug,
    this.roundsPerMatch = visualChoiceGameRoundsPerMatch,
  });

  /// Config for Galeria do Conhecimento, the original visual-choice game.
  static const knowledgeGallery = VisualChoiceGameConfig(
    gameSlug: VisualChoiceGameSlugs.knowledgeGallery,
  );

  /// Config for Rostos da História.
  static const facesOfHistory = VisualChoiceGameConfig(
    gameSlug: VisualChoiceGameSlugs.facesOfHistory,
  );

  /// Config for any visual [gameSlug].
  factory VisualChoiceGameConfig.forSlug(String gameSlug) {
    return switch (gameSlug) {
      VisualChoiceGameSlugs.knowledgeGallery => knowledgeGallery,
      VisualChoiceGameSlugs.facesOfHistory => facesOfHistory,
      _ => VisualChoiceGameConfig(gameSlug: gameSlug),
    };
  }

  /// Whether [gameSlug] is a known visual-choice slug (Arcade draw).
  static bool isVisualGameSlug(String gameSlug) =>
      visualChoiceGameSlugs.contains(gameSlug);

  /// Catalog slug sent to `get_visual_game_items` / `start_game_match`.
  final String gameSlug;

  /// Rounds fetched for one hub match of this game.
  final int roundsPerMatch;

  /// Analytics prefix resolved from [gameSlug].
  VisualChoiceGameEventPrefix get eventPrefix =>
      VisualChoiceGameEventPrefix.forSlug(gameSlug);

  /// Analytics event logged when a play sequence starts.
  String get roundStartedEvent =>
      VisualChoiceGameAnalyticsEvent.roundStarted.eventName(gameSlug);

  /// Analytics event logged after each graded question.
  String get questionAnsweredEvent =>
      VisualChoiceGameAnalyticsEvent.questionAnswered.eventName(gameSlug);

  /// Analytics event logged when a sequence finishes.
  String get sessionCompletedEvent =>
      VisualChoiceGameAnalyticsEvent.sessionCompleted.eventName(gameSlug);

  /// Analytics event logged when a sequence is left early.
  String get sessionAbandonedEvent =>
      VisualChoiceGameAnalyticsEvent.sessionAbandoned.eventName(gameSlug);

  /// Analytics event logged when an artwork image fails to load.
  String get imageFailedEvent =>
      VisualChoiceGameAnalyticsEvent.imageFailed.eventName(gameSlug);

  @override
  bool operator ==(Object other) =>
      other is VisualChoiceGameConfig &&
      other.gameSlug == gameSlug &&
      other.roundsPerMatch == roundsPerMatch;

  @override
  int get hashCode => Object.hash(gameSlug, roundsPerMatch);
}
