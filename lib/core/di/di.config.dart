// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:lume/app/di/register_module.dart' as _i73;
import 'package:lume/app/navigation/app_router.dart' as _i617;
import 'package:lume/core/auth/auth_service.dart' as _i427;
import 'package:lume/core/auth/auth_session_provider.dart' as _i82;
import 'package:lume/core/auth/auth_token_provider.dart' as _i325;
import 'package:lume/core/config/app_config.dart' as _i754;
import 'package:lume/core/di/register_module.dart' as _i633;
import 'package:lume/core/network/api_client.dart' as _i101;
import 'package:lume/core/storage/storage_client.dart' as _i433;
import 'package:lume/layers/data/datasource/auth_data_source.dart' as _i434;
import 'package:lume/layers/data/datasource/category_preference_data_source.dart'
    as _i874;
import 'package:lume/layers/data/datasource/game_data_source.dart' as _i547;
import 'package:lume/layers/data/datasource/profile_data_source.dart' as _i527;
import 'package:lume/layers/data/datasource/trail_data_source.dart' as _i739;
import 'package:lume/layers/data/repository/auth_repository.dart' as _i714;
import 'package:lume/layers/data/repository/category_preference_repository.dart'
    as _i680;
import 'package:lume/layers/data/repository/game_repository.dart' as _i448;
import 'package:lume/layers/data/repository/onboarding_repository.dart'
    as _i842;
import 'package:lume/layers/data/repository/profile_repository.dart' as _i1072;
import 'package:lume/layers/data/repository/trail_repository.dart' as _i406;
import 'package:lume/layers/domain/repository/auth_repository.dart' as _i451;
import 'package:lume/layers/domain/repository/category_preference_repository.dart'
    as _i777;
import 'package:lume/layers/domain/repository/game_repository.dart' as _i131;
import 'package:lume/layers/domain/repository/onboarding_repository.dart'
    as _i588;
import 'package:lume/layers/domain/repository/profile_repository.dart' as _i155;
import 'package:lume/layers/domain/repository/trail_repository.dart' as _i314;
import 'package:lume/layers/domain/usecases/clear_password_recovery.dart'
    as _i329;
import 'package:lume/layers/domain/usecases/get_categories_with_preferences.dart'
    as _i976;
import 'package:lume/layers/domain/usecases/get_game_trails.dart' as _i729;
import 'package:lume/layers/domain/usecases/get_profile.dart' as _i188;
import 'package:lume/layers/domain/usecases/get_submodule_games.dart' as _i97;
import 'package:lume/layers/domain/usecases/get_trail_bootstrap.dart' as _i37;
import 'package:lume/layers/domain/usecases/get_trail_progress.dart' as _i1046;
import 'package:lume/layers/domain/usecases/has_seen_onboarding.dart' as _i281;
import 'package:lume/layers/domain/usecases/has_selected_categories.dart'
    as _i254;
import 'package:lume/layers/domain/usecases/mark_onboarding_seen.dart' as _i167;
import 'package:lume/layers/domain/usecases/observe_auth_state.dart' as _i665;
import 'package:lume/layers/domain/usecases/request_password_recovery.dart'
    as _i102;
import 'package:lume/layers/domain/usecases/resend_confirmation_email.dart'
    as _i683;
import 'package:lume/layers/domain/usecases/restore_session.dart' as _i341;
import 'package:lume/layers/domain/usecases/save_category_preferences.dart'
    as _i587;
import 'package:lume/layers/domain/usecases/save_pair_progress.dart' as _i718;
import 'package:lume/layers/domain/usecases/sign_in_with_email.dart' as _i566;
import 'package:lume/layers/domain/usecases/sign_out.dart' as _i96;
import 'package:lume/layers/domain/usecases/sign_up_with_email.dart' as _i627;
import 'package:lume/layers/domain/usecases/update_password.dart' as _i326;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appNavigationModule = _$AppNavigationModule();
    final coreAuthModule = _$CoreAuthModule();
    gh.lazySingleton<_i754.AppConfig>(() => _i754.AppConfig.fromEnvironment());
    gh.lazySingletonAsync<_i433.IStorageClient>(
      () => _i433.StorageClient.create(),
    );
    gh.lazySingleton<_i427.IAuthService>(() => _i427.AuthService());
    gh.factory<_i434.IAuthDataSource>(
      () => _i434.AuthDataSource(gh<_i427.IAuthService>()),
    );
    gh.lazySingleton<_i82.IAuthSessionProvider>(
      () => _i82.AuthSessionProvider(gh<_i427.IAuthService>()),
      dispose: (i) => i.dispose(),
    );
    gh.factory<_i451.IAuthRepository>(
      () => _i714.AuthRepository(
        gh<_i434.IAuthDataSource>(),
        gh<_i82.IAuthSessionProvider>(),
        gh<_i754.AppConfig>(),
      ),
    );
    gh.factory<_i627.ISignUpWithEmail>(
      () => _i627.SignUpWithEmail(gh<_i451.IAuthRepository>()),
    );
    gh.lazySingleton<_i617.AppRouter>(
      () => appNavigationModule.appRouter(gh<_i82.IAuthSessionProvider>()),
    );
    gh.lazySingleton<_i325.IAuthTokenProvider>(
      () => coreAuthModule.authTokenProvider(gh<_i82.IAuthSessionProvider>()),
    );
    gh.factory<_i665.IObserveAuthState>(
      () => _i665.ObserveAuthState(gh<_i451.IAuthRepository>()),
    );
    gh.factoryAsync<_i588.IOnboardingRepository>(
      () async =>
          _i842.OnboardingRepository(await getAsync<_i433.IStorageClient>()),
    );
    gh.lazySingleton<_i101.IApiClient>(
      () => _i101.ApiClient.fromInjection(
        gh<_i754.AppConfig>(),
        gh<_i325.IAuthTokenProvider>(),
      ),
    );
    gh.factoryAsync<_i547.IGameDataSource>(
      () async => _i547.GameDataSource(
        gh<_i101.IApiClient>(),
        await getAsync<_i433.IStorageClient>(),
      ),
    );
    gh.factoryAsync<_i131.IGameRepository>(
      () async => _i448.GameRepository(await getAsync<_i547.IGameDataSource>()),
    );
    gh.factory<_i329.IClearPasswordRecovery>(
      () => _i329.ClearPasswordRecovery(gh<_i451.IAuthRepository>()),
    );
    gh.factory<_i341.IRestoreSession>(
      () => _i341.RestoreSession(gh<_i451.IAuthRepository>()),
    );
    gh.factory<_i683.IResendConfirmationEmail>(
      () => _i683.ResendConfirmationEmail(gh<_i451.IAuthRepository>()),
    );
    gh.factoryAsync<_i167.IMarkOnboardingSeen>(
      () async => _i167.MarkOnboardingSeen(
        await getAsync<_i588.IOnboardingRepository>(),
      ),
    );
    gh.factory<_i326.IUpdatePassword>(
      () => _i326.UpdatePassword(gh<_i451.IAuthRepository>()),
    );
    gh.factoryAsync<_i281.IHasSeenOnboarding>(
      () async => _i281.HasSeenOnboarding(
        await getAsync<_i588.IOnboardingRepository>(),
      ),
    );
    gh.factory<_i96.ISignOut>(() => _i96.SignOut(gh<_i451.IAuthRepository>()));
    gh.factory<_i102.IRequestPasswordRecovery>(
      () => _i102.RequestPasswordRecovery(gh<_i451.IAuthRepository>()),
    );
    gh.factory<_i566.ISignInWithEmail>(
      () => _i566.SignInWithEmail(gh<_i451.IAuthRepository>()),
    );
    gh.factoryAsync<_i874.ICategoryPreferenceDataSource>(
      () async => _i874.CategoryPreferenceDataSource(
        gh<_i101.IApiClient>(),
        await getAsync<_i433.IStorageClient>(),
      ),
    );
    gh.factoryAsync<_i527.IProfileDataSource>(
      () async => _i527.ProfileDataSource(
        gh<_i101.IApiClient>(),
        await getAsync<_i433.IStorageClient>(),
      ),
    );
    gh.factoryAsync<_i777.ICategoryPreferenceRepository>(
      () async => _i680.CategoryPreferenceRepository(
        await getAsync<_i874.ICategoryPreferenceDataSource>(),
      ),
    );
    gh.factoryAsync<_i739.ITrailDataSource>(
      () async => _i739.TrailDataSource(
        gh<_i101.IApiClient>(),
        await getAsync<_i433.IStorageClient>(),
      ),
    );
    gh.factoryAsync<_i155.IProfileRepository>(
      () async =>
          _i1072.ProfileRepository(await getAsync<_i527.IProfileDataSource>()),
    );
    gh.factoryAsync<_i97.IGetSubmoduleGames>(
      () async =>
          _i97.GetSubmoduleGames(await getAsync<_i131.IGameRepository>()),
    );
    gh.factoryAsync<_i587.ISaveCategoryPreferences>(
      () async => _i587.SaveCategoryPreferences(
        await getAsync<_i777.ICategoryPreferenceRepository>(),
      ),
    );
    gh.factoryAsync<_i976.IGetCategoriesWithPreferences>(
      () async => _i976.GetCategoriesWithPreferences(
        await getAsync<_i777.ICategoryPreferenceRepository>(),
      ),
    );
    gh.factoryAsync<_i188.IGetProfile>(
      () async => _i188.GetProfile(await getAsync<_i155.IProfileRepository>()),
    );
    gh.factoryAsync<_i314.ITrailRepository>(
      () async =>
          _i406.TrailRepository(await getAsync<_i739.ITrailDataSource>()),
    );
    gh.factoryAsync<_i37.IGetTrailBootstrap>(
      () async =>
          _i37.GetTrailBootstrap(await getAsync<_i314.ITrailRepository>()),
    );
    gh.factoryAsync<_i254.IHasSelectedCategories>(
      () async => _i254.HasSelectedCategories(
        await getAsync<_i976.IGetCategoriesWithPreferences>(),
      ),
    );
    gh.factoryAsync<_i729.IGetGameTrails>(
      () async => _i729.GetGameTrails(await getAsync<_i314.ITrailRepository>()),
    );
    gh.factoryAsync<_i718.ISavePairProgress>(
      () async =>
          _i718.SavePairProgress(await getAsync<_i314.ITrailRepository>()),
    );
    gh.factoryAsync<_i1046.IGetTrailProgress>(
      () async =>
          _i1046.GetTrailProgress(await getAsync<_i314.ITrailRepository>()),
    );
    return this;
  }
}

class _$AppNavigationModule extends _i73.AppNavigationModule {}

class _$CoreAuthModule extends _i633.CoreAuthModule {}
