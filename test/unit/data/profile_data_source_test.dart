import 'package:flutter_test/flutter_test.dart';
import 'package:lume/core/storage/in_memory_storage_client.dart';
import 'package:lume/layers/data/datasource/profile_data_source.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/mocks.mocks.dart';

void main() {
  late MockIApiClient apiClient;
  late InMemoryStorageClient storage;
  late ProfileDataSource sut;

  setUp(() {
    apiClient = MockIApiClient();
    storage = InMemoryStorageClient();
    sut = ProfileDataSource(apiClient, storage);
  });

  test('fetchProfile parses get_profile into ProfileData', () async {
    when(
      apiClient.rpc<Map<String, dynamic>>(
        'get_profile',
        params: anyNamed('params'),
        headers: anyNamed('headers'),
      ),
    ).thenAnswer(
      (_) async => {
        'id': 'user-1',
        'full_name': 'Ada',
        'created_at': '2026-08-01T12:00:00Z',
        'age': 28,
        'player_level': 3,
        'total_xp': 341,
        'current_streak': 0,
        'best_streak': 0,
        'xp_today': 0,
        'xp_week': 341,
        'days_in_app': 0,
        'submodules_completed': 0,
      },
    );

    final data = await sut.fetchProfile();

    expect(data.id, 'user-1');
    expect(data.fullName, 'Ada');
    expect(data.createdAt, DateTime.utc(2026, 8, 1, 12));
    expect(data.age, 28);
    expect(data.playerLevel, 3);
    expect(data.totalXp, 341);
    expect(data.currentStreak, 0);
    expect(data.xpWeek, 341);
    expect(data.daysInApp, 0);
    expect(data.submodulesCompleted, 0);
    verify(apiClient.rpc<Map<String, dynamic>>('get_profile')).called(1);
  });

  test(
    'fetchProfile returns cached profile without calling RPC again',
    () async {
      when(
        apiClient.rpc<Map<String, dynamic>>(
          'get_profile',
          params: anyNamed('params'),
          headers: anyNamed('headers'),
        ),
      ).thenAnswer((_) async => {'id': 'user-1', 'full_name': 'Ada'});

      await sut.fetchProfile();
      final cached = await sut.fetchProfile();

      expect(cached.fullName, 'Ada');
      expect(cached.playerLevel, 1);
      expect(cached.totalXp, 0);
      verify(apiClient.rpc<Map<String, dynamic>>('get_profile')).called(1);
    },
  );

  test('fetchProfile treats invalid created_at as null', () async {
    when(
      apiClient.rpc<Map<String, dynamic>>(
        'get_profile',
        params: anyNamed('params'),
        headers: anyNamed('headers'),
      ),
    ).thenAnswer(
      (_) async => {
        'id': 'user-1',
        'full_name': 'Ada',
        'created_at': 'not-a-date',
      },
    );

    final data = await sut.fetchProfile();

    expect(data.createdAt, isNull);
  });
}
