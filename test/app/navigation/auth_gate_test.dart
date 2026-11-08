import 'package:flutter_test/flutter_test.dart';
import 'package:lume/app/navigation/auth_gate.dart';

void main() {
  group('AuthGate.allowsAuthenticatedRoute', () {
    test('allows a confirmed session without recovery', () {
      expect(
        AuthGate.allowsAuthenticatedRoute(
          hasSession: true,
          isEmailConfirmed: true,
          isPasswordRecovery: false,
        ),
        isTrue,
      );
    });

    test('rejects missing session, unconfirmed email, or recovery', () {
      expect(
        AuthGate.allowsAuthenticatedRoute(
          hasSession: false,
          isEmailConfirmed: true,
          isPasswordRecovery: false,
        ),
        isFalse,
      );
      expect(
        AuthGate.allowsAuthenticatedRoute(
          hasSession: true,
          isEmailConfirmed: false,
          isPasswordRecovery: false,
        ),
        isFalse,
      );
      expect(
        AuthGate.allowsAuthenticatedRoute(
          hasSession: true,
          isEmailConfirmed: true,
          isPasswordRecovery: true,
        ),
        isFalse,
      );
    });
  });

  group('AuthGate.mustForcePasswordRecovery', () {
    test('forces recovery on every route except define-password', () {
      expect(
        AuthGate.mustForcePasswordRecovery(
          isPasswordRecovery: true,
          isDefinePasswordRoute: false,
        ),
        isTrue,
      );
      expect(
        AuthGate.mustForcePasswordRecovery(
          isPasswordRecovery: true,
          isDefinePasswordRoute: true,
        ),
        isFalse,
      );
      expect(
        AuthGate.mustForcePasswordRecovery(
          isPasswordRecovery: false,
          isDefinePasswordRoute: false,
        ),
        isFalse,
      );
    });
  });

  group('AuthGate.splashDestination', () {
    test('sends a confirmed session with personal info home', () {
      expect(
        AuthGate.splashDestination(
          hasSession: true,
          isEmailConfirmed: true,
          isPasswordRecovery: false,
          hasSeenOnboarding: false,
          hasCompletedPersonalInfo: true,
        ),
        SplashDestination.home,
      );
    });

    test('sends a confirmed session without personal info first', () {
      expect(
        AuthGate.splashDestination(
          hasSession: true,
          isEmailConfirmed: true,
          isPasswordRecovery: false,
          hasSeenOnboarding: true,
          hasCompletedPersonalInfo: false,
        ),
        SplashDestination.personalInfo,
      );
    });

    test('History-only: confirmed users with personal info go home with no '
        'category/preferences gate', () {
      // AuthGate has no preference/category inputs — routing is personal-info
      // then home only (see SplashDestination values below).
      expect(
        AuthGate.splashDestination(
          hasSession: true,
          isEmailConfirmed: true,
          isPasswordRecovery: false,
          hasSeenOnboarding: true,
          hasCompletedPersonalInfo: true,
        ),
        SplashDestination.home,
      );
      expect(SplashDestination.values, [
        SplashDestination.onboarding,
        SplashDestination.login,
        SplashDestination.home,
        SplashDestination.personalInfo,
      ]);
    });

    test('new users without personal info go Personal Info before Home', () {
      expect(
        AuthGate.splashDestination(
          hasSession: true,
          isEmailConfirmed: true,
          isPasswordRecovery: false,
          hasSeenOnboarding: true,
          hasCompletedPersonalInfo: false,
        ),
        SplashDestination.personalInfo,
      );
    });

    test('sends everyone else to onboarding or login', () {
      expect(
        AuthGate.splashDestination(
          hasSession: false,
          isEmailConfirmed: false,
          isPasswordRecovery: false,
          hasSeenOnboarding: false,
          hasCompletedPersonalInfo: false,
        ),
        SplashDestination.onboarding,
      );
      expect(
        AuthGate.splashDestination(
          hasSession: false,
          isEmailConfirmed: false,
          isPasswordRecovery: false,
          hasSeenOnboarding: true,
          hasCompletedPersonalInfo: false,
        ),
        SplashDestination.login,
      );
      expect(
        AuthGate.splashDestination(
          hasSession: true,
          isEmailConfirmed: false,
          isPasswordRecovery: false,
          hasSeenOnboarding: true,
          hasCompletedPersonalInfo: false,
        ),
        SplashDestination.login,
      );
    });
  });
}
