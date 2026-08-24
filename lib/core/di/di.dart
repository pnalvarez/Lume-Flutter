import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/usecases/get_game_round.dart';
import 'package:lume/layers/domain/usecases/get_hub_games.dart';
import 'package:lume/layers/presentation/screens/games/games_hub_bloc.dart';

import 'di.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  await getIt.reset();
  await getIt.init();
  _registerGamesHubBloc();
}

/// [di.config.dart] is gitignored; re-register so both use cases are wired.
void _registerGamesHubBloc() {
  if (getIt.isRegistered<GamesHubBloc>()) {
    getIt.unregister<GamesHubBloc>();
  }
  getIt.registerFactory<GamesHubBloc>(
    () => GamesHubBloc(getIt<IGetHubGames>(), getIt<IGetGameRound>()),
  );
}
