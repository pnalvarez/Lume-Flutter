import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lume/layers/domain/usecases/request_password_recovery.dart';
import 'package:lume/layers/presentation/screens/recover_password/recover_password_event.dart';
import 'package:lume/layers/presentation/screens/recover_password/recover_password_state.dart';
import 'package:lume/layers/presentation/shared/auth_messages.dart';

final class RecoverPasswordBloc
    extends Bloc<RecoverPasswordEvent, RecoverPasswordState> {
  RecoverPasswordBloc({required IRequestPasswordRecovery requestPasswordRecovery})
      : _requestPasswordRecovery = requestPasswordRecovery,
        super(const RecoverPasswordState()) {
    on<RecoverPasswordEmailChanged>(_onEmailChanged);
    on<RecoverPasswordSubmitted>(_onSubmitted);
    on<RecoverPasswordNoticeHandled>(_onNoticeHandled);
    on<RecoverPasswordGoToLogin>(_onGoToLogin);
    on<RecoverPasswordNavigationHandled>(_onNavigationHandled);
  }

  final IRequestPasswordRecovery _requestPasswordRecovery;

  void _onEmailChanged(
    RecoverPasswordEmailChanged event,
    Emitter<RecoverPasswordState> emit,
  ) {
    emit(state.copyWith(email: event.email, clearError: true));
  }

  Future<void> _onSubmitted(
    RecoverPasswordSubmitted event,
    Emitter<RecoverPasswordState> emit,
  ) async {
    if (!state.canSubmit) return;
    emit(state.copyWith(isSubmitting: true, clearError: true));
    try {
      await _requestPasswordRecovery(email: state.email.trim());
      emit(state.copyWith(isSubmitting: false, sent: true));
    } on Object catch (error) {
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: authFailureMessage(error),
        ),
      );
    }
  }

  void _onNoticeHandled(
    RecoverPasswordNoticeHandled event,
    Emitter<RecoverPasswordState> emit,
  ) {
    emit(state.copyWith(clearError: true));
  }

  void _onGoToLogin(
    RecoverPasswordGoToLogin event,
    Emitter<RecoverPasswordState> emit,
  ) {
    emit(state.copyWith(goToLogin: true));
  }

  void _onNavigationHandled(
    RecoverPasswordNavigationHandled event,
    Emitter<RecoverPasswordState> emit,
  ) {
    emit(state.copyWith(goToLogin: false));
  }
}
