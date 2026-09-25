import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:lume/core/auth/auth_session.dart';
import 'package:lume/core/auth/auth_session_provider.dart';
import 'package:lume/core/realtime/realtime_client.dart';
import 'package:lume/layers/data/datasource/achievement_unlock_data_source.dart';

import '../../../helpers/fake_auth_service.dart';

class _WatchCall {
  _WatchCall({required this.filterValue}) {
    controller = StreamController<Map<String, dynamic>>.broadcast(
      onCancel: () {
        cancelled = true;
      },
    );
  }

  final String filterValue;
  late final StreamController<Map<String, dynamic>> controller;
  var cancelled = false;
}

class _FakeRealtime implements IRealtimeClient {
  final calls = <_WatchCall>[];

  @override
  Stream<Map<String, dynamic>> watchInserts({
    required String table,
    required String filterColumn,
    required String filterValue,
    String schema = 'public',
  }) {
    final call = _WatchCall(filterValue: filterValue);
    calls.add(call);
    return call.controller.stream;
  }
}

void main() {
  const user1 = AuthSessionSnapshot(
    accessToken: 'jwt',
    userId: 'user-1',
    email: 'ada@example.com',
    isEmailConfirmed: true,
  );
  const user2 = AuthSessionSnapshot(
    accessToken: 'jwt-2',
    userId: 'user-2',
    email: 'bob@example.com',
    isEmailConfirmed: true,
  );

  late FakeAuthService auth;
  late AuthSessionProvider session;
  late _FakeRealtime realtime;
  late AchievementUnlockDataSource sut;

  setUp(() {
    auth = FakeAuthService(currentSession: user1);
    session = AuthSessionProvider(auth);
    realtime = _FakeRealtime();
    sut = AchievementUnlockDataSource(realtime, session);
  });

  tearDown(() async {
    session.dispose();
    await auth.dispose();
    for (final call in realtime.calls) {
      if (!call.controller.isClosed) {
        await call.controller.close();
      }
    }
  });

  test('maps realtime inserts for the signed-in user', () async {
    final names = <String>[];
    final sub = sut.watch().listen((data) => names.add(data.name));
    await Future<void>.delayed(Duration.zero);

    expect(realtime.calls, hasLength(1));
    expect(realtime.calls.single.filterValue, 'user-1');
    realtime.calls.single.controller.add({
      'achievement_id': 'ach-1',
      'code': 'first_step',
      'name': 'Primeiro passo',
      'icon': null,
    });
    await Future<void>.delayed(Duration.zero);

    expect(names, ['Primeiro passo']);
    await sub.cancel();
  });

  test('sign-out cancels the previous watchInserts subscription', () async {
    final names = <String>[];
    final sub = sut.watch().listen((data) => names.add(data.name));
    await Future<void>.delayed(Duration.zero);

    expect(realtime.calls, hasLength(1));
    final first = realtime.calls.single;

    auth.currentSession = null;
    auth.controller.add(const AuthStateChange(kind: AuthChangeKind.signedOut));
    await Future<void>.delayed(Duration.zero);

    expect(first.cancelled, isTrue);
    // No active listener after cancel — adding must not reach [names].
    expect(first.controller.hasListener, isFalse);
    expect(names, isEmpty);

    await sub.cancel();
  });

  test('user switch opens a new watchInserts for the next user id', () async {
    final names = <String>[];
    final sub = sut.watch().listen((data) => names.add(data.name));
    await Future<void>.delayed(Duration.zero);

    expect(realtime.calls.single.filterValue, 'user-1');

    auth.currentSession = user2;
    auth.controller.add(
      const AuthStateChange(kind: AuthChangeKind.signedIn, session: user2),
    );
    await Future<void>.delayed(Duration.zero);

    expect(realtime.calls, hasLength(2));
    expect(realtime.calls.first.cancelled, isTrue);
    expect(realtime.calls.last.filterValue, 'user-2');

    realtime.calls.last.controller.add({
      'achievement_id': 'ach-2',
      'code': 'second',
      'name': 'Segundo',
      'icon': null,
    });
    await Future<void>.delayed(Duration.zero);
    expect(names, ['Segundo']);

    await sub.cancel();
  });
}
