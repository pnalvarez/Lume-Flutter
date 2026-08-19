import 'package:injectable/injectable.dart';

/// Compile-time environment for the Lume app.
///
/// `--dart-define=SUPABASE_URL` / `SUPABASE_ANON_KEY` override the defaults.
/// Defaults match `.vscode/launch.json` so `flutter run` from the terminal works.
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
        supabaseUrl: String.fromEnvironment(
          'SUPABASE_URL',
          defaultValue: defaultSupabaseUrl,
        ),
        supabaseAnonKey: String.fromEnvironment(
          'SUPABASE_ANON_KEY',
          defaultValue: defaultSupabaseAnonKey,
        ),
      );

  static const defaultSupabaseUrl =
      'https://mizgtuwtuaculchwizkm.supabase.co';
  static const defaultSupabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1pemd0dXd0dWFjdWxjaHdpemttIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODY1NzUzMzMsImV4cCI6MjEwMjE1MTMzM30.qV1ksdwGM6PmIyhr2ClBVJKFCxOcoGCsmElCgIi6UcA';

  static const defaultAuthCallbackUrl = 'io.lume.app://login-callback';
  static const defaultPasswordRecoveryUrl = 'io.lume.app://reset-password';

  final String supabaseUrl;
  final String supabaseAnonKey;
  final String authCallbackUrl;
  final String passwordRecoveryUrl;
}
