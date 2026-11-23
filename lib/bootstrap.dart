import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lume/app/lume_app.dart';
import 'package:lume/app/navigation/app_router.dart';
import 'package:lume/app/navigation/app_router.gr.dart';
import 'package:lume/app/push_coordinator.dart';
import 'package:lume/core/config/app_config.dart';
import 'package:lume/core/auth/auth_session_provider.dart';
import 'package:lume/core/di/di.dart';
import 'package:lume/core/observability/crash_reporting.dart';
import 'package:lume/core/analytics/analytics.dart';
import 'package:lume/core/remote_config/remote_config.dart';
import 'package:lume/layers/domain/usecases/register_push_device.dart';
import 'package:lume/layers/domain/usecases/request_push_permission.dart';
import 'package:lume/layers/domain/usecases/watch_achievement_unlocks.dart';
import 'package:lume/layers/domain/usecases/watch_level_up_events.dart';
import 'package:lume/layers/domain/usecases/watch_push_notification_taps.dart';
import 'package:lume/layers/domain/usecases/watch_push_token_refresh.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> bootstrap() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await CrashReporting.install();
    await AnalyticsService.install();

    final config = AppConfig.fromEnvironment();
    await Supabase.initialize(
      url: config.supabaseUrl,
      publishableKey: config.supabaseAnonKey,
      debug: kDebugMode,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
        detectSessionInUri: true,
      ),
    );

    await RemoteConfigService.install(
      accountId: Supabase.instance.client.auth.currentUser?.id,
    );

    await configureDependencies();
    final router = getIt<AppRouter>();
    final authSession = getIt<IAuthSessionProvider>();
    await RemoteConfigService.bindAccountId(
      sessionChanges: authSession.changes,
      accountId: () => authSession.userId,
    );
    await RemoteConfigService.syncAccountId(authSession.userId);
    runApp(
      LumeApp(
        router: router,
        levelUpEvents: getIt<IWatchLevelUpEvents>()(),
        achievementUnlockEvents: getIt<IWatchAchievementUnlocks>()(),
        authSessionChanges: authSession.changes,
        authUserId: () => authSession.userId,
        analytics: AnalyticsService.client,
      ),
    );
    PushCoordinator(
      registerPushDevice: getIt<IRegisterPushDevice>(),
      requestPushPermission: getIt<IRequestPushPermission>(),
      watchTokenRefresh: getIt<IWatchPushTokenRefresh>(),
      watchNotificationTaps: getIt<IWatchPushNotificationTaps>(),
      authSessionChanges: authSession.changes,
      hasSession: () => authSession.hasSession,
      onOpenHome: () =>
          router.navigate(const DashboardRoute(children: [HomeRoute()])),
      // Temporary QA switch until the permission dialog ships in #241.
      promptForPermission: const bool.fromEnvironment('PUSH_PROMPT_ON_LOGIN'),
    ).start();
  }, CrashReporting.onZoneError);
}
