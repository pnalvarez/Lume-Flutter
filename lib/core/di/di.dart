import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/usecases/get_arcade_record.dart';
import 'package:lume/layers/domain/usecases/get_game_round.dart';
import 'package:lume/layers/domain/usecases/get_hub_games.dart';
import 'package:lume/layers/domain/usecases/get_profile.dart';
import 'package:lume/layers/domain/usecases/get_random_game_round.dart';
import 'package:lume/layers/domain/usecases/sign_out.dart';
import 'package:lume/layers/presentation/screens/games/games_hub_bloc.dart';
import 'package:lume/layers/presentation/screens/profile/profile_bloc.dart';

import 'di.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  await getIt.reset();
  await getIt.init();
  _registerGamesHubBloc();
  _registerProfileBloc();
}

/// [di.config.dart] is gitignored; re-register so every use case is wired.
void _registerGamesHubBloc() {
  if (getIt.isRegistered<GamesHubBloc>()) {
    getIt.unregister<GamesHubBloc>();
  }
  getIt.registerFactory<GamesHubBloc>(
    () => GamesHubBloc(
      getIt<IGetHubGames>(),
      getIt<IGetGameRound>(),
      getIt<IGetArcadeRecord>(),
      getIt<IGetRandomGameRound>(),
    ),
  );
}

void _registerProfileBloc() {
  if (getIt.isRegistered<ProfileBloc>()) {
    getIt.unregister<ProfileBloc>();
  }
  getIt.registerFactory<ProfileBloc>(
    () => ProfileBloc(getIt<IGetProfile>(), getIt<ISignOut>()),
  );
}
