import 'package:lume/core/analytics/analytics.dart';

/// Shared Knowledge Gallery funnel logging for hub and Games hosts.
///
/// Owns once-per-session outcome dedupe and once-per-index image-fail dedupe.
final class KnowledgeGalleryAnalytics {
  KnowledgeGalleryAnalytics(this._analytics);

  final IAnalytics _analytics;

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
      AnalyticsEvents.knowledgeGalleryRoundStarted,
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
      AnalyticsEvents.knowledgeGalleryQuestionAnswered,
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
      AnalyticsEvents.knowledgeGalleryImageFailed,
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
      AnalyticsEvents.knowledgeGallerySessionCompleted,
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
      AnalyticsEvents.knowledgeGallerySessionAbandoned,
      parameters: {
        AnalyticsParams.roundIndex: roundIndex,
        AnalyticsParams.roundsTotal: roundsTotal,
        AnalyticsParams.isArcade: isArcade,
      },
    );
  }
}
