import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/common/strings/games_hub_strings.dart';
import 'package:lume/layers/domain/models/game/hub_game_domain.dart';
import 'package:lume/layers/domain/models/game/hub_game_round_domain.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';
import 'package:lume/layers/domain/usecases/get_game_round.dart';
import 'package:lume/layers/domain/usecases/get_hub_games.dart';
import 'package:lume/layers/presentation/screens/games/games_hub_bloc.dart';
import 'package:lume/layers/presentation/screens/games/games_hub_event.dart';
import 'package:lume/layers/presentation/screens/games/games_hub_state.dart';

class _GetHubGames implements IGetHubGames {
  List<HubGameDomain> result = const [
    HubGameDomain(
      id: '1',
      slug: 'quiz_relampago',
      name: 'Quiz Relâmpago',
      description: 'Rápido',
      icon: 'Zap',
      colorHex: '#F5A623',
      hubSection: HubSection.general,
      orderIndex: 1,
    ),
    HubGameDomain(
      id: '2',
      slug: 'giro_pelo_mundo',
      name: 'Giro pelo Mundo',
      description: 'Visual',
      icon: 'Globe',
      colorHex: '#7BC8A4',
      hubSection: HubSection.visual,
      orderIndex: 100,
    ),
  ];
  Object? error;

  @override
  Future<List<HubGameDomain>> call({bool forceRefresh = false}) async {
    if (error != null) throw error!;
    return result;
  }
}

class _GetGameRound implements IGetGameRound {
  HubGameRoundDomain? result;
  Object? error;

  @override
  Future<HubGameRoundDomain> call({
    required String gameSlug,
    int limit = 5,
  }) async {
    if (error != null) throw error!;
    return result ??
        HubGameRoundDomain(
          gameSlug: gameSlug,
          gameName: 'Quiz',
          games: const [
            LightningQuizGameDomain(
              pairId: 1,
              sortOrder: 1,
              prompt: 'Q?',
              options: ['A', 'B'],
              correctIndex: 0,
              explanation: 'Because',
            ),
          ],
        );
  }
}

void main() {
  late _GetHubGames getHubGames;
  late _GetGameRound getGameRound;

  setUp(() {
    getHubGames = _GetHubGames();
    getGameRound = _GetGameRound();
  });

  GamesHubBloc buildBloc() => GamesHubBloc(getHubGames, getGameRound);

  blocTest<GamesHubBloc, GamesHubState>(
    'loads hub games into general and visual sections',
    build: buildBloc,
    act: (bloc) => bloc.add(const GamesHubStarted()),
    expect: () => [
      const GamesHubState(isInitialLoading: true),
      isA<GamesHubState>()
          .having((s) => s.isInitialLoading, 'isInitialLoading', isFalse)
          .having((s) => s.generalGames, 'general', hasLength(1))
          .having((s) => s.visualGames, 'visual', hasLength(1)),
    ],
  );

  blocTest<GamesHubBloc, GamesHubState>(
    'emits error when load fails',
    build: () {
      getHubGames.error = Exception('boom');
      return buildBloc();
    },
    act: (bloc) => bloc.add(const GamesHubStarted()),
    expect: () => [
      const GamesHubState(isInitialLoading: true),
      const GamesHubState(
        isInitialLoading: false,
        initialErrorMessage: gamesHubLoadError,
      ),
    ],
  );

  blocTest<GamesHubBloc, GamesHubState>(
    'fetches round and opens play when game is pressed',
    build: buildBloc,
    seed: () => const GamesHubState(isInitialLoading: false),
    act: (bloc) => bloc.add(const GamesHubGamePressed('quiz_relampago')),
    expect: () => [
      const GamesHubState(isInitialLoading: false, isLoadingGame: true),
      isA<GamesHubState>()
          .having((s) => s.isLoadingGame, 'isLoadingGame', isFalse)
          .having((s) => s.openPlayRounds, 'openPlayRounds', isNotNull)
          .having((s) => s.openPlayRounds, 'round count', hasLength(1)),
    ],
  );

  blocTest<GamesHubBloc, GamesHubState>(
    'emits round error when fetch fails',
    build: () {
      getGameRound.error = Exception('boom');
      return buildBloc();
    },
    seed: () => const GamesHubState(isInitialLoading: false),
    act: (bloc) => bloc.add(const GamesHubGamePressed('quiz_relampago')),
    expect: () => [
      const GamesHubState(isInitialLoading: false, isLoadingGame: true),
      const GamesHubState(
        isInitialLoading: false,
        gameRoundErrorMessage: gamesHubRoundLoadError,
      ),
    ],
  );
}
