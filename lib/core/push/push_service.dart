import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

/// OS notification permission as seen by the push SDK.
enum PushPermissionStatus { granted, denied, notDetermined }

/// A push message reduced to what the app needs.
class PushMessage {
  const PushMessage({this.title, this.body, this.data = const {}});

  final String? title;
  final String? body;
  final Map<String, Object?> data;
}

/// Thin adapter over Firebase Cloud Messaging. The only file in `lib/` that
/// may import `firebase_messaging`.
abstract interface class IPushService {
  /// Whether this platform can receive pushes (iOS / Android only).
  bool get isSupported;

  /// Wire value stored in `push_devices.platform`: `ios` or `android`.
  String get platform;

  /// Current OS permission, without prompting.
  Future<PushPermissionStatus> permissionStatus();

  /// Shows the system permission prompt (Android 13+ / iOS) when undetermined.
  Future<PushPermissionStatus> requestPermission();

  /// FCM registration token, or `null` when unavailable.
  Future<String?> getToken();

  /// Invalidates the current FCM token (logout).
  Future<void> deleteToken();

  /// Emits every new FCM token after a rotation.
  Stream<String> get onTokenRefresh;

  /// Messages received while the app is in the foreground.
  Stream<PushMessage> get onForegroundMessage;

  /// Emits when the user taps a notification while the app is backgrounded.
  Stream<PushMessage> get onNotificationTap;
}

@LazySingleton(as: IPushService)
final class PushService implements IPushService {
  PushService();

  static const _apnsAttempts = 5;
  static const _apnsDelay = Duration(seconds: 1);

  FirebaseMessaging get _messaging => FirebaseMessaging.instance;

  @override
  bool get isSupported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.android);

  @override
  String get platform =>
      defaultTargetPlatform == TargetPlatform.iOS ? 'ios' : 'android';

  @override
  Future<PushPermissionStatus> permissionStatus() async {
    if (!isSupported) return PushPermissionStatus.denied;
    final settings = await _messaging.getNotificationSettings();
    return _map(settings.authorizationStatus);
  }

  @override
  Future<PushPermissionStatus> requestPermission() async {
    if (!isSupported) return PushPermissionStatus.denied;
    final settings = await _messaging.requestPermission();
    // Show the banner even while the app is open (iOS only; Android ignores it).
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    return _map(settings.authorizationStatus);
  }

  @override
  Future<String?> getToken() async {
    if (!isSupported) return null;
    try {
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        // FCM needs the APNs token first; it can arrive a moment after launch.
        for (var i = 0; i < _apnsAttempts; i++) {
          if (await _messaging.getAPNSToken() != null) break;
          await Future<void>.delayed(_apnsDelay);
        }
      }
      return await _messaging.getToken();
    } on Object catch (error, stack) {
      debugPrint('FCM getToken failed: $error\n$stack');
      return null;
    }
  }

  @override
  Future<void> deleteToken() async {
    if (!isSupported) return;
    await _messaging.deleteToken();
  }

  @override
  Stream<String> get onTokenRefresh =>
      isSupported ? _messaging.onTokenRefresh : const Stream.empty();

  @override
  Stream<PushMessage> get onForegroundMessage => isSupported
      ? FirebaseMessaging.onMessage.map(_toMessage)
      : const Stream.empty();

  @override
  Stream<PushMessage> get onNotificationTap => isSupported
      ? FirebaseMessaging.onMessageOpenedApp.map(_toMessage)
      : const Stream.empty();

  static PushPermissionStatus _map(AuthorizationStatus status) {
    return switch (status) {
      AuthorizationStatus.authorized ||
      AuthorizationStatus.provisional => PushPermissionStatus.granted,
      AuthorizationStatus.denied ||
      AuthorizationStatus.deniedPermanently => PushPermissionStatus.denied,
      AuthorizationStatus.notDetermined => PushPermissionStatus.notDetermined,
    };
  }

  static PushMessage _toMessage(RemoteMessage message) => PushMessage(
    title: message.notification?.title,
    body: message.notification?.body,
    data: Map<String, Object?>.from(message.data),
  );
}
