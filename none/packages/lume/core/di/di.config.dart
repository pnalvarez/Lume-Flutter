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
import 'package:lume/layers/presentation/screens/auth/confirm_email/confirm_email_bloc.dart'
    as _i1007;
import 'package:lume/layers/presentation/screens/auth/define_password/define_password_bloc.dart'
    as _i145;
import 'package:lume/layers/presentation/screens/auth/login/login_bloc.dart'
    as _i1057;
import 'package:lume/layers/presentation/screens/auth/recover_password/recover_password_bloc.dart'
    as _i193;
import 'package:lume/layers/presentation/screens/dashboard/dashboard_bloc.dart'
    as _i950;
import 'package:lume/layers/presentation/screens/games/battle_of_curiosities/battle_of_curiosities_bloc.dart'
    as _i200;
import 'package:lume/layers/presentation/screens/games/complete_sentence/complete_sentence_bloc.dart'
    as _i651;
import 'package:lume/layers/presentation/screens/games/connections/connections_bloc.dart'
    as _i817;
import 'package:lume/layers/presentation/screens/games/game_play_factory.dart'
    as _i519;
import 'package:lume/layers/presentation/screens/games/lightning_quiz/lightning_quiz_bloc.dart'
    as _i186;
import 'package:lume/layers/presentation/screens/games/mysterious_word/mysterious_word_bloc.dart'
    as _i43;
import 'package:lume/layers/presentation/screens/games/timeline/timeline_bloc.dart'
    as _i190;
import 'package:lume/layers/presentation/screens/games/true_or_myth/true_or_myth_bloc.dart'
    as _i480;
import 'package:lume/layers/presentation/screens/games/who_am_i/who_am_i_bloc.dart'
    as _i511;
import 'package:lume/layers/presentation/screens/onboarding/onboarding_bloc.dart'
    as _i928;
import 'package:lume/layers/presentation/screens/select_category/select_category_bloc.dart'
    as _i572;
import 'package:lume/layers/presentation/screens/splash/splash_bloc.dart'
    as _i185;
import 'package:lume/layers/presentation/screens/trail/home/home_bloc.dart'
    as _i420;
import 'package:lume/layers/presentation/screens/trail/submodule_session/submodule_session_bloc.dart'
    as _i1058;
import 'package:lume/layers/presentation/screens/trail/trail_detail/trail_detail_bloc.dart'
    as _i348;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appNavigationModule = _$AppNavigationModule();
    final coreAuthModule = _$CoreAuthModule();
    gh.factory<_i200.BattleOfCuriositiesBloc>(
      () => _i200.BattleOfCuriositiesBloc(),
    );
    gh.factory<_i651.CompleteSentenceBloc>(() => _i651.CompleteSentenceBloc());
    gh.factory<_i817.ConnectionsBloc>(() => _i817.ConnectionsBloc());
    gh.factory<_i186.LightningQuizBloc>(() => _i186.LightningQuizBloc());
    gh.factory<_i43.MysteriousWordBloc>(() => _i43.MysteriousWordBloc());
    gh.factory<_i190.TimelineBloc>(() => _i190.TimelineBloc());
    gh.factory<_i480.TrueOrMythBloc>(() => _i480.TrueOrMythBloc());
    gh.factory<_i511.WhoAmIBloc>(() => _i511.WhoAmIBloc());
    gh.lazySingleton<_i754.AppConfig>(() => _i754.AppConfig.fromEnvironment());
    await gh.lazySingletonAsync<_i433.IStorageClient>(
      () => _i433.StorageClient.create(),
      preResolve: true,
    );
    gh.lazySingleton<_i427.IAuthService>(() => _i427.AuthService());
    gh.factory<_i519.IGamePlayFactory>(() => _i519.GamePlayFactory());
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
    gh.factory<_i588.IOnboardingRepository>(
      () => _i842.OnboardingRepository(gh<_i433.IStorageClient>()),
    );
    gh.lazySingleton<_i101.IApiClient>(
      () => _i101.ApiClient.fromInjection(
        gh<_i754.AppConfig>(),
        gh<_i325.IAuthTokenProvider>(),
      ),
    );
    gh.factory<_i547.IGameDataSource>(
      () => _i547.GameDataSource(
        gh<_i101.IApiClient>(),
        gh<_i433.IStorageClient>(),
      ),
    );
    gh.factory<_i131.IGameRepository>(
      () => _i448.GameRepository(gh<_i547.IGameDataSource>()),
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
    gh.factory<_i167.IMarkOnboardingSeen>(
      () => _i167.MarkOnboardingSeen(gh<_i588.IOnboardingRepository>()),
    );
    gh.factory<_i326.IUpdatePassword>(
      () => _i326.UpdatePassword(gh<_i451.IAuthRepository>()),
    );
    gh.factory<_i281.IHasSeenOnboarding>(
      () => _i281.HasSeenOnboarding(gh<_i588.IOnboardingRepository>()),
    );
    gh.factory<_i96.ISignOut>(() => _i96.SignOut(gh<_i451.IAuthRepository>()));
    gh.factory<_i102.IRequestPasswordRecovery>(
      () => _i102.RequestPasswordRecovery(gh<_i451.IAuthRepository>()),
    );
    gh.factory<_i193.RecoverPasswordBloc>(
      () => _i193.RecoverPasswordBloc(gh<_i102.IRequestPasswordRecovery>()),
    );
    gh.factory<_i566.ISignInWithEmail>(
      () => _i566.SignInWithEmail(gh<_i451.IAuthRepository>()),
    );
    gh.factory<_i874.ICategoryPreferenceDataSource>(
      () => _i874.CategoryPreferenceDataSource(
        gh<_i101.IApiClient>(),
        gh<_i433.IStorageClient>(),
      ),
    );
    gh.factory<_i145.DefinePasswordBloc>(
      () => _i145.DefinePasswordBloc(
        gh<_i341.IRestoreSession>(),
        gh<_i326.IUpdatePassword>(),
        gh<_i329.IClearPasswordRecovery>(),
      ),
    );
    gh.factory<_i527.IProfileDataSource>(
      () => _i527.ProfileDataSource(
        gh<_i101.IApiClient>(),
        gh<_i433.IStorageClient>(),
      ),
    );
    gh.factory<_i777.ICategoryPreferenceRepository>(
      () => _i680.CategoryPreferenceRepository(
        gh<_i874.ICategoryPreferenceDataSource>(),
      ),
    );
    gh.factory<_i739.ITrailDataSource>(
      () => _i739.TrailDataSource(
        gh<_i101.IApiClient>(),
        gh<_i433.IStorageClient>(),
      ),
    );
    gh.factory<_i155.IProfileRepository>(
      () => _i1072.ProfileRepository(gh<_i527.IProfileDataSource>()),
    );
    gh.factory<_i950.DashboardBloc>(
      () => _i950.DashboardBloc(gh<_i96.ISignOut>()),
    );
    gh.factory<_i97.IGetSubmoduleGames>(
      () => _i97.GetSubmoduleGames(gh<_i131.IGameRepository>()),
    );
    gh.factory<_i587.ISaveCategoryPreferences>(
      () => _i587.SaveCategoryPreferences(
        gh<_i777.ICategoryPreferenceRepository>(),
      ),
    );
    gh.factory<_i976.IGetCategoriesWithPreferences>(
      () => _i976.GetCategoriesWithPreferences(
        gh<_i777.ICategoryPreferenceRepository>(),
      ),
    );
    gh.factory<_i928.OnboardingBloc>(
      () => _i928.OnboardingBloc(gh<_i167.IMarkOnboardingSeen>()),
    );
    gh.factory<_i188.IGetProfile>(
      () => _i188.GetProfile(gh<_i155.IProfileRepository>()),
    );
    gh.factory<_i314.ITrailRepository>(
      () => _i406.TrailRepository(gh<_i739.ITrailDataSource>()),
    );
    gh.factory<_i37.IGetTrailBootstrap>(
      () => _i37.GetTrailBootstrap(gh<_i314.ITrailRepository>()),
    );
    gh.factory<_i572.SelectCategoryBloc>(
      () => _i572.SelectCategoryBloc(
        gh<_i976.IGetCategoriesWithPreferences>(),
        gh<_i587.ISaveCategoryPreferences>(),
      ),
    );
    gh.factory<_i254.IHasSelectedCategories>(
      () => _i254.HasSelectedCategories(
        gh<_i976.IGetCategoriesWithPreferences>(),
      ),
    );
    gh.factory<_i1007.ConfirmEmailBloc>(
      () => _i1007.ConfirmEmailBloc(
        gh<_i683.IResendConfirmationEmail>(),
        gh<_i665.IObserveAuthState>(),
        gh<_i254.IHasSelectedCategories>(),
      ),
    );
    gh.factory<_i729.IGetGameTrails>(
      () => _i729.GetGameTrails(gh<_i314.ITrailRepository>()),
    );
    gh.factory<_i718.ISavePairProgress>(
      () => _i718.SavePairProgress(gh<_i314.ITrailRepository>()),
    );
    gh.factory<_i1046.IGetTrailProgress>(
      () => _i1046.GetTrailProgress(gh<_i314.ITrailRepository>()),
    );
    gh.factory<_i185.SplashBloc>(
      () => _i185.SplashBloc(
        gh<_i341.IRestoreSession>(),
        gh<_i281.IHasSeenOnboarding>(),
        gh<_i254.IHasSelectedCategories>(),
      ),
    );
    gh.factory<_i348.TrailDetailBloc>(
      () => _i348.TrailDetailBloc(
        gh<_i729.IGetGameTrails>(),
        gh<_i1046.IGetTrailProgress>(),
      ),
    );
    gh.factory<_i1057.LoginBloc>(
      () => _i1057.LoginBloc(
        gh<_i566.ISignInWithEmail>(),
        gh<_i627.ISignUpWithEmail>(),
        gh<_i254.IHasSelectedCategories>(),
      ),
    );
    gh.factory<_i1058.SubmoduleSessionBloc>(
      () => _i1058.SubmoduleSessionBloc(
        gh<_i97.IGetSubmoduleGames>(),
        gh<_i718.ISavePairProgress>(),
      ),
    );
    gh.factory<_i420.HomeBloc>(
      () => _i420.HomeBloc(
        gh<_i729.IGetGameTrails>(),
        gh<_i1046.IGetTrailProgress>(),
        gh<_i188.IGetProfile>(),
      ),
    );
    return this;
  }
}

class _$AppNavigationModule extends _i73.AppNavigationModule {}

class _$CoreAuthModule extends _i633.CoreAuthModule {}
