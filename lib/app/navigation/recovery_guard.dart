import 'package:auto_route/auto_route.dart';
import 'package:lume/app/navigation/auth_gate.dart';
import 'package:lume/app/navigation/app_router.gr.dart';
import 'package:lume/core/auth/auth_session_provider.dart';

/// Keeps a password-recovery session on [DefinePasswordRoute].
///
/// Same rationale as [AuthGuard]: do not use [NavigationResolver.redirectUntil]
/// when the target screen never completes the pending resolver.
class RecoveryGuard extends AutoRouteGuard {
  RecoveryGuard(this._session);

  final IAuthSessionProvider _session;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final forceRecovery = AuthGate.mustForcePasswordRecovery(
      isPasswordRecovery: _session.isPasswordRecovery,
      isDefinePasswordRoute: resolver.routeName == DefinePasswordRoute.name,
    );
    if (forceRecovery) {
      resolver.next(false);
      if (router.current.name != DefinePasswordRoute.name) {
        router.replaceAll([const DefinePasswordRoute()]);
      }
      return;
    }
    resolver.next();
  }
}
