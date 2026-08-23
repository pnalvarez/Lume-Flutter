import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/core/errors/auth_failure.dart';
import 'package:lume/layers/domain/models/auth/auth_session.dart';
import 'package:lume/layers/domain/models/auth/auth_sign_up_result.dart';
import 'package:lume/layers/domain/models/auth/auth_user.dart';
import 'package:lume/layers/domain/usecases/has_selected_categories.dart';
import 'package:lume/layers/domain/usecases/sign_in_with_email.dart';
import 'package:lume/layers/domain/usecases/sign_up_with_email.dart';
import 'package:lume/layers/presentation/screens/auth/login/login_bloc.dart';
import 'package:lume/layers/presentation/screens/auth/login/login_event.dart';
import 'package:lume/layers/presentation/screens/auth/login/login_state.dart';

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

class _HasSelected implements IHasSelectedCategories {
  _HasSelected(this.value) : error = null;

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
  IHasSelectedCategories? hasSelected,
}) {
  return LoginBloc(
    signIn,
    signUp,
    hasSelected ?? _HasSelected(true),
  );
}

void main() {
  blocTest<LoginBloc, LoginState>(
    'successful sign-in with categories goes home',
    build: () => _bloc(_SignIn(), _SignUp(), hasSelected: _HasSelected(true)),
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
    'successful sign-in without categories goes to select category',
    build: () => _bloc(_SignIn(), _SignUp(), hasSelected: _HasSelected(false)),
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
    'confirmed sign-up goes to select category',
    build: () => _bloc(
      _SignIn(),
      _SignUp()
        ..result = const AuthSignUpResult(
          email: 'a@b.c',
          needsEmailConfirmation: false,
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
        LoginDestination.selectCategory,
      ),
    ],
  );
}
