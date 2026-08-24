import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/data/models/game_data.dart';
import 'package:lume/layers/data/models/hub_game_data.dart';
import 'package:lume/layers/data/repository/game_repository.dart';
import 'package:lume/layers/domain/models/game/hub_game_domain.dart';
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

  test('getHubGames maps catalog rows into HubGameDomain', () async {
    when(dataSource.fetchHubGames(forceRefresh: false)).thenAnswer(
      (_) async => [
        HubGameData.fromJson({
          'id': 'abc',
          'slug': 'quiz_relampago',
          'name': 'Quiz Relâmpago',
          'description': 'Rápido',
          'icon': 'Zap',
          'color_hex': '#F5A623',
          'hub_section': 'general',
          'order_index': 1,
        }),
      ],
    );

    final games = await sut.getHubGames();

    expect(games, hasLength(1));
    expect(games.single.slug, 'quiz_relampago');
    expect(games.single.hubSection, HubSection.general);
    expect(games.single.colorHex, '#F5A623');
  });
}
