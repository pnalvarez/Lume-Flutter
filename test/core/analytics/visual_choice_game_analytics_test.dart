import 'package:flutter_test/flutter_test.dart';
import 'package:lume/core/analytics/analytics.dart';
import 'package:lume/core/analytics/visual_choice_game_analytics.dart';
import 'package:lume/layers/domain/models/game/visual_choice_game_config.dart';

import '../../helpers/fake_analytics.dart';

void main() {
  late FakeAnalytics analytics;
  late VisualChoiceGameAnalytics visual;

  setUp(() {
    analytics = FakeAnalytics();
    visual = VisualChoiceGameAnalytics(analytics);
  });

  test('roundStarted then sessionCompleted logs once with is_arcade', () {
    visual.roundStarted(roundsTotal: 5, isArcade: true);
    visual.sessionCompleted(correctCount: 3, roundsTotal: 5, isArcade: true);
    visual.sessionCompleted(correctCount: 3, roundsTotal: 5, isArcade: true);

    expect(
      analytics.parametersFor(AnalyticsEvents.visualChoiceGameRoundStarted),
      {AnalyticsParams.roundsTotal: 5, AnalyticsParams.isArcade: true},
    );
    expect(
      analytics.events
          .where(
            (e) => e.name == AnalyticsEvents.visualChoiceGameSessionCompleted,
          )
          .length,
      1,
    );
    expect(
      analytics.parametersFor(AnalyticsEvents.visualChoiceGameSessionCompleted),
      {
        AnalyticsParams.correctCount: 3,
        AnalyticsParams.roundsTotal: 5,
        AnalyticsParams.isArcade: true,
      },
    );
  });

  test('sessionAbandoned without a prior visual touch is a no-op', () {
    visual.sessionAbandoned(roundIndex: 0, roundsTotal: 2, isArcade: false);
    expect(
      analytics.hasEvent(AnalyticsEvents.visualChoiceGameSessionAbandoned),
      isFalse,
    );
  });

  test('imageFailed dedupes per round index', () {
    visual.imageFailed(roundIndex: 0, isArcade: false);
    visual.imageFailed(roundIndex: 0, isArcade: false);
    visual.imageFailed(roundIndex: 1, isArcade: false);

    expect(
      analytics.events
          .where((e) => e.name == AnalyticsEvents.visualChoiceGameImageFailed)
          .length,
      2,
    );
  });

  test('reset clears outcome and image-fail dedupe', () {
    visual
      ..roundStarted(roundsTotal: 1, isArcade: false)
      ..sessionAbandoned(roundIndex: 0, roundsTotal: 1, isArcade: false)
      ..imageFailed(roundIndex: 0, isArcade: false)
      ..reset()
      ..roundStarted(roundsTotal: 1, isArcade: true)
      ..sessionCompleted(correctCount: 1, roundsTotal: 1, isArcade: true)
      ..imageFailed(roundIndex: 0, isArcade: true);

    expect(
      analytics.events
          .where(
            (e) => e.name == AnalyticsEvents.visualChoiceGameSessionAbandoned,
          )
          .length,
      1,
    );
    expect(
      analytics.events
          .where(
            (e) => e.name == AnalyticsEvents.visualChoiceGameSessionCompleted,
          )
          .length,
      1,
    );
    expect(
      analytics.events
          .where((e) => e.name == AnalyticsEvents.visualChoiceGameImageFailed)
          .length,
      2,
    );
  });

  test('logs the event names derived from the config slug prefix', () {
    final faces = VisualChoiceGameAnalytics(
      analytics,
      config: VisualChoiceGameConfig.facesOfHistory,
    );

    faces.roundStarted(roundsTotal: 5, isArcade: false);
    faces.imageFailed(roundIndex: 0, isArcade: false);

    expect(analytics.hasEvent('faces_of_history_round_started'), isTrue);
    expect(analytics.hasEvent('faces_of_history_image_failed'), isTrue);
    expect(
      analytics.hasEvent(AnalyticsEvents.visualChoiceGameRoundStarted),
      isFalse,
    );
    expect(
      VisualChoiceGameConfig.knowledgeGallery.roundStartedEvent,
      AnalyticsEvents.visualChoiceGameRoundStarted,
    );
    expect(
      VisualChoiceGameConfig.facesOfHistory.eventPrefix,
      VisualChoiceGameEventPrefix.facesOfHistory,
    );
    expect(
      VisualChoiceGameAnalyticsEvent.questionAnswered.eventName(
        VisualChoiceGameSlugs.facesOfHistory,
      ),
      'faces_of_history_question_answered',
    );
    expect(
      VisualChoiceGameConfig.forSlug('unknown_game').roundStartedEvent,
      AnalyticsEvents.visualChoiceGameRoundStarted,
    );
  });
}
