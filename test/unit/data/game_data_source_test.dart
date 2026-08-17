import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/data/datasource/game_data_source.dart';
import 'package:lume/layers/data/models/game_type.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/mocks.mocks.dart';

void main() {
  late MockApiClient apiClient;
  late RemoteGameDataSource sut;

  setUp(() {
    apiClient = MockApiClient();
    sut = RemoteGameDataSource(apiClient);
  });

  test('fetchSubmoduleGames posts p_submodule_id and parses SubmoduleGamesData',
      () async {
    when(
      apiClient.rpc<Map<String, dynamic>>(
        'get_submodule_games',
        params: anyNamed('params'),
        headers: anyNamed('headers'),
      ),
    ).thenAnswer((_) async => {
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
        });

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
  });
}
