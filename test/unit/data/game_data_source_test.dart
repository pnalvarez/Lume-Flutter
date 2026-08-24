import 'package:flutter_test/flutter_test.dart';
import 'package:lume/core/storage/in_memory_storage_client.dart';
import 'package:lume/layers/data/datasource/game_data_source.dart';
import 'package:lume/layers/data/models/game_type.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/mocks.mocks.dart';

void main() {
  late MockIApiClient apiClient;
  late InMemoryStorageClient storage;
  late GameDataSource sut;

  setUp(() {
    apiClient = MockIApiClient();
    storage = InMemoryStorageClient();
    sut = GameDataSource(apiClient, storage);
  });

  test(
    'fetchSubmoduleGames posts p_submodule_id and parses SubmoduleGamesData',
    () async {
      when(
        apiClient.rpc<Map<String, dynamic>>(
          'get_submodule_games',
          params: anyNamed('params'),
          headers: anyNamed('headers'),
        ),
      ).thenAnswer(
        (_) async => {
          'id': 9,
          'title': 'Preview',
          'sort_order': 1,
          'games': [
            {
              'pair_id': 1,
              'sort_order': 1,
              'game_format': 'who_am_i',
              'game_payload': {
                'header': 'Header',
                'hints': ['Hint'],
                'correct_answer': 'answer',
                'accepted_synonyms': [],
                'explanation': 'Explanation',
              },
            },
          ],
        },
      );

      final data = await sut.fetchSubmoduleGames(submoduleId: 9);

      expect(data.id, 9);
      expect(data.title, 'Preview');
      expect(data.games.single.gameType, GameType.whoAmI);
      verify(
        apiClient.rpc<Map<String, dynamic>>(
          'get_submodule_games',
          params: {'p_submodule_id': 9},
        ),
      ).called(1);
    },
  );

  test(
    'fetchHubGames posts get_hub_games and parses HubGameData list',
    () async {
      when(
        apiClient.rpc<List<dynamic>>(
          'get_hub_games',
          params: anyNamed('params'),
          headers: anyNamed('headers'),
        ),
      ).thenAnswer(
        (_) async => [
          {
            'id': 'abc',
            'slug': 'quiz_relampago',
            'name': 'Quiz Relâmpago',
            'description': 'Rápido',
            'icon': 'Zap',
            'color_hex': '#F5A623',
            'hub_section': 'general',
            'order_index': 1,
          },
        ],
      );

      final data = await sut.fetchHubGames();

      expect(data, hasLength(1));
      expect(data.single.slug, 'quiz_relampago');
      expect(data.single.colorHex, '#F5A623');
      verify(apiClient.rpc<List<dynamic>>('get_hub_games')).called(1);
    },
  );
}
