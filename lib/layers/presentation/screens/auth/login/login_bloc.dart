import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lume/common/strings/auth_strings.dart';
import 'package:lume/core/errors/auth_failure.dart';
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
    this._hasSelectedCategories,
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
  final IHasSelectedCategories _hasSelectedCategories;

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
            destination: LoginDestination.selectCategory,
          ),
        );
        return;
      }

      await _signInWithEmail(
        email: state.email.trim(),
        password: state.password,
      );
      final destination = await _destinationAfterSignIn();
      emit(state.copyWith(isSubmitting: false, destination: destination));
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

  /// Web: no prefs → categories; prefs present or prefs check fails → home.
  Future<LoginDestination> _destinationAfterSignIn() async {
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
}
