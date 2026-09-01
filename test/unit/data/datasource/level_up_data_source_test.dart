import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:lume/core/auth/auth_session.dart';
import 'package:lume/core/auth/auth_session_provider.dart';
import 'package:lume/core/realtime/realtime_client.dart';
import 'package:lume/layers/data/datasource/level_up_data_source.dart';

import '../../../helpers/fake_auth_service.dart';

class _FakeRealtime implements IRealtimeClient {
  final controller = StreamController<Map<String, dynamic>>.broadcast();
  final filterValues = <String>[];

  @override
  Stream<Map<String, dynamic>> watchInserts({
    required String table,
    required String filterColumn,
    required String filterValue,
    String schema = 'public',
  }) {
    filterValues.add(filterValue);
    return controller.stream;
  }
}

void main() {
  const snapshot = AuthSessionSnapshot(
    accessToken: 'jwt',
    userId: 'user-1',
    email: 'ada@example.com',
    isEmailConfirmed: true,
  );

  late FakeAuthService auth;
  late AuthSessionProvider session;
  late _FakeRealtime realtime;
  late LevelUpDataSource sut;

  setUp(() {
    auth = FakeAuthService(currentSession: snapshot);
    session = AuthSessionProvider(auth);
    realtime = _FakeRealtime();
    sut = LevelUpDataSource(realtime, session);
  });

  tearDown(() async {
    session.dispose();
    await auth.dispose();
    await realtime.controller.close();
  });

  test('maps realtime inserts for the signed-in user', () async {
    final rows = <int>[];
    final sub = sut.watch().listen((data) => rows.add(data.level));
    await Future<void>.delayed(Duration.zero);

    expect(realtime.filterValues, ['user-1']);
    realtime.controller.add({
      'level': 3,
      'total_xp': 103,
      'xp_level_offset': 100,
      'xp_next_level_at': 200,
    });
    await Future<void>.delayed(Duration.zero);

    expect(rows, [3]);
    await sub.cancel();
  });
}
