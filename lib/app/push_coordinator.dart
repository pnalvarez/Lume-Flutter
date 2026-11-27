import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:lume/layers/domain/usecases/register_push_device.dart';
import 'package:lume/layers/domain/usecases/request_push_permission.dart';
import 'package:lume/layers/domain/usecases/watch_push_notification_taps.dart';
import 'package:lume/layers/domain/usecases/watch_push_token_refresh.dart';

/// App-level wiring for push notifications (no UI).
///
/// - Registers the device once a session exists and permission is granted.
/// - Re-registers when the FCM token rotates and when the app returns to the
///   foreground (picks up a changed device timezone).
/// - Opens Home when a notification is tapped.
///
/// Logout removal lives in the `SignOut` use case (it needs the live JWT).
class PushCoordinator with WidgetsBindingObserver {
  PushCoordinator({
    required IRegisterPushDevice registerPushDevice,
    required IRequestPushPermission requestPushPermission,
    required IWatchPushTokenRefresh watchTokenRefresh,
    required IWatchPushNotificationTaps watchNotificationTaps,
    required Stream<void> authSessionChanges,
    required bool Function() hasSession,
    required VoidCallback onOpenHome,
    this.promptForPermission = false,
  }) : _register = registerPushDevice,
       _requestPermission = requestPushPermission,
       _watchTokenRefresh = watchTokenRefresh,
       _watchNotificationTaps = watchNotificationTaps,
       _authSessionChanges = authSessionChanges,
       _hasSession = hasSession,
       _onOpenHome = onOpenHome;

  final IRegisterPushDevice _register;
  final IRequestPushPermission _requestPermission;
  final IWatchPushTokenRefresh _watchTokenRefresh;
  final IWatchPushNotificationTaps _watchNotificationTaps;
  final Stream<void> _authSessionChanges;
  final bool Function() _hasSession;
  final VoidCallback _onOpenHome;

  /// Temporary QA switch: ask for OS permission on login. The real
  /// pre-permission dialog ships in #241, which turns this off.
  final bool promptForPermission;

  final _subscriptions = <StreamSubscription<void>>[];
  Future<void> _queue = Future<void>.value();
  var _started = false;

  void start() {
    if (_started) return;
    _started = true;
    _subscriptions
      ..add(_authSessionChanges.listen((_) => _sync(prompt: true)))
      ..add(_watchTokenRefresh().listen((_) => _sync()))
      ..add(_watchNotificationTaps().listen((_) => _onOpenHome()));
    WidgetsBinding.instance.addObserver(this);
    _sync(prompt: true);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _sync();
  }

  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    _subscriptions.clear();
    _started = false;
  }

  /// Serialized so overlapping triggers (login + token + resume) never race.
  Future<void> _sync({bool prompt = false}) {
    return _queue = _queue.then((_) async {
      if (!_hasSession()) return;
      try {
        if (prompt && promptForPermission) await _requestPermission();
        await _register();
      } on Object catch (error, stack) {
        debugPrint('Push registration failed: $error\n$stack');
      }
    });
  }
}
