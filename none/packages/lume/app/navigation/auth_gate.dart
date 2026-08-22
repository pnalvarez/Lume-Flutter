/// Cold-start destinations after session restore. Recovery is handled by
/// [RecoveryGuard] after this decision.
enum SplashDestination { onboarding, login, home, selectCategory }

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

  /// Mirrors web: confirmed sessions without category prefs go to select
  /// category; with prefs go home; everyone else onboarding or login.
  static SplashDestination splashDestination({
    required bool hasSession,
    required bool isEmailConfirmed,
    required bool isPasswordRecovery,
    required bool hasSeenOnboarding,
    required bool hasSelectedCategories,
  }) {
    if (allowsAuthenticatedRoute(
      hasSession: hasSession,
      isEmailConfirmed: isEmailConfirmed,
      isPasswordRecovery: isPasswordRecovery,
    )) {
      return hasSelectedCategories
          ? SplashDestination.home
          : SplashDestination.selectCategory;
    }
    return hasSeenOnboarding
        ? SplashDestination.login
        : SplashDestination.onboarding;
  }
}
