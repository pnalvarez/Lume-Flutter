import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/common/strings/games_hub_strings.dart';
import 'package:lume/layers/domain/models/game/hub_game_domain.dart';
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

void main() {
  late _GetHubGames getHubGames;

  setUp(() {
    getHubGames = _GetHubGames();
  });

  blocTest<GamesHubBloc, GamesHubState>(
    'loads hub games into general and visual sections',
    build: () => GamesHubBloc(getHubGames),
    act: (bloc) => bloc.add(const GamesHubStarted()),
    expect: () => [
      const GamesHubState(status: GamesHubStatus.loading),
      isA<GamesHubState>()
          .having((s) => s.status, 'status', GamesHubStatus.ready)
          .having((s) => s.generalGames, 'general', hasLength(1))
          .having((s) => s.visualGames, 'visual', hasLength(1)),
    ],
  );

  blocTest<GamesHubBloc, GamesHubState>(
    'emits error when load fails',
    build: () {
      getHubGames.error = Exception('boom');
      return GamesHubBloc(getHubGames);
    },
    act: (bloc) => bloc.add(const GamesHubStarted()),
    expect: () => [
      const GamesHubState(status: GamesHubStatus.loading),
      const GamesHubState(
        status: GamesHubStatus.error,
        errorMessage: gamesHubLoadError,
      ),
    ],
  );
}
