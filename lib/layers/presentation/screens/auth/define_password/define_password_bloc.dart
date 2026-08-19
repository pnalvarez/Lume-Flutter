import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lume/common/strings/auth_strings.dart';
import 'package:lume/layers/domain/usecases/clear_password_recovery.dart';
import 'package:lume/layers/domain/usecases/restore_session.dart';
import 'package:lume/layers/domain/usecases/update_password.dart';
import 'package:lume/layers/presentation/screens/auth/define_password/define_password_event.dart';
import 'package:lume/layers/presentation/screens/auth/define_password/define_password_state.dart';
import 'package:lume/layers/presentation/shared/auth_messages.dart';

final class DefinePasswordBloc
    extends Bloc<DefinePasswordEvent, DefinePasswordState> {
  DefinePasswordBloc({
    required IRestoreSession restoreSession,
    required IUpdatePassword updatePassword,
    required IClearPasswordRecovery clearPasswordRecovery,
  }) : _restoreSession = restoreSession,
       _updatePassword = updatePassword,
       _clearPasswordRecovery = clearPasswordRecovery,
       super(const DefinePasswordState()) {
    on<DefinePasswordStarted>(_onStarted);
    on<DefinePasswordChanged>(_onPasswordChanged);
    on<DefinePasswordConfirmChanged>(_onConfirmChanged);
    on<DefinePasswordSubmitted>(_onSubmitted);
    on<DefinePasswordRequestNewLink>(_onRequestNewLink);
    on<DefinePasswordNavigationHandled>(_onNavigationHandled);
  }

  final IRestoreSession _restoreSession;
  final IUpdatePassword _updatePassword;
  final IClearPasswordRecovery _clearPasswordRecovery;

  Future<void> _onStarted(
    DefinePasswordStarted event,
    Emitter<DefinePasswordState> emit,
  ) async {
    try {
      final session = await _restoreSession();
      emit(
        state.copyWith(
          status: session == null
              ? DefinePasswordStatus.invalid
              : DefinePasswordStatus.ready,
        ),
      );
    } on Object {
      emit(state.copyWith(status: DefinePasswordStatus.invalid));
    }
  }

  void _onPasswordChanged(
    DefinePasswordChanged event,
    Emitter<DefinePasswordState> emit,
  ) {
    emit(state.copyWith(password: event.password, clearError: true));
  }

  void _onConfirmChanged(
    DefinePasswordConfirmChanged event,
    Emitter<DefinePasswordState> emit,
  ) {
    emit(state.copyWith(confirmation: event.confirmation, clearError: true));
  }

  Future<void> _onSubmitted(
    DefinePasswordSubmitted event,
    Emitter<DefinePasswordState> emit,
  ) async {
    if (!state.canSubmit) return;
    emit(state.copyWith(isSubmitting: true, clearError: true));
    try {
      await _updatePassword(password: state.password);
      _clearPasswordRecovery();
      emit(
        state.copyWith(
          isSubmitting: false,
          notice: definePasswordSuccessNotice,
          destination: DefinePasswordDestination.home,
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

  void _onRequestNewLink(
    DefinePasswordRequestNewLink event,
    Emitter<DefinePasswordState> emit,
  ) {
    _clearPasswordRecovery();
    emit(
      state.copyWith(destination: DefinePasswordDestination.recoverPassword),
    );
  }

  void _onNavigationHandled(
    DefinePasswordNavigationHandled event,
    Emitter<DefinePasswordState> emit,
  ) {
    emit(state.copyWith(clearDestination: true, clearNotice: true));
  }
}
