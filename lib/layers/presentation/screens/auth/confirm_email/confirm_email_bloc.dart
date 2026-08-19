import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lume/common/strings/auth_strings.dart';
import 'package:lume/layers/domain/usecases/resend_confirmation_email.dart';
import 'package:lume/layers/presentation/screens/auth/confirm_email/confirm_email_event.dart';
import 'package:lume/layers/presentation/screens/auth/confirm_email/confirm_email_state.dart';
import 'package:lume/layers/presentation/shared/auth_messages.dart';

final class ConfirmEmailBloc
    extends Bloc<ConfirmEmailEvent, ConfirmEmailState> {
  ConfirmEmailBloc({
    required IResendConfirmationEmail resendConfirmationEmail,
    String email = '',
  }) : _resendConfirmationEmail = resendConfirmationEmail,
       super(ConfirmEmailState(email: email)) {
    on<ConfirmEmailChanged>(_onEmailChanged);
    on<ConfirmEmailResendPressed>(_onResendPressed);
    on<ConfirmEmailNoticeHandled>(_onNoticeHandled);
  }

  final IResendConfirmationEmail _resendConfirmationEmail;

  void _onEmailChanged(
    ConfirmEmailChanged event,
    Emitter<ConfirmEmailState> emit,
  ) {
    emit(state.copyWith(email: event.email, clearNotice: true));
  }

  Future<void> _onResendPressed(
    ConfirmEmailResendPressed event,
    Emitter<ConfirmEmailState> emit,
  ) async {
    if (!state.canResend) return;
    emit(state.copyWith(isSubmitting: true, clearNotice: true));
    try {
      await _resendConfirmationEmail(email: state.email.trim());
      emit(
        state.copyWith(
          isSubmitting: false,
          notice: confirmEmailResentNotice,
          isError: false,
        ),
      );
    } on Object catch (error) {
      emit(
        state.copyWith(
          isSubmitting: false,
          notice: authFailureMessage(error),
          isError: true,
        ),
      );
    }
  }

  void _onNoticeHandled(
    ConfirmEmailNoticeHandled event,
    Emitter<ConfirmEmailState> emit,
  ) {
    emit(state.copyWith(clearNotice: true));
  }
}
