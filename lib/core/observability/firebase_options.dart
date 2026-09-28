import 'package:firebase_core/firebase_core.dart';

/// Web Firebase client config.
///
/// Values come from `secrets.json` via `--dart-define-from-file=secrets.json`
/// (see `secrets.example.json`). iOS, macOS, and Android keep using
/// `GoogleService-Info.plist` and `google-services.json`.
abstract final class DefaultFirebaseOptions {
  static const web = FirebaseOptions(
    apiKey: String.fromEnvironment('FIREBASE_WEB_API_KEY'),
    appId: String.fromEnvironment('FIREBASE_WEB_APP_ID'),
    messagingSenderId: String.fromEnvironment(
      'FIREBASE_WEB_MESSAGING_SENDER_ID',
    ),
    projectId: String.fromEnvironment('FIREBASE_WEB_PROJECT_ID'),
    authDomain: String.fromEnvironment('FIREBASE_WEB_AUTH_DOMAIN'),
    storageBucket: String.fromEnvironment('FIREBASE_WEB_STORAGE_BUCKET'),
    measurementId: String.fromEnvironment('FIREBASE_WEB_MEASUREMENT_ID'),
  );

  static bool get hasWebConfig => web.apiKey.isNotEmpty && web.appId.isNotEmpty;
}
