import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/core/analytics/analytics.dart';
import 'package:lume/core/errors/auth_failure.dart';
import 'package:lume/layers/domain/models/auth/auth_session.dart';
import 'package:lume/layers/domain/models/auth/auth_sign_up_result.dart';
import 'package:lume/layers/domain/models/auth/auth_user.dart';
import 'package:lume/layers/domain/usecases/has_completed_personal_info.dart';
import 'package:lume/layers/domain/usecases/has_selected_categories.dart';
import 'package:lume/layers/domain/usecases/sign_in_with_email.dart';
import 'package:lume/layers/domain/usecases/sign_up_with_email.dart';
import 'package:lume/layers/presentation/screens/auth/login/login_bloc.dart';
import 'package:lume/layers/presentation/screens/auth/login/login_event.dart';
import 'package:lume/layers/presentation/screens/auth/login/login_state.dart';
import '../../helpers/fake_analytics.dart';

class _SignIn implements ISignInWithEmail {
  Object? error;
  var calls = 0;

  @override
  Future<AuthSession> call({
    required String email,
    required String password,
  }) async {
    calls += 1;
    if (error != null) throw error!;
    return const AuthSession(
      user: AuthUser(id: '1', email: 'a@b.c', isEmailConfirmed: true),
      isPasswordRecovery: false,
    );
  }
}

class _SignUp implements ISignUpWithEmail {
  AuthSignUpResult result = const AuthSignUpResult(
    email: 'a@b.c',
    needsEmailConfirmation: true,
  );

  @override
  Future<AuthSignUpResult> call({
    required String email,
    required String password,
  }) async => result;
}

class _HasPersonalInfo implements IHasCompletedPersonalInfo {
  _HasPersonalInfo(this.value, {this.error});

  final bool value;
  final Object? error;

  @override
  Future<bool> call({bool forceRefresh = false}) async {
    if (error != null) throw error!;
    return value;
  }
}

class _HasSelected implements IHasSelectedCategories {
  _HasSelected(this.value, {this.error});

  final bool value;
  final Object? error;

  @override
  Future<bool> call({bool forceRefresh = false}) async {
    if (error != null) throw error!;
    return value;
  }
}

LoginBloc _bloc(
  _SignIn signIn,
  _SignUp signUp, {
  IHasCompletedPersonalInfo? hasPersonalInfo,
  IHasSelectedCategories? hasSelected,
  FakeAnalytics? analytics,
}) {
  return LoginBloc(
    signIn,
    signUp,
    hasPersonalInfo ?? _HasPersonalInfo(true),
    hasSelected ?? _HasSelected(true),
    analytics ?? FakeAnalytics(),
  );
}

void main() {
  blocTest<LoginBloc, LoginState>(
    'successful sign-in with personal info and categories goes home',
    build: () => _bloc(_SignIn(), _SignUp()),
    act: (bloc) {
      bloc
        ..add(const LoginEmailChanged('a@b.c'))
        ..add(const LoginPasswordChanged('secret1'))
        ..add(const LoginSubmitted());
    },
    skip: 2,
    expect: () => [
      isA<LoginState>().having((s) => s.isSubmitting, 'submitting', true),
      isA<LoginState>().having(
        (s) => s.destination,
        'destination',
        LoginDestination.home,
      ),
    ],
  );

  blocTest<LoginBloc, LoginState>(
    'successful sign-in without personal info goes to personal info',
    build: () => _bloc(
      _SignIn(),
      _SignUp(),
      hasPersonalInfo: _HasPersonalInfo(false),
      hasSelected: _HasSelected(false),
    ),
    act: (bloc) {
      bloc
        ..add(const LoginEmailChanged('a@b.c'))
        ..add(const LoginPasswordChanged('secret1'))
        ..add(const LoginSubmitted());
    },
    skip: 2,
    expect: () => [
      isA<LoginState>().having((s) => s.isSubmitting, 'submitting', true),
      isA<LoginState>().having(
        (s) => s.destination,
        'destination',
        LoginDestination.personalInfo,
      ),
    ],
  );

  blocTest<LoginBloc, LoginState>(
    'successful sign-in without categories goes to select category',
    build: () => _bloc(
      _SignIn(),
      _SignUp(),
      hasPersonalInfo: _HasPersonalInfo(true),
      hasSelected: _HasSelected(false),
    ),
    act: (bloc) {
      bloc
        ..add(const LoginEmailChanged('a@b.c'))
        ..add(const LoginPasswordChanged('secret1'))
        ..add(const LoginSubmitted());
    },
    skip: 2,
    expect: () => [
      isA<LoginState>().having((s) => s.isSubmitting, 'submitting', true),
      isA<LoginState>().having(
        (s) => s.destination,
        'destination',
        LoginDestination.selectCategory,
      ),
    ],
  );

  blocTest<LoginBloc, LoginState>(
    'unconfirmed sign-in goes to confirm email',
    build: () => _bloc(
      _SignIn()..error = const AuthEmailNotConfirmedFailure(email: 'a@b.c'),
      _SignUp(),
    ),
    act: (bloc) {
      bloc
        ..add(const LoginEmailChanged('a@b.c'))
        ..add(const LoginPasswordChanged('secret1'))
        ..add(const LoginSubmitted());
    },
    skip: 2,
    expect: () => [
      isA<LoginState>().having((s) => s.isSubmitting, 'submitting', true),
      isA<LoginState>().having(
        (s) => s.destination,
        'destination',
        LoginDestination.confirmEmail,
      ),
    ],
  );

  blocTest<LoginBloc, LoginState>(
    'sign-up that needs confirmation goes to confirm email',
    build: () => _bloc(_SignIn(), _SignUp()),
    act: (bloc) {
      bloc
        ..add(const LoginModeToggled())
        ..add(const LoginEmailChanged('a@b.c'))
        ..add(const LoginPasswordChanged('secret1'))
        ..add(const LoginSubmitted());
    },
    skip: 3,
    expect: () => [
      isA<LoginState>().having((s) => s.isSubmitting, 'submitting', true),
      isA<LoginState>().having(
        (s) => s.destination,
        'destination',
        LoginDestination.confirmEmail,
      ),
    ],
  );

  blocTest<LoginBloc, LoginState>(
    'confirmed sign-up goes to personal info',
    build: () => _bloc(
      _SignIn(),
      _SignUp()
        ..result = const AuthSignUpResult(
          email: 'a@b.c',
          needsEmailConfirmation: false,
          session: AuthSession(
            user: AuthUser(id: 'u-2', email: 'a@b.c', isEmailConfirmed: true),
            isPasswordRecovery: false,
          ),
        ),
    ),
    act: (bloc) {
      bloc
        ..add(const LoginModeToggled())
        ..add(const LoginEmailChanged('a@b.c'))
        ..add(const LoginPasswordChanged('secret1'))
        ..add(const LoginSubmitted());
    },
    skip: 3,
    expect: () => [
      isA<LoginState>().having((s) => s.isSubmitting, 'submitting', true),
      isA<LoginState>().having(
        (s) => s.destination,
        'destination',
        LoginDestination.personalInfo,
      ),
    ],
  );

  test('sign-in logs submitted/succeeded and sets user id', () async {
    final analytics = FakeAnalytics();
    final bloc = _bloc(_SignIn(), _SignUp(), analytics: analytics);
    bloc
      ..add(const LoginEmailChanged('a@b.c'))
      ..add(const LoginPasswordChanged('secret1'))
      ..add(const LoginSubmitted());
    await bloc.stream.firstWhere((s) => s.destination == LoginDestination.home);
    expect(analytics.hasEvent(AnalyticsEvents.loginSubmitted), isTrue);
    expect(analytics.hasEvent(AnalyticsEvents.loginSucceeded), isTrue);
    expect(analytics.parametersFor(AnalyticsEvents.loginSucceeded), {
      AnalyticsParams.mode: 'login',
      AnalyticsParams.destination: 'home',
    });
    expect(analytics.userIds, ['1']);
    await bloc.close();
  });

  test('failed sign-in logs login_failed with error_code', () async {
    final analytics = FakeAnalytics();
    final bloc = _bloc(
      _SignIn()..error = const AuthOperationFailure(operation: 'sign_in'),
      _SignUp(),
      analytics: analytics,
    );
    bloc
      ..add(const LoginEmailChanged('a@b.c'))
      ..add(const LoginPasswordChanged('secret1'))
      ..add(const LoginSubmitted());
    await bloc.stream.firstWhere((s) => s.errorMessage != null);
    expect(analytics.hasEvent(AnalyticsEvents.loginFailed), isTrue);
    expect(
      analytics.parametersFor(
        AnalyticsEvents.loginFailed,
      )?[AnalyticsParams.errorCode],
      'sign_in',
    );
    await bloc.close();
  });
}
