import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:lume/core/auth/auth_session_provider.dart';
import 'package:lume/core/realtime/realtime_client.dart';
import 'package:lume/layers/data/datasource/level_up_data_source.dart';
import 'package:lume/layers/data/repository/level_up_repository.dart';
import 'package:lume/layers/domain/repository/level_up_repository.dart';
import 'package:lume/layers/domain/usecases/get_arcade_record.dart';
import 'package:lume/layers/domain/usecases/get_game_round.dart';
import 'package:lume/layers/domain/usecases/get_hub_games.dart';
import 'package:lume/layers/domain/usecases/get_profile.dart';
import 'package:lume/layers/domain/usecases/get_random_game_round.dart';
import 'package:lume/layers/domain/usecases/sign_out.dart';
import 'package:lume/layers/domain/usecases/watch_level_up_events.dart';
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
  _registerLevelUpWatcher();
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

void _registerLevelUpWatcher() {
  if (!getIt.isRegistered<IRealtimeClient>()) {
    getIt.registerLazySingleton<IRealtimeClient>(RealtimeClient.new);
  }
  if (!getIt.isRegistered<ILevelUpDataSource>()) {
    getIt.registerLazySingleton<ILevelUpDataSource>(
      () => LevelUpDataSource(
        getIt<IRealtimeClient>(),
        getIt<IAuthSessionProvider>(),
      ),
    );
  }
  if (!getIt.isRegistered<ILevelUpRepository>()) {
    getIt.registerLazySingleton<ILevelUpRepository>(
      () => LevelUpRepository(getIt<ILevelUpDataSource>()),
    );
  }
  if (!getIt.isRegistered<IWatchLevelUpEvents>()) {
    getIt.registerLazySingleton<IWatchLevelUpEvents>(
      () => WatchLevelUpEvents(getIt<ILevelUpRepository>()),
    );
  }
}
