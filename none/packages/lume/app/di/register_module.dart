import 'package:injectable/injectable.dart';
import 'package:lume/app/navigation/app_router.dart';
import 'package:lume/app/navigation/auth_guard.dart';
import 'package:lume/app/navigation/recovery_guard.dart';
import 'package:lume/core/auth/auth_session_provider.dart';

@module
abstract class AppNavigationModule {
  @lazySingleton
  AppRouter appRouter(IAuthSessionProvider session) {
    return AppRouter(
      authGuard: AuthGuard(session),
      recoveryGuard: RecoveryGuard(session),
    );
  }
}
