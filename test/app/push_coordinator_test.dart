import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/app/push_coordinator.dart';
import 'package:lume/layers/domain/usecases/register_push_device.dart';
import 'package:lume/layers/domain/usecases/request_push_permission.dart';
import 'package:lume/layers/domain/usecases/watch_push_notification_taps.dart';
import 'package:lume/layers/domain/usecases/watch_push_token_refresh.dart';

import '../helpers/fake_push.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakePushDeviceRepository repository;
  late StreamController<void> auth;
  late bool signedIn;
  late int homeOpened;

  PushCoordinator build({bool prompt = false}) => PushCoordinator(
    registerPushDevice: RegisterPushDevice(repository),
    requestPushPermission: RequestPushPermission(repository),
    watchTokenRefresh: WatchPushTokenRefresh(repository),
    watchNotificationTaps: WatchPushNotificationTaps(repository),
    authSessionChanges: auth.stream,
    hasSession: () => signedIn,
    onOpenHome: () => homeOpened++,
    promptForPermission: prompt,
  );

  setUp(() {
    repository = FakePushDeviceRepository();
    auth = StreamController<void>.broadcast();
    signedIn = true;
    homeOpened = 0;
  });

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  test('registers on start when a session exists', () async {
    final sut = build()..start();
    await settle();

    expect(repository.registerCalls, 1);
    expect(repository.requestCalls, 0);
    await sut.dispose();
  });

  test(
    'does not register without a session, then registers on login',
    () async {
      signedIn = false;
      final sut = build()..start();
      await settle();
      expect(repository.registerCalls, 0);

      signedIn = true;
      auth.add(null);
      await settle();

      expect(repository.registerCalls, 1);
      await sut.dispose();
    },
  );

  test(
    'asks for permission before registering when prompting is enabled',
    () async {
      final sut = build(prompt: true)..start();
      await settle();

      expect(repository.events, ['request', 'register']);
      await sut.dispose();
    },
  );

  test('re-registers on token refresh and on app resume', () async {
    final sut = build()..start();
    await settle();

    repository.refresh.add(null);
    await settle();
    sut.didChangeAppLifecycleState(AppLifecycleState.paused);
    sut.didChangeAppLifecycleState(AppLifecycleState.resumed);
    await settle();

    expect(repository.registerCalls, 3);
    await sut.dispose();
  });

  test('opens Home when a notification is tapped', () async {
    final sut = build()..start();

    repository.taps.add(null);
    await settle();

    expect(homeOpened, 1);
    await sut.dispose();
  });

  test('overlapping triggers each run a sync in order', () async {
    final sut = build()..start();
    await settle();

    repository.refresh.add(null);
    repository.refresh.add(null);
    await settle();

    expect(repository.registerCalls, 3);
    await sut.dispose();
  });

  test('stops reacting after dispose', () async {
    final sut = build()..start();
    await settle();
    await sut.dispose();

    repository.taps.add(null);
    repository.refresh.add(null);
    await settle();

    expect(homeOpened, 0);
    expect(repository.registerCalls, 1);
  });
}
