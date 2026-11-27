import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:lume/core/auth/auth_session_provider.dart';
import 'package:lume/core/device/device_timezone.dart';
import 'package:lume/core/network/api_client.dart';
import 'package:lume/core/push/push_service.dart';

abstract interface class IPushDeviceDataSource {
  Future<bool> requestPermission();

  Future<bool> register();

  Future<void> unregister();

  Stream<void> watchTokenRefresh();

  Stream<void> watchNotificationTaps();

  /// Stops listening to auth session changes.
  Future<void> dispose();
}

@LazySingleton(as: IPushDeviceDataSource)
final class PushDeviceDataSource implements IPushDeviceDataSource {
  PushDeviceDataSource(
    this._apiClient,
    this._push,
    this._timezone,
    this._session,
  ) {
    _sessionSubscription = _session.changes.listen(
      (_) => _clearSigningOutIfDone(),
    );
  }

  final IApiClient _apiClient;
  final IPushService _push;
  final IDeviceTimezone _timezone;
  final IAuthSessionProvider _session;

  /// Last payload the server acknowledged, to skip redundant calls on resume.
  String? _lastSignature;
  String? _lastToken;

  /// Set by [unregister] so a concurrent [register] (resume, token refresh,
  /// auth change) cannot re-add the token while the user is signing out.
  /// Cleared once the session ends or a different user signs in.
  var _signingOut = false;
  String? _signingOutUserId;
  StreamSubscription<void>? _sessionSubscription;

  @override
  Future<bool> requestPermission() async {
    final status = await _push.requestPermission();
    return status == PushPermissionStatus.granted;
  }

  @override
  Future<bool> register() async {
    _clearSigningOutIfDone();
    if (_signingOut) return false;
    final userId = _session.userId;
    if (userId == null || !_push.isSupported) return false;
    if (await _push.permissionStatus() != PushPermissionStatus.granted) {
      return false;
    }
    final token = await _push.getToken();
    final timezone = await _timezone.current();
    if (token == null || token.isEmpty || timezone == null) return false;

    final signature = '$userId|$token|$timezone';
    if (signature == _lastSignature) return true;
    // The awaits above may have overlapped with a sign-out.
    if (_signingOut) return false;

    await _apiClient.rpc<Object?>(
      'register_push_device',
      params: {
        'p_token': token,
        'p_platform': _push.platform,
        'p_timezone': timezone,
      },
    );
    // Do not remember a registration that raced with a sign-out, so the next
    // login registers again.
    if (_signingOut) return false;
    _lastSignature = signature;
    _lastToken = token;
    return true;
  }

  @override
  Future<void> unregister() async {
    if (!_push.isSupported) return;
    _signingOut = true;
    _signingOutUserId = _session.userId;
    final token = _lastToken ?? await _push.getToken();
    _lastSignature = null;
    _lastToken = null;
    if (token == null || token.isEmpty) return;
    try {
      if (_session.hasSession) {
        await _apiClient.rpc<Object?>(
          'unregister_push_device',
          params: {'p_token': token},
        );
      }
    } finally {
      // Even if the server call failed, stop this device receiving pushes
      // addressed to the account that is signing out.
      await _push.deleteToken();
    }
  }

  /// Ends the sign-out window once the session is gone, or once a different
  /// user is signed in (the next login). Same-user logins always pass through
  /// "no session" first, which is observed through [IAuthSessionProvider.changes].
  void _clearSigningOutIfDone() {
    if (!_signingOut) return;
    final userId = _session.userId;
    if (userId == null || userId != _signingOutUserId) {
      _signingOut = false;
      _signingOutUserId = null;
    }
  }

  @override
  @disposeMethod
  Future<void> dispose() async {
    await _sessionSubscription?.cancel();
    _sessionSubscription = null;
  }

  @override
  Stream<void> watchTokenRefresh() => _push.onTokenRefresh;

  @override
  Stream<void> watchNotificationTaps() => _push.onNotificationTap;
}
