import 'package:flutter_test/flutter_test.dart';
import 'package:lume/core/analytics/analytics.dart';
import 'package:lume/core/analytics/knowledge_gallery_analytics.dart';

import '../../helpers/fake_analytics.dart';

void main() {
  late FakeAnalytics analytics;
  late KnowledgeGalleryAnalytics gallery;

  setUp(() {
    analytics = FakeAnalytics();
    gallery = KnowledgeGalleryAnalytics(analytics);
  });

  test('roundStarted then sessionCompleted logs once with is_arcade', () {
    gallery.roundStarted(roundsTotal: 5, isArcade: true);
    gallery.sessionCompleted(correctCount: 3, roundsTotal: 5, isArcade: true);
    gallery.sessionCompleted(correctCount: 3, roundsTotal: 5, isArcade: true);

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

  test('sessionAbandoned without a prior gallery touch is a no-op', () {
    gallery.sessionAbandoned(roundIndex: 0, roundsTotal: 2, isArcade: false);
    expect(
      analytics.hasEvent(AnalyticsEvents.knowledgeGallerySessionAbandoned),
      isFalse,
    );
  });

  test('imageFailed dedupes per round index', () {
    gallery.imageFailed(roundIndex: 0, isArcade: false);
    gallery.imageFailed(roundIndex: 0, isArcade: false);
    gallery.imageFailed(roundIndex: 1, isArcade: false);

    expect(
      analytics.events
          .where((e) => e.name == AnalyticsEvents.knowledgeGalleryImageFailed)
          .length,
      2,
    );
  });

  test('reset clears outcome and image-fail dedupe', () {
    gallery
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
}
