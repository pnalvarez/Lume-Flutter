import 'package:lume/core/auth/auth_token_provider.dart';
import 'package:lume/core/network/api_client.dart';
import 'package:lume/layers/data/datasource/category_preference_data_source.dart';
import 'package:lume/layers/data/datasource/game_data_source.dart';
import 'package:lume/layers/data/datasource/profile_data_source.dart';
import 'package:lume/layers/data/datasource/trail_data_source.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([
  MockSpec<ApiClient>(),
  MockSpec<AuthTokenProvider>(),
  MockSpec<TrailDataSource>(),
  MockSpec<GameDataSource>(),
  MockSpec<ProfileDataSource>(),
  MockSpec<CategoryPreferenceDataSource>(),
])
void main() {}
