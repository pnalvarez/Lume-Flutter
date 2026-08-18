import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/data/models/category_data.dart';
import 'package:lume/layers/data/models/game_data.dart';
import 'package:lume/layers/data/repository/game_repository.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/mocks.mocks.dart';

void main() {
  late MockIGameDataSource dataSource;
  late GameRepository sut;

  setUp(() {
    dataSource = MockIGameDataSource();
    sut = GameRepository(dataSource);
  });

  test('getSubmoduleGames maps data into SubmoduleGamesDomain', () async {
    when(
      dataSource.fetchSubmoduleGames(submoduleId: 9, forceRefresh: false),
    ).thenAnswer(
      (_) async => SubmoduleGamesData.fromJson({
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
      }),
    );

    final domain = await sut.getSubmoduleGames(submoduleId: 9);

    expect(domain.id, 9);
    expect(domain.games.single, isA<WhoAmIGameDomain>());
    verify(
      dataSource.fetchSubmoduleGames(submoduleId: 9, forceRefresh: false),
    ).called(1);
  });
}
