import 'package:injectable/injectable.dart';

/// Compile-time environment for the Lume app.
///
/// Values come from `--dart-define` (see [AppConfig.fromEnvironment]).
@lazySingleton
class AppConfig {
  const AppConfig({
    required this.supabaseUrl,
    required this.supabaseAnonKey,
    this.authCallbackUrl = defaultAuthCallbackUrl,
    this.passwordRecoveryUrl = defaultPasswordRecoveryUrl,
  });

  @factoryMethod
  factory AppConfig.fromEnvironment() => const AppConfig(
        supabaseUrl: String.fromEnvironment('SUPABASE_URL'),
        supabaseAnonKey: String.fromEnvironment('SUPABASE_ANON_KEY'),
      );

  static const defaultAuthCallbackUrl = 'io.lume.app://login-callback';
  static const defaultPasswordRecoveryUrl = 'io.lume.app://reset-password';

  final String supabaseUrl;
  final String supabaseAnonKey;
  final String authCallbackUrl;
  final String passwordRecoveryUrl;
}
