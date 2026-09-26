import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:lume/core/analytics/analytics.dart';
import 'package:lume/core/auth/auth_session_provider.dart';
import 'package:lume/core/realtime/realtime_client.dart';
import 'package:lume/core/remote_config/remote_config.dart';
import 'package:lume/layers/data/datasource/achievement_unlock_data_source.dart';
import 'package:lume/layers/data/datasource/level_up_data_source.dart';
import 'package:lume/layers/data/repository/achievement_unlock_repository.dart';
import 'package:lume/layers/data/repository/level_up_repository.dart';
import 'package:lume/layers/domain/repository/achievement_unlock_repository.dart';
import 'package:lume/layers/domain/repository/level_up_repository.dart';
import 'package:lume/core/network/api_client.dart';
import 'package:lume/layers/data/datasource/achievements_data_source.dart';
import 'package:lume/layers/data/repository/achievements_repository.dart';
import 'package:lume/layers/domain/repository/achievements_repository.dart';
import 'package:lume/layers/domain/usecases/get_achievements.dart';
import 'package:lume/layers/domain/usecases/get_arcade_record.dart';
import 'package:lume/layers/domain/usecases/get_game_round.dart';
import 'package:lume/layers/domain/usecases/get_hub_games.dart';
import 'package:lume/layers/domain/usecases/get_profile.dart';
import 'package:lume/layers/domain/usecases/get_random_game_round.dart';
import 'package:lume/layers/domain/usecases/sign_out.dart';
import 'package:lume/layers/domain/usecases/watch_achievement_unlocks.dart';
import 'package:lume/layers/domain/usecases/watch_level_up_events.dart';
import 'package:lume/layers/presentation/screens/achievements/achievements_bloc.dart';
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
  _registerAchievementsBloc();
  _registerLevelUpWatcher();
  _registerAchievementUnlockWatcher();
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
      getIt<IRemoteConfig>(),
      getIt<IAnalytics>(),
    ),
  );
}

void _registerProfileBloc() {
  if (getIt.isRegistered<ProfileBloc>()) {
    getIt.unregister<ProfileBloc>();
  }
  getIt.registerFactory<ProfileBloc>(
    () => ProfileBloc(
      getIt<IGetProfile>(),
      getIt<ISignOut>(),
      getIt<IAnalytics>(),
    ),
  );
}

/// [di.config.dart] is gitignored; re-register so every use case is wired.
void _registerAchievementsBloc() {
  if (!getIt.isRegistered<IAchievementsDataSource>()) {
    getIt.registerLazySingleton<IAchievementsDataSource>(
      () => AchievementsDataSource(getIt<IApiClient>()),
    );
  }
  if (!getIt.isRegistered<IAchievementsRepository>()) {
    getIt.registerLazySingleton<IAchievementsRepository>(
      () => AchievementsRepository(getIt<IAchievementsDataSource>()),
    );
  }
  if (!getIt.isRegistered<IGetAchievements>()) {
    getIt.registerLazySingleton<IGetAchievements>(
      () => GetAchievements(getIt<IAchievementsRepository>()),
    );
  }
  if (getIt.isRegistered<AchievementsBloc>()) {
    getIt.unregister<AchievementsBloc>();
  }
  getIt.registerFactory<AchievementsBloc>(
    () => AchievementsBloc(
      getIt<IGetAchievements>(),
      getIt<IAnalytics>(),
      getIt<IRemoteConfig>(),
    ),
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

void _registerAchievementUnlockWatcher() {
  if (!getIt.isRegistered<IRealtimeClient>()) {
    getIt.registerLazySingleton<IRealtimeClient>(RealtimeClient.new);
  }
  if (!getIt.isRegistered<IAchievementUnlockDataSource>()) {
    getIt.registerLazySingleton<IAchievementUnlockDataSource>(
      () => AchievementUnlockDataSource(
        getIt<IRealtimeClient>(),
        getIt<IAuthSessionProvider>(),
      ),
    );
  }
  if (!getIt.isRegistered<IAchievementUnlockRepository>()) {
    getIt.registerLazySingleton<IAchievementUnlockRepository>(
      () => AchievementUnlockRepository(getIt<IAchievementUnlockDataSource>()),
    );
  }
  if (!getIt.isRegistered<IWatchAchievementUnlocks>()) {
    getIt.registerLazySingleton<IWatchAchievementUnlocks>(
      () => WatchAchievementUnlocks(getIt<IAchievementUnlockRepository>()),
    );
  }
}
