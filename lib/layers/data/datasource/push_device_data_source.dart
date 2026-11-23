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
}

@LazySingleton(as: IPushDeviceDataSource)
final class PushDeviceDataSource implements IPushDeviceDataSource {
  PushDeviceDataSource(
    this._apiClient,
    this._push,
    this._timezone,
    this._session,
  );

  final IApiClient _apiClient;
  final IPushService _push;
  final IDeviceTimezone _timezone;
  final IAuthSessionProvider _session;

  /// Last payload the server acknowledged, to skip redundant calls on resume.
  String? _lastSignature;
  String? _lastToken;

  @override
  Future<bool> requestPermission() async {
    final status = await _push.requestPermission();
    return status == PushPermissionStatus.granted;
  }

  @override
  Future<bool> register() async {
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

    await _apiClient.rpc<Object?>(
      'register_push_device',
      params: {
        'p_token': token,
        'p_platform': _push.platform,
        'p_timezone': timezone,
      },
    );
    _lastSignature = signature;
    _lastToken = token;
    return true;
  }

  @override
  Future<void> unregister() async {
    if (!_push.isSupported) return;
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

  @override
  Stream<void> watchTokenRefresh() => _push.onTokenRefresh;

  @override
  Stream<void> watchNotificationTaps() => _push.onNotificationTap;
}
