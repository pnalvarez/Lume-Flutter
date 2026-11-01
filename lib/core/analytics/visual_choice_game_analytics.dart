import 'package:lume/core/analytics/analytics.dart';
import 'package:lume/layers/domain/models/game/visual_choice_game_config.dart';

/// Shared visual-choice funnel logging for hub and Games hosts.
///
/// Event names come from the active [VisualChoiceGameConfig], so each
/// visual game logs its own funnel. Owns once-per-session outcome dedupe
/// and once-per-index image-fail dedupe.
final class VisualChoiceGameAnalytics {
  VisualChoiceGameAnalytics(
    this._analytics, {
    VisualChoiceGameConfig config = VisualChoiceGameConfig.knowledgeGallery,
  }) : _config = config;

  final IAnalytics _analytics;
  VisualChoiceGameConfig _config;

  /// The config whose event names are currently logged.
  VisualChoiceGameConfig get config => _config;

  /// Logs subsequent events under [config]'s event names.
  ///
  /// Hub, standalone, and Arcade hosts call this when a sequence (or a new
  /// Arcade round) belongs to a different visual game.
  void useConfig(VisualChoiceGameConfig config) {
    _config = config;
  }

  var _touched = false;
  var _outcomeLogged = false;
  final _imageFailedIndexes = <int>{};

  /// Clears session flags (call when a new play sequence starts).
  void reset() {
    _touched = false;
    _outcomeLogged = false;
    _imageFailedIndexes.clear();
  }

  void roundStarted({required int roundsTotal, required bool isArcade}) {
    _touched = true;
    _analytics.logEvent(
      _config.roundStartedEvent,
      parameters: {
        AnalyticsParams.roundsTotal: roundsTotal,
        AnalyticsParams.isArcade: isArcade,
      },
    );
  }

  void questionAnswered({
    required String questionType,
    required bool isCorrect,
    required int roundIndex,
    required bool isArcade,
  }) {
    _touched = true;
    _analytics.logEvent(
      _config.questionAnsweredEvent,
      parameters: {
        AnalyticsParams.questionType: questionType,
        AnalyticsParams.isCorrect: isCorrect ? 1 : 0,
        AnalyticsParams.roundIndex: roundIndex,
        AnalyticsParams.isArcade: isArcade,
      },
    );
  }

  void imageFailed({required int roundIndex, required bool isArcade}) {
    if (!_imageFailedIndexes.add(roundIndex)) return;
    _touched = true;
    _analytics.logEvent(
      _config.imageFailedEvent,
      parameters: {AnalyticsParams.isArcade: isArcade},
    );
  }

  void sessionCompleted({
    required int correctCount,
    required int roundsTotal,
    required bool isArcade,
  }) {
    if (!_touched || _outcomeLogged) return;
    _outcomeLogged = true;
    _analytics.logEvent(
      _config.sessionCompletedEvent,
      parameters: {
        AnalyticsParams.correctCount: correctCount,
        AnalyticsParams.roundsTotal: roundsTotal,
        AnalyticsParams.isArcade: isArcade,
      },
    );
  }

  void sessionAbandoned({
    required int roundIndex,
    required int roundsTotal,
    required bool isArcade,
  }) {
    if (!_touched || _outcomeLogged) return;
    _outcomeLogged = true;
    _analytics.logEvent(
      _config.sessionAbandonedEvent,
      parameters: {
        AnalyticsParams.roundIndex: roundIndex,
        AnalyticsParams.roundsTotal: roundsTotal,
        AnalyticsParams.isArcade: isArcade,
      },
    );
  }
}
