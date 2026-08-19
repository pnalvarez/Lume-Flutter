/// Cold-start destinations after session restore. Recovery is handled by
/// [RecoveryGuard] after this decision.
enum SplashDestination { onboarding, login, home }

/// Pure routing decisions for [AuthGuard] and [RecoveryGuard].
abstract final class AuthGate {
  /// Authenticated product routes require a confirmed session and no recovery.
  static bool allowsAuthenticatedRoute({
    required bool hasSession,
    required bool isEmailConfirmed,
    required bool isPasswordRecovery,
  }) {
    return hasSession && isEmailConfirmed && !isPasswordRecovery;
  }

  /// Recovery session must finish on define-password before any other route.
  static bool mustForcePasswordRecovery({
    required bool isPasswordRecovery,
    required bool isDefinePasswordRoute,
  }) {
    return isPasswordRecovery && !isDefinePasswordRoute;
  }

  /// Mirrors web `RootRedirect`: confirmed sessions go home; everyone else
  /// lands on onboarding or login.
  static SplashDestination splashDestination({
    required bool hasSession,
    required bool isEmailConfirmed,
    required bool isPasswordRecovery,
    required bool hasSeenOnboarding,
  }) {
    if (allowsAuthenticatedRoute(
      hasSession: hasSession,
      isEmailConfirmed: isEmailConfirmed,
      isPasswordRecovery: isPasswordRecovery,
    )) {
      return SplashDestination.home;
    }
    return hasSeenOnboarding
        ? SplashDestination.login
        : SplashDestination.onboarding;
  }
}
