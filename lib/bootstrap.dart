import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lume/app/lume_app.dart';
import 'package:lume/app/navigation/app_router.dart';
import 'package:lume/core/config/app_config.dart';
import 'package:lume/core/di/di.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

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

  await configureDependencies();
  final router = getIt<AppRouter>();
  runApp(LumeApp(router: router));
}
