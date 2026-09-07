import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/core/observability/crash_reporter.dart';
import 'package:lume/core/observability/crash_reporting.dart';

void main() {
  test('CrashReporting starts with a NoOp reporter', () {
    expect(CrashReporting.reporter, isA<NoOpCrashReporter>());
  });

  test('NoOpCrashReporter swallows errors and forceCrash', () async {
    const reporter = NoOpCrashReporter();
    await reporter.recordError(StateError('x'), StackTrace.current);
    await reporter.recordFlutterFatalError(
      FlutterErrorDetails(exception: StateError('y')),
    );
    expect(() => reporter.forceCrash(), returnsNormally);
  });

  test('collectionEnabled is off in debug without CRASHLYTICS_ENABLED', () {
    expect(CrashReporting.collectionEnabled, isFalse);
  });
}
