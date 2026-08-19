import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lume/app/navigation/auth_gate.dart';
import 'package:lume/layers/domain/models/auth/auth_session.dart';
import 'package:lume/layers/domain/usecases/has_seen_onboarding.dart';
import 'package:lume/layers/domain/usecases/restore_session.dart';
import 'package:lume/layers/presentation/screens/splash/splash_event.dart';
import 'package:lume/layers/presentation/screens/splash/splash_state.dart';

final class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc({
    required IRestoreSession restoreSession,
    required IHasSeenOnboarding hasSeenOnboarding,
  })  : _restoreSession = restoreSession,
        _hasSeenOnboarding = hasSeenOnboarding,
        super(const SplashLoading()) {
    on<SplashStarted>(_onStarted);
  }

  final IRestoreSession _restoreSession;
  final IHasSeenOnboarding _hasSeenOnboarding;

  Future<void> _onStarted(
    SplashStarted event,
    Emitter<SplashState> emit,
  ) async {
    AuthSession? session;
    try {
      session = await _restoreSession();
    } on Object {
      session = null;
    }

    var seenOnboarding = false;
    try {
      seenOnboarding = await _hasSeenOnboarding();
    } on Object {
      seenOnboarding = false;
    }

    emit(
      SplashReady(
        AuthGate.splashDestination(
          hasSession: session != null,
          isEmailConfirmed: session?.user.isEmailConfirmed ?? false,
          isPasswordRecovery: session?.isPasswordRecovery ?? false,
          hasSeenOnboarding: seenOnboarding,
        ),
      ),
    );
  }
}
