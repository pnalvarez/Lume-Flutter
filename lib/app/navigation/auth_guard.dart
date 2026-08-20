import 'package:auto_route/auto_route.dart';
import 'package:lume/app/navigation/auth_gate.dart';
import 'package:lume/app/navigation/app_router.gr.dart';
import 'package:lume/core/auth/auth_session_provider.dart';

/// Requires a valid, email-confirmed session.
///
/// Uses [resolver.next] + [StackRouter.replaceAll] instead of
/// [NavigationResolver.redirectUntil]. Login navigates with `replace` /
/// `replaceAll` to its own destination and never resumes a pending resolver,
/// so `redirectUntil` would leave the stack stuck on a Login overlay forever.
class AuthGuard extends AutoRouteGuard {
  AuthGuard(this._session);

  final IAuthSessionProvider _session;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final allowed = AuthGate.allowsAuthenticatedRoute(
      hasSession: _session.hasSession,
      isEmailConfirmed: _session.isEmailConfirmed,
      isPasswordRecovery: _session.isPasswordRecovery,
    );
    if (allowed) {
      resolver.next();
      return;
    }

    resolver.next(false);
    if (_session.isPasswordRecovery) {
      if (router.current.name != DefinePasswordRoute.name) {
        router.replaceAll([const DefinePasswordRoute()]);
      }
      return;
    }
    if (router.current.name != LoginRoute.name) {
      router.replaceAll([const LoginRoute()]);
    }
  }
}
