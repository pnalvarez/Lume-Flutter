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
    test('sends a confirmed session with categories home', () {
      expect(
        AuthGate.splashDestination(
          hasSession: true,
          isEmailConfirmed: true,
          isPasswordRecovery: false,
          hasSeenOnboarding: false,
          hasSelectedCategories: true,
        ),
        SplashDestination.home,
      );
    });

    test('sends a confirmed session without categories to select category', () {
      expect(
        AuthGate.splashDestination(
          hasSession: true,
          isEmailConfirmed: true,
          isPasswordRecovery: false,
          hasSeenOnboarding: true,
          hasSelectedCategories: false,
        ),
        SplashDestination.selectCategory,
      );
    });

    test('sends everyone else to onboarding or login', () {
      expect(
        AuthGate.splashDestination(
          hasSession: false,
          isEmailConfirmed: false,
          isPasswordRecovery: false,
          hasSeenOnboarding: false,
          hasSelectedCategories: false,
        ),
        SplashDestination.onboarding,
      );
      expect(
        AuthGate.splashDestination(
          hasSession: false,
          isEmailConfirmed: false,
          isPasswordRecovery: false,
          hasSeenOnboarding: true,
          hasSelectedCategories: false,
        ),
        SplashDestination.login,
      );
      expect(
        AuthGate.splashDestination(
          hasSession: true,
          isEmailConfirmed: false,
          isPasswordRecovery: false,
          hasSeenOnboarding: true,
          hasSelectedCategories: false,
        ),
        SplashDestination.login,
      );
    });
  });
}
