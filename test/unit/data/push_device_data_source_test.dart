import 'package:flutter_test/flutter_test.dart';
import 'package:lume/core/auth/auth_session.dart';
import 'package:lume/core/push/push_service.dart';
import 'package:lume/layers/data/datasource/push_device_data_source.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/fake_auth_session_provider.dart';
import '../../helpers/fake_push.dart';
import '../../helpers/mocks.mocks.dart';

void main() {
  late MockIApiClient api;
  late FakePushService push;
  late FakeDeviceTimezone timezone;
  late FakeAuthSessionProvider session;
  late PushDeviceDataSource sut;

  const snapshot = AuthSessionSnapshot(
    accessToken: 'jwt',
    userId: 'user-1',
    isEmailConfirmed: true,
  );

  setUp(() {
    api = MockIApiClient();
    push = FakePushService();
    timezone = FakeDeviceTimezone();
    session = FakeAuthSessionProvider(session: snapshot);
    sut = PushDeviceDataSource(api, push, timezone, session);
  });

  Map<String, Object?> lastParams(String rpc) {
    final captured = verify(
      api.rpc<Object?>(
        rpc,
        params: captureAnyNamed('params'),
        headers: anyNamed('headers'),
      ),
    ).captured;
    return Map<String, Object?>.from(captured.last as Map);
  }

  group('register', () {
    test(
      'sends token, platform and timezone when permission is granted',
      () async {
        expect(await sut.register(), isTrue);

        expect(lastParams('register_push_device'), {
          'p_token': 'token-1',
          'p_platform': 'ios',
          'p_timezone': 'America/Sao_Paulo',
        });
      },
    );

    test('does nothing without a session', () async {
      session.session = null;

      expect(await sut.register(), isFalse);
      verifyNever(
        api.rpc<Object?>(
          any,
          params: anyNamed('params'),
          headers: anyNamed('headers'),
        ),
      );
    });

    test('does nothing when permission is not granted', () async {
      push.status = PushPermissionStatus.denied;

      expect(await sut.register(), isFalse);
      verifyNever(
        api.rpc<Object?>(
          any,
          params: anyNamed('params'),
          headers: anyNamed('headers'),
        ),
      );
    });

    test('does nothing when token or timezone is unavailable', () async {
      push.token = null;
      expect(await sut.register(), isFalse);

      push.token = 'token-1';
      timezone.timezone = null;
      expect(await sut.register(), isFalse);

      verifyNever(
        api.rpc<Object?>(
          any,
          params: anyNamed('params'),
          headers: anyNamed('headers'),
        ),
      );
    });

    test('does nothing on unsupported platforms', () async {
      push.isSupported = false;

      expect(await sut.register(), isFalse);
    });

    test(
      'skips the call when nothing changed, re-sends on a new timezone or token',
      () async {
        await sut.register();
        await sut.register();
        verify(
          api.rpc<Object?>(
            'register_push_device',
            params: anyNamed('params'),
            headers: anyNamed('headers'),
          ),
        ).called(1);

        timezone.timezone = 'Europe/Lisbon';
        await sut.register();
        expect(
          lastParams('register_push_device')['p_timezone'],
          'Europe/Lisbon',
        );

        push.token = 'token-2';
        await sut.register();
        expect(lastParams('register_push_device')['p_token'], 'token-2');
      },
    );

    test('does not mark as registered when the RPC fails', () async {
      when(
        api.rpc<Object?>(
          'register_push_device',
          params: anyNamed('params'),
          headers: anyNamed('headers'),
        ),
      ).thenThrow(Exception('network'));

      await expectLater(sut.register(), throwsException);

      reset(api);
      expect(await sut.register(), isTrue);
      verify(
        api.rpc<Object?>(
          'register_push_device',
          params: anyNamed('params'),
          headers: anyNamed('headers'),
        ),
      ).called(1);
    });
  });

  group('unregister', () {
    test(
      'removes the registered token server-side and deletes it locally',
      () async {
        await sut.register();

        await sut.unregister();

        expect(lastParams('unregister_push_device'), {'p_token': 'token-1'});
        expect(push.deleteTokenCalls, 1);
      },
    );

    test(
      'falls back to the SDK token when nothing was registered this run',
      () async {
        await sut.unregister();

        expect(lastParams('unregister_push_device'), {'p_token': 'token-1'});
        expect(push.deleteTokenCalls, 1);
      },
    );

    test('still deletes the local token when the RPC fails', () async {
      when(
        api.rpc<Object?>(
          'unregister_push_device',
          params: anyNamed('params'),
          headers: anyNamed('headers'),
        ),
      ).thenThrow(Exception('network'));

      await expectLater(sut.unregister(), throwsException);

      expect(push.deleteTokenCalls, 1);
    });

    test('allows registering again afterwards', () async {
      await sut.register();
      await sut.unregister();
      push.token = 'token-2';

      expect(await sut.register(), isTrue);
      expect(lastParams('register_push_device')['p_token'], 'token-2');
    });

    test('is a no-op on unsupported platforms', () async {
      push.isSupported = false;

      await sut.unregister();

      expect(push.deleteTokenCalls, 0);
    });
  });

  test('requestPermission maps the status to a bool', () async {
    expect(await sut.requestPermission(), isTrue);
    push.status = PushPermissionStatus.denied;
    expect(await sut.requestPermission(), isFalse);
  });

  test(
    'exposes token refresh and notification taps from the push service',
    () async {
      final refreshes = <void>[];
      final taps = <void>[];
      sut.watchTokenRefresh().listen(refreshes.add);
      sut.watchNotificationTaps().listen(taps.add);

      push.refresh.add('token-9');
      push.taps.add(const PushMessage());
      await Future<void>.delayed(Duration.zero);

      expect(refreshes, hasLength(1));
      expect(taps, hasLength(1));
    },
  );
}
