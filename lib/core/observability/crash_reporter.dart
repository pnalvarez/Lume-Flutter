import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Reports crashes and non-fatal errors to an observability backend.
abstract interface class ICrashReporter {
  /// Records a non-fatal (or fatal) error with optional [stack] and [reason].
  Future<void> recordError(
    Object error,
    StackTrace? stack, {
    String? reason,
    bool fatal = false,
  });

  /// Records a Flutter framework error.
  Future<void> recordFlutterFatalError(FlutterErrorDetails details);

  /// Forces a native crash — **debug / validation only**.
  void forceCrash();
}

/// No-op reporter used on unsupported platforms or when Crashlytics is off.
final class NoOpCrashReporter implements ICrashReporter {
  const NoOpCrashReporter();

  @override
  Future<void> recordError(
    Object error,
    StackTrace? stack, {
    String? reason,
    bool fatal = false,
  }) async {}

  @override
  Future<void> recordFlutterFatalError(FlutterErrorDetails details) async {}

  @override
  void forceCrash() {}
}

/// Firebase Crashlytics implementation (iOS / Android).
final class FirebaseCrashReporter implements ICrashReporter {
  FirebaseCrashReporter({FirebaseCrashlytics? crashlytics})
    : _crashlytics = crashlytics ?? FirebaseCrashlytics.instance;

  final FirebaseCrashlytics _crashlytics;

  @override
  Future<void> recordError(
    Object error,
    StackTrace? stack, {
    String? reason,
    bool fatal = false,
  }) {
    return _crashlytics.recordError(error, stack, reason: reason, fatal: fatal);
  }

  @override
  Future<void> recordFlutterFatalError(FlutterErrorDetails details) {
    return _crashlytics.recordFlutterFatalError(details);
  }

  @override
  void forceCrash() {
    _crashlytics.crash();
  }
}
