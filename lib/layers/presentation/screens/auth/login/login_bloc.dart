import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lume/common/strings/auth_strings.dart';
import 'package:lume/core/analytics/analytics.dart';
import 'package:lume/core/errors/auth_failure.dart';
import 'package:lume/layers/domain/usecases/has_completed_personal_info.dart';
import 'package:lume/layers/domain/usecases/has_selected_categories.dart';
import 'package:lume/layers/domain/usecases/sign_in_with_email.dart';
import 'package:lume/layers/domain/usecases/sign_up_with_email.dart';
import 'package:lume/layers/presentation/screens/auth/login/login_event.dart';
import 'package:lume/layers/presentation/screens/auth/login/login_state.dart';
import 'package:lume/layers/presentation/shared/auth_messages.dart';

@injectable
final class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(
    this._signInWithEmail,
    this._signUpWithEmail,
    this._hasCompletedPersonalInfo,
    this._hasSelectedCategories,
    this._analytics,
  ) : super(const LoginState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginModeToggled>(_onModeToggled);
    on<LoginSubmitted>(_onSubmitted);
    on<LoginForgotPasswordPressed>(_onForgotPassword);
    on<LoginWhatIsLumePressed>(_onWhatIsLume);
    on<LoginNavigationHandled>(_onNavigationHandled);
  }

  final ISignInWithEmail _signInWithEmail;
  final ISignUpWithEmail _signUpWithEmail;
  final IHasCompletedPersonalInfo _hasCompletedPersonalInfo;
  final IHasSelectedCategories _hasSelectedCategories;
  final IAnalytics _analytics;

  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(email: event.email, clearError: true));
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(password: event.password, clearError: true));
  }

  void _onModeToggled(LoginModeToggled event, Emitter<LoginState> emit) {
    emit(
      state.copyWith(
        mode: state.mode == LoginMode.login
            ? LoginMode.signup
            : LoginMode.login,
        clearError: true,
      ),
    );
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (!state.canSubmit) return;
    final mode = state.mode.name;
    await _analytics.logEvent(
      AnalyticsEvents.loginSubmitted,
      parameters: {AnalyticsParams.mode: mode},
    );
    emit(
      state.copyWith(isSubmitting: true, clearError: true, clearNotice: true),
    );
    try {
      if (state.mode == LoginMode.signup) {
        final result = await _signUpWithEmail(
          email: state.email.trim(),
          password: state.password,
        );
        if (result.needsEmailConfirmation) {
          await _analytics.logEvent(
            AnalyticsEvents.loginSucceeded,
            parameters: {
              AnalyticsParams.mode: mode,
              AnalyticsParams.destination: LoginDestination.confirmEmail.name,
            },
          );
          emit(
            state.copyWith(
              isSubmitting: false,
              destination: LoginDestination.confirmEmail,
            ),
          );
          return;
        }
        final userId = result.session?.user.id;
        if (userId != null) {
          await _analytics.setUserId(userId);
        }
        await _analytics.logEvent(
          AnalyticsEvents.loginSucceeded,
          parameters: {
            AnalyticsParams.mode: mode,
            AnalyticsParams.destination: LoginDestination.personalInfo.name,
          },
        );
        emit(
          state.copyWith(
            isSubmitting: false,
            destination: LoginDestination.personalInfo,
          ),
        );
        return;
      }

      final session = await _signInWithEmail(
        email: state.email.trim(),
        password: state.password,
      );
      await _analytics.setUserId(session.user.id);
      final destination = await _destinationAfterSignIn();
      await _analytics.logEvent(
        AnalyticsEvents.loginSucceeded,
        parameters: {
          AnalyticsParams.mode: mode,
          AnalyticsParams.destination: destination.name,
        },
      );
      emit(state.copyWith(isSubmitting: false, destination: destination));
    } on AuthEmailNotConfirmedFailure {
      await _analytics.logEvent(
        AnalyticsEvents.loginFailed,
        parameters: {
          AnalyticsParams.mode: mode,
          AnalyticsParams.errorCode: 'email_not_confirmed',
        },
      );
      emit(
        state.copyWith(
          isSubmitting: false,
          notice: loginEmailNotConfirmedNotice,
          destination: LoginDestination.confirmEmail,
        ),
      );
    } on Object catch (error) {
      await _analytics.logEvent(
        AnalyticsEvents.loginFailed,
        parameters: {
          AnalyticsParams.mode: mode,
          AnalyticsParams.errorCode: _errorCode(error),
        },
      );
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: authFailureMessage(error),
        ),
      );
    }
  }

  /// Personal info → categories → home. Prefs/profile check failures go home.
  Future<LoginDestination> _destinationAfterSignIn() async {
    try {
      final hasPersonalInfo = await _hasCompletedPersonalInfo(
        forceRefresh: true,
      );
      if (!hasPersonalInfo) {
        return LoginDestination.personalInfo;
      }
    } on Object {
      return LoginDestination.home;
    }

    try {
      final hasSelected = await _hasSelectedCategories(forceRefresh: true);
      return hasSelected
          ? LoginDestination.home
          : LoginDestination.selectCategory;
    } on Object {
      return LoginDestination.home;
    }
  }

  void _onForgotPassword(
    LoginForgotPasswordPressed event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(destination: LoginDestination.recoverPassword));
  }

  void _onWhatIsLume(LoginWhatIsLumePressed event, Emitter<LoginState> emit) {
    emit(state.copyWith(destination: LoginDestination.onboarding));
  }

  void _onNavigationHandled(
    LoginNavigationHandled event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(clearDestination: true, clearNotice: true));
  }

  static String _errorCode(Object error) {
    if (error is AuthOperationFailure) return error.operation;
    return error.runtimeType.toString();
  }
}
