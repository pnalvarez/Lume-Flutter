import 'package:mockito/annotations.dart';

import 'package:lume/core/auth/auth_token_provider.dart';
import 'package:lume/core/network/api_client.dart';
import 'package:lume/core/storage/storage_client.dart';
import 'package:lume/layers/data/datasource/category_preference_data_source.dart';
import 'package:lume/layers/data/datasource/game_data_source.dart';
import 'package:lume/layers/data/datasource/profile_data_source.dart';
import 'package:lume/layers/data/datasource/trail_data_source.dart';
import 'package:lume/layers/domain/repository/category_preference_repository.dart';
import 'package:lume/layers/domain/repository/game_repository.dart';
import 'package:lume/layers/domain/repository/profile_repository.dart';
import 'package:lume/layers/domain/repository/trail_repository.dart';
import 'package:lume/layers/domain/usecases/get_categories_with_preferences.dart';
import 'package:lume/layers/domain/usecases/get_game_trails.dart';
import 'package:lume/layers/domain/usecases/get_hub_games.dart';
import 'package:lume/layers/domain/usecases/get_profile.dart';
import 'package:lume/layers/domain/usecases/get_submodule_games.dart';
import 'package:lume/layers/domain/usecases/get_trail_bootstrap.dart';
import 'package:lume/layers/domain/usecases/get_trail_progress.dart';
import 'package:lume/layers/domain/usecases/save_category_preferences.dart';
import 'package:lume/layers/domain/usecases/save_pair_progress.dart';

@GenerateNiceMocks([
  MockSpec<IApiClient>(),
  MockSpec<IAuthTokenProvider>(),
  MockSpec<IAuthTokenProvider>(as: #MockAuthTokenProvider),
  MockSpec<IStorageClient>(),
  MockSpec<ITrailDataSource>(),
  MockSpec<IGameDataSource>(),
  MockSpec<IProfileDataSource>(),
  MockSpec<ICategoryPreferenceDataSource>(),
  MockSpec<IProfileRepository>(),
  MockSpec<ICategoryPreferenceRepository>(),
  MockSpec<ITrailRepository>(),
  MockSpec<IGameRepository>(),
  MockSpec<IGetProfile>(),
  MockSpec<IGetCategoriesWithPreferences>(),
  MockSpec<ISaveCategoryPreferences>(),
  MockSpec<IGetTrailBootstrap>(),
  MockSpec<IGetTrailProgress>(),
  MockSpec<IGetGameTrails>(),
  MockSpec<IGetHubGames>(),
  MockSpec<ISavePairProgress>(),
  MockSpec<IGetSubmoduleGames>(),
])
void main() {}
