import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:lume/core/observability/crash_reporter.dart';
import 'package:lume/core/observability/firebase_options.dart';

/// Installs Crashlytics on iOS / Android / macOS and wires global error handlers.
///
/// Web, Windows, and Linux keep [NoOpCrashReporter] — Firebase Crashlytics has
/// no native SDK on those platforms.
/// Collection defaults to **off in debug**; override with
/// `--dart-define=CRASHLYTICS_ENABLED=true` for TestFlight / local validation.
final class CrashReporting {
  CrashReporting._();

  static ICrashReporter reporter = const NoOpCrashReporter();

  /// Whether this build should send events to Crashlytics.
  static bool get collectionEnabled {
    const forced = bool.fromEnvironment('CRASHLYTICS_ENABLED');
    if (forced) return true;
    return !kDebugMode;
  }

  static bool get _isCrashlyticsTarget {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.macOS;
  }

  /// Initializes Firebase, then Crashlytics when that SDK exists.
  ///
  /// Web uses [DefaultFirebaseOptions.web] (same Firebase project as the
  /// native plist / `google-services.json`). Crashlytics stays off on web.
  /// Failures are logged and ignored so the app can still start.
  static Future<void> install() async {
    if (kIsWeb) {
      if (!DefaultFirebaseOptions.hasWebConfig) {
        debugPrint(
          'Firebase web config missing. Pass --dart-define-from-file=secrets.json',
        );
      } else {
        try {
          await Firebase.initializeApp(options: DefaultFirebaseOptions.web);
        } on Object catch (error, stack) {
          debugPrint('Firebase web install failed: $error\n$stack');
        }
      }
      reporter = const NoOpCrashReporter();
      return;
    }

    if (!_isCrashlyticsTarget) {
      reporter = const NoOpCrashReporter();
      return;
    }

    try {
      await Firebase.initializeApp();
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
        collectionEnabled,
      );

      if (!collectionEnabled) {
        reporter = const NoOpCrashReporter();
        return;
      }

      reporter = FirebaseCrashReporter();
      FlutterError.onError = (details) {
        unawaited(reporter.recordFlutterFatalError(details));
      };
      PlatformDispatcher.instance.onError = (error, stack) {
        unawaited(reporter.recordError(error, stack, fatal: true));
        return true;
      };
    } on Object catch (error, stack) {
      reporter = const NoOpCrashReporter();
      debugPrint('Crashlytics install failed: $error\n$stack');
    }
  }

  /// Zone error callback for [runZonedGuarded].
  static void onZoneError(Object error, StackTrace stack) {
    unawaited(reporter.recordError(error, stack, fatal: true));
  }
}
