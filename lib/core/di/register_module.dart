import 'package:injectable/injectable.dart';
import 'package:lume/core/auth/auth_session_provider.dart';
import 'package:lume/core/auth/auth_token_provider.dart';
import 'package:lume/core/observability/crash_reporter.dart';
import 'package:lume/core/observability/crash_reporting.dart';

@module
abstract class CoreAuthModule {
  @lazySingleton
  IAuthTokenProvider authTokenProvider(IAuthSessionProvider session) => session;
}

@module
abstract class CoreObservabilityModule {
  @lazySingleton
  ICrashReporter crashReporter() => CrashReporting.reporter;
}
