import 'package:flutter_test/flutter_test.dart';
import 'package:lume/core/auth/auth_session.dart';
import 'package:lume/core/storage/in_memory_storage_client.dart';
import 'package:lume/layers/data/datasource/profile_data_source.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/fake_auth_service.dart';
import '../../helpers/mocks.mocks.dart';

void main() {
  late MockIApiClient apiClient;
  late InMemoryStorageClient storage;
  late FakeAuthService auth;
  late ProfileDataSource sut;

  setUp(() {
    apiClient = MockIApiClient();
    storage = InMemoryStorageClient();
    auth = FakeAuthService();
    sut = ProfileDataSource(apiClient, storage, auth);
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

  test('fetchProfile treats invalid created_at as null without auth', () async {
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

  test(
    'fetchProfile falls back to auth session createdAt when RPC omits it',
    () async {
      auth.currentSession = AuthSessionSnapshot(
        accessToken: 'jwt',
        userId: 'user-1',
        email: 'ada@example.com',
        isEmailConfirmed: true,
        createdAt: DateTime.utc(2026, 9, 13, 12),
      );
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
          // no created_at — mirrors live get_profile
        },
      );

      final data = await sut.fetchProfile();

      expect(data.createdAt, DateTime.utc(2026, 9, 13, 12));
    },
  );

  test(
    'fetchProfile prefers RPC created_at over auth session createdAt',
    () async {
      auth.currentSession = AuthSessionSnapshot(
        accessToken: 'jwt',
        userId: 'user-1',
        isEmailConfirmed: true,
        createdAt: DateTime.utc(2026, 1, 1),
      );
      when(
        apiClient.rpc<Map<String, dynamic>>(
          'get_profile',
          params: anyNamed('params'),
          headers: anyNamed('headers'),
        ),
      ).thenAnswer(
        (_) async => {'id': 'user-1', 'created_at': '2026-08-01T12:00:00Z'},
      );

      final data = await sut.fetchProfile();

      expect(data.createdAt, DateTime.utc(2026, 8, 1, 12));
    },
  );

  test(
    'fetchProfile enriches cached profile missing created_at from auth',
    () async {
      auth.currentSession = AuthSessionSnapshot(
        accessToken: 'jwt',
        userId: 'user-1',
        isEmailConfirmed: true,
        createdAt: DateTime.utc(2026, 9, 13, 12),
      );
      when(
        apiClient.rpc<Map<String, dynamic>>(
          'get_profile',
          params: anyNamed('params'),
          headers: anyNamed('headers'),
        ),
      ).thenAnswer((_) async => {'id': 'user-1', 'full_name': 'Ada'});

      // First fetch caches without RPC created_at; auth fills it.
      await sut.fetchProfile();
      // Clear auth then re-read cache — createdAt should already be persisted.
      auth.currentSession = null;
      final cached = await sut.fetchProfile();

      expect(cached.createdAt, DateTime.utc(2026, 9, 13, 12));
      verify(apiClient.rpc<Map<String, dynamic>>('get_profile')).called(1);
    },
  );
}
