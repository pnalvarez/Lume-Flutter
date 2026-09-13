import 'package:flutter_test/flutter_test.dart';
import 'package:lume/core/analytics/analytics.dart';

void main() {
  test('AnalyticsService starts with a NoOp client', () {
    expect(AnalyticsService.client, isA<NoOpAnalytics>());
  });

  test('NoOpAnalytics swallows events', () async {
    const analytics = NoOpAnalytics();
    await expectLater(
      analytics.logEvent(AnalyticsEvents.arcadeOpened),
      completes,
    );
    await expectLater(analytics.setUserId('user'), completes);
  });

  test('collectionEnabled is off in debug without ANALYTICS_ENABLED', () {
    expect(AnalyticsService.collectionEnabled, isFalse);
  });
}
