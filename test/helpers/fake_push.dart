import 'dart:async';

import 'package:lume/core/device/device_timezone.dart';
import 'package:lume/core/push/push_service.dart';
import 'package:lume/layers/domain/repository/push_device_repository.dart';

/// Controllable [IPushService] for unit tests.
class FakePushService implements IPushService {
  FakePushService({
    this.isSupported = true,
    this.platform = 'ios',
    this.status = PushPermissionStatus.granted,
    this.token = 'token-1',
  });

  @override
  bool isSupported;

  @override
  String platform;

  PushPermissionStatus status;
  String? token;
  var requestPermissionCalls = 0;
  var deleteTokenCalls = 0;

  final refresh = StreamController<String>.broadcast();
  final foreground = StreamController<PushMessage>.broadcast();
  final taps = StreamController<PushMessage>.broadcast();

  @override
  Future<PushPermissionStatus> permissionStatus() async => status;

  @override
  Future<PushPermissionStatus> requestPermission() async {
    requestPermissionCalls++;
    return status;
  }

  @override
  Future<String?> getToken() async => token;

  @override
  Future<void> deleteToken() async {
    deleteTokenCalls++;
    token = null;
  }

  @override
  Stream<String> get onTokenRefresh => refresh.stream;

  @override
  Stream<PushMessage> get onForegroundMessage => foreground.stream;

  @override
  Stream<PushMessage> get onNotificationTap => taps.stream;
}

class FakeDeviceTimezone implements IDeviceTimezone {
  FakeDeviceTimezone([this.timezone = 'America/Sao_Paulo']);

  String? timezone;

  @override
  Future<String?> current() async => timezone;
}

/// In-memory [IPushDeviceRepository] for use case / coordinator tests.
class FakePushDeviceRepository implements IPushDeviceRepository {
  var registerCalls = 0;
  var unregisterCalls = 0;
  var requestCalls = 0;
  Object? unregisterError;
  final events = <String>[];

  final refresh = StreamController<void>.broadcast();
  final taps = StreamController<void>.broadcast();

  @override
  Future<bool> requestPermission() async {
    requestCalls++;
    events.add('request');
    return true;
  }

  @override
  Future<bool> registerCurrentDevice() async {
    registerCalls++;
    events.add('register');
    return true;
  }

  @override
  Future<void> unregisterCurrentDevice() async {
    unregisterCalls++;
    events.add('unregister');
    final error = unregisterError;
    if (error != null) throw error;
  }

  @override
  Stream<void> watchTokenRefresh() => refresh.stream;

  @override
  Stream<void> watchNotificationTaps() => taps.stream;
}
