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

/// Stable Analytics event names (Firebase ≤40 chars, snake_case).
///
/// Shared parameter keys: see [AnalyticsParams].
abstract final class AnalyticsEvents {
  /// Fired when Games Hub loads with Arcade visible (exposure).
  static const arcadeCtaImpression = 'arcade_cta_impression';

  /// Fired when the user taps Arcade (primary experiment goal).
  static const arcadeOpened = 'arcade_opened';

  /// Fired when the user leaves an arcade run (shows score screen).
  static const arcadeAbandoned = 'arcade_abandoned';

  /// Fired when the user taps login/signup submit.
  static const loginSubmitted = 'login_submitted';

  /// Fired after successful auth (session established).
  static const loginSucceeded = 'login_succeeded';

  /// Fired when login/signup fails.
  static const loginFailed = 'login_failed';

  /// Fired when onboarding personal info is saved (not settings edit).
  static const onboardingPersonalInfoCompleted =
      'onboarding_personal_info_completed';

  /// Fired when onboarding categories are saved (not profile edit).
  static const onboardingCategorySelected = 'onboarding_category_selected';

  /// Fired when a submodule session starts loading.
  static const submoduleSessionStarted = 'submodule_session_started';

  /// Fired after pair scores flush successfully and stage is completed.
  static const submoduleSessionCompleted = 'submodule_session_completed';

  /// Fired when the user leaves or cancels a submodule session.
  static const submoduleSessionAbandoned = 'submodule_session_abandoned';

  /// Fired when a games play sequence starts.
  static const gameRoundStarted = 'game_round_started';

  /// Fired when a games play sequence finishes successfully.
  static const gameSessionCompleted = 'game_session_completed';

  /// Fired when the user abandons a games play sequence.
  static const gameSessionAbandoned = 'game_session_abandoned';
}

/// Shared Analytics parameter keys (no PII).
abstract final class AnalyticsParams {
  static const mode = 'mode';
  static const destination = 'destination';
  static const errorCode = 'error_code';
  static const categoryId = 'category_id';
  static const trailId = 'trail_id';
  static const submoduleId = 'submodule_id';
  static const pairId = 'pair_id';
  static const scorePct = 'score_pct';
  static const correctCount = 'correct_count';
  static const reason = 'reason';
  static const playMode = 'play_mode';
  static const gameType = 'game_type';
  static const roundsTotal = 'rounds_total';
  static const roundIndex = 'round_index';
  static const gamesPlayed = 'games_played';
  static const score = 'score';
  static const record = 'record';
  static const arcadeEnabled = 'arcade_enabled';
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
