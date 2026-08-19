import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/app/navigation/auth_gate.dart';
import 'package:lume/layers/domain/models/auth/auth_session.dart';
import 'package:lume/layers/domain/models/auth/auth_user.dart';
import 'package:lume/layers/domain/usecases/has_seen_onboarding.dart';
import 'package:lume/layers/domain/usecases/restore_session.dart';
import 'package:lume/layers/presentation/screens/splash/splash_bloc.dart';
import 'package:lume/layers/presentation/screens/splash/splash_event.dart';
import 'package:lume/layers/presentation/screens/splash/splash_state.dart';

class _Restore implements IRestoreSession {
  _Restore(this.session);

  final AuthSession? session;

  @override
  Future<AuthSession?> call() async => session;
}

class _HasSeen implements IHasSeenOnboarding {
  _HasSeen(this.value);

  final bool value;

  @override
  Future<bool> call() async => value;
}

AuthSession _confirmedSession() {
  return const AuthSession(
    user: AuthUser(
      id: 'user-1',
      email: 'a@b.c',
      isEmailConfirmed: true,
    ),
    isPasswordRecovery: false,
  );
}

void main() {
  blocTest<SplashBloc, SplashState>(
    'goes to onboarding when there is no session and onboarding is unseen',
    build: () => SplashBloc(
      restoreSession: _Restore(null),
      hasSeenOnboarding: _HasSeen(false),
    ),
    act: (bloc) => bloc.add(const SplashStarted()),
    expect: () => [const SplashReady(SplashDestination.onboarding)],
  );

  blocTest<SplashBloc, SplashState>(
    'goes to login when onboarding was already seen',
    build: () => SplashBloc(
      restoreSession: _Restore(null),
      hasSeenOnboarding: _HasSeen(true),
    ),
    act: (bloc) => bloc.add(const SplashStarted()),
    expect: () => [const SplashReady(SplashDestination.login)],
  );

  blocTest<SplashBloc, SplashState>(
    'goes home when the restored session is confirmed',
    build: () => SplashBloc(
      restoreSession: _Restore(_confirmedSession()),
      hasSeenOnboarding: _HasSeen(true),
    ),
    act: (bloc) => bloc.add(const SplashStarted()),
    expect: () => [const SplashReady(SplashDestination.home)],
  );
}
