import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lume/common/strings/auth_strings.dart';
import 'package:lume/core/errors/auth_failure.dart';
import 'package:lume/layers/domain/usecases/sign_in_with_email.dart';
import 'package:lume/layers/domain/usecases/sign_up_with_email.dart';
import 'package:lume/layers/presentation/screens/auth/login/login_event.dart';
import 'package:lume/layers/presentation/screens/auth/login/login_state.dart';
import 'package:lume/layers/presentation/shared/auth_messages.dart';

final class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required ISignInWithEmail signInWithEmail,
    required ISignUpWithEmail signUpWithEmail,
  }) : _signInWithEmail = signInWithEmail,
       _signUpWithEmail = signUpWithEmail,
       super(const LoginState()) {
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
          emit(
            state.copyWith(
              isSubmitting: false,
              destination: LoginDestination.confirmEmail,
            ),
          );
          return;
        }
        emit(
          state.copyWith(
            isSubmitting: false,
            destination: LoginDestination.home,
          ),
        );
        return;
      }

      await _signInWithEmail(
        email: state.email.trim(),
        password: state.password,
      );
      emit(
        state.copyWith(isSubmitting: false, destination: LoginDestination.home),
      );
    } on AuthEmailNotConfirmedFailure {
      emit(
        state.copyWith(
          isSubmitting: false,
          notice: loginEmailNotConfirmedNotice,
          destination: LoginDestination.confirmEmail,
        ),
      );
    } on Object catch (error) {
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: authFailureMessage(error),
        ),
      );
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
}
