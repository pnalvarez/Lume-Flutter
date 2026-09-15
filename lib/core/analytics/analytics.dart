import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

/// Product analytics used for funnels and Firebase A/B Testing goals.
///
/// Presentation depends on this interface only — never on
/// `firebase_analytics` directly.
abstract interface class IAnalytics {
  /// Logs a named event with optional [parameters].
  Future<void> logEvent(String name, {Map<String, Object>? parameters});

  /// Associates subsequent events with [userId] (e.g. auth uid).
  Future<void> setUserId(String? userId);
}

/// Stable Analytics event names used as A/B Testing goals.
abstract final class AnalyticsEvents {
  /// Fired when Games Hub loads with Arcade visible (exposure).
  static const arcadeCtaImpression = 'arcade_cta_impression';

  /// Fired when the user taps Arcade (primary experiment goal).
  static const arcadeOpened = 'arcade_opened';
}

/// No-op client for unsupported platforms / failed install.
final class NoOpAnalytics implements IAnalytics {
  const NoOpAnalytics();

  @override
  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {}

  @override
  Future<void> setUserId(String? userId) async {}
}

/// Firebase Analytics implementation (iOS / Android / macOS / web when available).
final class FirebaseAnalyticsClient implements IAnalytics {
  FirebaseAnalyticsClient({FirebaseAnalytics? analytics})
    : _analytics = analytics ?? FirebaseAnalytics.instance;

  final FirebaseAnalytics _analytics;

  @override
  Future<void> logEvent(String name, {Map<String, Object>? parameters}) {
    return _analytics.logEvent(name: name, parameters: parameters);
  }

  @override
  Future<void> setUserId(String? userId) {
    return _analytics.setUserId(id: userId);
  }
}

/// Installs Analytics after Firebase Core init (Crashlytics).
///
/// Required for Firebase A/B Testing enrollment and experiment goal metrics.
final class AnalyticsService {
  AnalyticsService._();

  static IAnalytics client = const NoOpAnalytics();

  /// Whether this build should send Analytics events.
  ///
  /// Off in debug by default; force with `--dart-define=ANALYTICS_ENABLED=true`.
  static bool get collectionEnabled {
    const forced = bool.fromEnvironment('ANALYTICS_ENABLED');
    if (forced) return true;
    return !kDebugMode;
  }

  static bool get _isAnalyticsTarget {
    // Analytics Flutter plugin supports mobile + web; keep parity with Remote
    // Config / Crashlytics for A/B (experiments need mobile Analytics).
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.macOS;
  }

  /// Initializes Analytics when supported.
  static Future<void> install() async {
    if (!_isAnalyticsTarget) {
      client = const NoOpAnalytics();
      return;
    }

    try {
      final analytics = FirebaseAnalytics.instance;
      await analytics.setAnalyticsCollectionEnabled(collectionEnabled);
      if (!collectionEnabled) {
        client = const NoOpAnalytics();
        return;
      }
      client = FirebaseAnalyticsClient(analytics: analytics);
    } on Object catch (error, stack) {
      client = const NoOpAnalytics();
      debugPrint('Analytics install failed: $error\n$stack');
    }
  }
}
