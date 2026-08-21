import 'package:flutter_test/flutter_test.dart';
import 'package:lume/core/storage/in_memory_storage_client.dart';
import 'package:lume/layers/data/datasource/trail_data_source.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/mocks.mocks.dart';

void main() {
  late MockIApiClient apiClient;
  late InMemoryStorageClient storage;
  late TrailDataSource sut;

  setUp(() {
    apiClient = MockIApiClient();
    storage = InMemoryStorageClient();
    sut = TrailDataSource(apiClient, storage);
  });

  test(
    'fetchBootstrap parses English RPC JSON into TrailBootstrapData',
    () async {
      when(
        apiClient.rpc<Map<String, dynamic>>(
          'get_trail_bootstrap',
          params: anyNamed('params'),
          headers: anyNamed('headers'),
        ),
      ).thenAnswer(
        (_) async => {
          'trail_started_at': '2026-08-17T12:00:00Z',
          'modules': [
            {
              'id': 1,
              'sort_order': 1,
              'title': 'History',
              'emoji': '📜',
              'color': '#111',
            },
          ],
        },
      );

      final data = await sut.fetchBootstrap();

      expect(data.modules, hasLength(1));
      expect(data.modules.first.title, 'History');
      expect(data.trailStartedAt, DateTime.utc(2026, 8, 17, 12));
      verify(
        apiClient.rpc<Map<String, dynamic>>('get_trail_bootstrap'),
      ).called(1);
    },
  );

  test(
    'fetchGameTrails parses nested English JSON into GameTrailData',
    () async {
      when(
        apiClient.rpc<List<dynamic>>(
          'get_game_trails',
          params: anyNamed('params'),
          headers: anyNamed('headers'),
        ),
      ).thenAnswer(
        (_) async => [
          {
            'id': 1,
            'title': 'History',
            'emoji': '📜',
            'sort_order': 1,
            'levels': [
              {'id': 2, 'title': 'Level 1', 'sort_order': 1, 'submodules': []},
            ],
          },
        ],
      );

      final data = await sut.fetchGameTrails();

      expect(data, hasLength(1));
      expect(data.first.title, 'History');
      expect(data.first.levels.first.title, 'Level 1');
      verify(apiClient.rpc<List<dynamic>>('get_game_trails')).called(1);
    },
  );

  test('savePairProgress posts pair id and score', () async {
    when(
      apiClient.rpc<Map<String, dynamic>>(
        'save_pair_progress',
        params: anyNamed('params'),
        headers: anyNamed('headers'),
      ),
    ).thenAnswer(
      (_) async => {
        'pair_id': 4,
        'completed': true,
        'score_pct': 80,
        'preview_seen': true,
      },
    );

    final data = await sut.savePairProgress(pairId: 4, scorePct: 80);

    expect(data.completed, isTrue);
    expect(data.scorePct, 80);
    verify(
      apiClient.rpc<Map<String, dynamic>>(
        'save_pair_progress',
        params: {'p_pair_id': 4, 'p_score_pct': 80},
      ),
    ).called(1);
  });
}
