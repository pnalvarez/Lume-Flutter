/// Cold-start destinations after session restore. Recovery is handled by
/// [RecoveryGuard] after this decision.
enum SplashDestination { onboarding, login, home, personalInfo, selectCategory }

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

  /// Confirmed sessions: personal info → category prefs → home.
  static SplashDestination splashDestination({
    required bool hasSession,
    required bool isEmailConfirmed,
    required bool isPasswordRecovery,
    required bool hasSeenOnboarding,
    required bool hasCompletedPersonalInfo,
    required bool hasSelectedCategories,
  }) {
    if (allowsAuthenticatedRoute(
      hasSession: hasSession,
      isEmailConfirmed: isEmailConfirmed,
      isPasswordRecovery: isPasswordRecovery,
    )) {
      if (!hasCompletedPersonalInfo) {
        return SplashDestination.personalInfo;
      }
      return hasSelectedCategories
          ? SplashDestination.home
          : SplashDestination.selectCategory;
    }
    return hasSeenOnboarding
        ? SplashDestination.login
        : SplashDestination.onboarding;
  }
}
