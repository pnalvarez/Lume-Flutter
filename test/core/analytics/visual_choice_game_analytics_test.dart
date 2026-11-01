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
      analytics.parametersFor(AnalyticsEvents.knowledgeGalleryRoundStarted),
      {AnalyticsParams.roundsTotal: 5, AnalyticsParams.isArcade: true},
    );
    expect(
      analytics.events
          .where(
            (e) => e.name == AnalyticsEvents.knowledgeGallerySessionCompleted,
          )
          .length,
      1,
    );
    expect(
      analytics.parametersFor(AnalyticsEvents.knowledgeGallerySessionCompleted),
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
      analytics.hasEvent(AnalyticsEvents.knowledgeGallerySessionAbandoned),
      isFalse,
    );
  });

  test('imageFailed dedupes per round index', () {
    visual.imageFailed(roundIndex: 0, isArcade: false);
    visual.imageFailed(roundIndex: 0, isArcade: false);
    visual.imageFailed(roundIndex: 1, isArcade: false);

    expect(
      analytics.events
          .where((e) => e.name == AnalyticsEvents.knowledgeGalleryImageFailed)
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
            (e) => e.name == AnalyticsEvents.knowledgeGallerySessionAbandoned,
          )
          .length,
      1,
    );
    expect(
      analytics.events
          .where(
            (e) => e.name == AnalyticsEvents.knowledgeGallerySessionCompleted,
          )
          .length,
      1,
    );
    expect(
      analytics.events
          .where((e) => e.name == AnalyticsEvents.knowledgeGalleryImageFailed)
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

    expect(
      analytics.hasEvent(AnalyticsEvents.facesOfHistoryRoundStarted),
      isTrue,
    );
    expect(
      analytics.hasEvent(AnalyticsEvents.facesOfHistoryImageFailed),
      isTrue,
    );
    expect(
      analytics.hasEvent(AnalyticsEvents.knowledgeGalleryRoundStarted),
      isFalse,
    );
    // The config derives names from the slug prefix; the AnalyticsEvents
    // literals are the wire contract, so a prefix typo fails here.
    final gallery = VisualChoiceGameConfig.knowledgeGallery;
    expect(
      gallery.roundStartedEvent,
      AnalyticsEvents.knowledgeGalleryRoundStarted,
    );
    expect(
      gallery.questionAnsweredEvent,
      AnalyticsEvents.knowledgeGalleryQuestionAnswered,
    );
    expect(
      gallery.sessionCompletedEvent,
      AnalyticsEvents.knowledgeGallerySessionCompleted,
    );
    expect(
      gallery.sessionAbandonedEvent,
      AnalyticsEvents.knowledgeGallerySessionAbandoned,
    );
    expect(
      gallery.imageFailedEvent,
      AnalyticsEvents.knowledgeGalleryImageFailed,
    );
    final facesConfig = VisualChoiceGameConfig.facesOfHistory;
    expect(
      facesConfig.roundStartedEvent,
      AnalyticsEvents.facesOfHistoryRoundStarted,
    );
    expect(
      facesConfig.questionAnsweredEvent,
      AnalyticsEvents.facesOfHistoryQuestionAnswered,
    );
    expect(
      facesConfig.sessionCompletedEvent,
      AnalyticsEvents.facesOfHistorySessionCompleted,
    );
    expect(
      facesConfig.sessionAbandonedEvent,
      AnalyticsEvents.facesOfHistorySessionAbandoned,
    );
    expect(
      facesConfig.imageFailedEvent,
      AnalyticsEvents.facesOfHistoryImageFailed,
    );
    expect(gallery.eventPrefix, 'knowledge_gallery_');
    expect(facesConfig.eventPrefix, 'faces_of_history_');
    expect(
      VisualChoiceGameAnalyticsEvent.questionAnswered.eventName(
        VisualChoiceGameSlugs.facesOfHistory,
      ),
      'faces_of_history_question_answered',
    );
    // A slug outside the known catalog (a new hub visual game not yet
    // given its own enum entry) gets its own prefix, never Galeria's.
    expect(
      VisualChoiceGameConfig.forSlug('unknown_game').roundStartedEvent,
      'unknown_game_round_started',
    );
    expect(
      VisualChoiceGameConfig.forSlug('unknown_game').roundStartedEvent,
      isNot(AnalyticsEvents.knowledgeGalleryRoundStarted),
    );
  });

  test('Faces of History funnel fires only faces_of_history_* events', () {
    final faces = VisualChoiceGameAnalytics(
      analytics,
      config: VisualChoiceGameConfig.facesOfHistory,
    );

    faces
      ..roundStarted(roundsTotal: 3, isArcade: false)
      ..questionAnswered(
        questionType: 'figure',
        isCorrect: true,
        roundIndex: 0,
        isArcade: false,
      )
      ..sessionCompleted(correctCount: 1, roundsTotal: 3, isArcade: false);

    expect(
      analytics.hasEvent(AnalyticsEvents.facesOfHistoryRoundStarted),
      isTrue,
    );
    expect(
      analytics.parametersFor(AnalyticsEvents.facesOfHistoryQuestionAnswered),
      {
        AnalyticsParams.questionType: 'figure',
        AnalyticsParams.isCorrect: 1,
        AnalyticsParams.roundIndex: 0,
        AnalyticsParams.isArcade: false,
      },
    );
    expect(
      analytics.parametersFor(AnalyticsEvents.facesOfHistorySessionCompleted),
      {
        AnalyticsParams.correctCount: 1,
        AnalyticsParams.roundsTotal: 3,
        AnalyticsParams.isArcade: false,
      },
    );
    faces
      ..imageFailed(roundIndex: 0, isArcade: false)
      ..imageFailed(roundIndex: 0, isArcade: false)
      ..sessionAbandoned(roundIndex: 1, roundsTotal: 3, isArcade: false);

    // Completed already logged this session, so abandon stays a no-op.
    expect(
      analytics.hasEvent(AnalyticsEvents.facesOfHistorySessionAbandoned),
      isFalse,
    );
    expect(
      analytics.events
          .where((e) => e.name == AnalyticsEvents.facesOfHistoryImageFailed)
          .length,
      1,
    );
    expect(analytics.parametersFor(AnalyticsEvents.facesOfHistoryImageFailed), {
      AnalyticsParams.isArcade: false,
    });
    expect(
      analytics.events.every((e) => e.name.startsWith('faces_of_history_')),
      isTrue,
    );
  });

  test(
    'Faces of History abandon logs round_index, rounds_total, is_arcade',
    () {
      final faces = VisualChoiceGameAnalytics(
        analytics,
        config: VisualChoiceGameConfig.facesOfHistory,
      );

      faces
        ..roundStarted(roundsTotal: 3, isArcade: true)
        ..sessionAbandoned(roundIndex: 1, roundsTotal: 3, isArcade: true)
        ..sessionAbandoned(roundIndex: 2, roundsTotal: 3, isArcade: true);

      expect(
        analytics.events
            .where(
              (e) => e.name == AnalyticsEvents.facesOfHistorySessionAbandoned,
            )
            .length,
        1,
      );
      expect(
        analytics.parametersFor(AnalyticsEvents.facesOfHistorySessionAbandoned),
        {
          AnalyticsParams.roundIndex: 1,
          AnalyticsParams.roundsTotal: 3,
          AnalyticsParams.isArcade: true,
        },
      );
    },
  );

  test('Galeria session still emits only knowledge_gallery_* events', () {
    visual
      ..roundStarted(roundsTotal: 2, isArcade: false)
      ..questionAnswered(
        questionType: 'artwork',
        isCorrect: false,
        roundIndex: 0,
        isArcade: false,
      )
      ..imageFailed(roundIndex: 0, isArcade: false)
      ..sessionAbandoned(roundIndex: 1, roundsTotal: 2, isArcade: false);

    expect(analytics.events.map((e) => e.name).toList(), [
      AnalyticsEvents.knowledgeGalleryRoundStarted,
      AnalyticsEvents.knowledgeGalleryQuestionAnswered,
      AnalyticsEvents.knowledgeGalleryImageFailed,
      AnalyticsEvents.knowledgeGallerySessionAbandoned,
    ]);
  });
}
