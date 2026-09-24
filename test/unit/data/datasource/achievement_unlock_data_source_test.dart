import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:lume/core/auth/auth_session.dart';
import 'package:lume/core/auth/auth_session_provider.dart';
import 'package:lume/core/realtime/realtime_client.dart';
import 'package:lume/layers/data/datasource/achievement_unlock_data_source.dart';

import '../../../helpers/fake_auth_service.dart';

class _FakeRealtime implements IRealtimeClient {
  final controller = StreamController<Map<String, dynamic>>.broadcast();
  final filterValues = <String>[];
  final tables = <String>[];

  @override
  Stream<Map<String, dynamic>> watchInserts({
    required String table,
    required String filterColumn,
    required String filterValue,
    String schema = 'public',
  }) {
    tables.add(table);
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
  late AchievementUnlockDataSource sut;

  setUp(() {
    auth = FakeAuthService(currentSession: snapshot);
    session = AuthSessionProvider(auth);
    realtime = _FakeRealtime();
    sut = AchievementUnlockDataSource(realtime, session);
  });

  tearDown(() async {
    session.dispose();
    await auth.dispose();
    await realtime.controller.close();
  });

  test('maps realtime inserts for the signed-in user', () async {
    final names = <String>[];
    final sub = sut.watch().listen((data) => names.add(data.name));
    await Future<void>.delayed(Duration.zero);

    expect(realtime.tables, ['player_achievement_events']);
    expect(realtime.filterValues, ['user-1']);
    realtime.controller.add({
      'achievement_id': 'ach-1',
      'code': 'first_step',
      'name': 'Primeiro passo',
      'icon': null,
    });
    await Future<void>.delayed(Duration.zero);

    expect(names, ['Primeiro passo']);
    await sub.cancel();
  });
}
