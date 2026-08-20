import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lume/app/navigation/auth_gate.dart';
import 'package:lume/layers/domain/models/auth/auth_session.dart';
import 'package:lume/layers/domain/usecases/has_seen_onboarding.dart';
import 'package:lume/layers/domain/usecases/has_selected_categories.dart';
import 'package:lume/layers/domain/usecases/restore_session.dart';
import 'package:lume/layers/presentation/screens/splash/splash_event.dart';
import 'package:lume/layers/presentation/screens/splash/splash_state.dart';

@injectable
final class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc(
    this._restoreSession,
    this._hasSeenOnboarding,
    this._hasSelectedCategories,
  ) : super(const SplashLoading()) {
    on<SplashStarted>(_onStarted);
  }

  final IRestoreSession _restoreSession;
  final IHasSeenOnboarding _hasSeenOnboarding;
  final IHasSelectedCategories _hasSelectedCategories;

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

    // Match web login gate: on prefs fetch failure, continue to home.
    var hasSelectedCategories = true;
    final canEnterApp = AuthGate.allowsAuthenticatedRoute(
      hasSession: session != null,
      isEmailConfirmed: session?.user.isEmailConfirmed ?? false,
      isPasswordRecovery: session?.isPasswordRecovery ?? false,
    );
    if (canEnterApp) {
      try {
        hasSelectedCategories = await _hasSelectedCategories(
          forceRefresh: true,
        );
      } on Object {
        hasSelectedCategories = true;
      }
    }

    emit(
      SplashReady(
        AuthGate.splashDestination(
          hasSession: session != null,
          isEmailConfirmed: session?.user.isEmailConfirmed ?? false,
          isPasswordRecovery: session?.isPasswordRecovery ?? false,
          hasSeenOnboarding: seenOnboarding,
          hasSelectedCategories: hasSelectedCategories,
        ),
      ),
    );
  }
}
