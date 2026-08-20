import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lume/common/strings/auth_strings.dart';
import 'package:lume/layers/domain/models/auth/auth_session.dart';
import 'package:lume/layers/domain/usecases/has_selected_categories.dart';
import 'package:lume/layers/domain/usecases/observe_auth_state.dart';
import 'package:lume/layers/domain/usecases/resend_confirmation_email.dart';
import 'package:lume/layers/presentation/screens/auth/confirm_email/confirm_email_event.dart';
import 'package:lume/layers/presentation/screens/auth/confirm_email/confirm_email_state.dart';
import 'package:lume/layers/presentation/shared/auth_messages.dart';

@injectable
final class ConfirmEmailBloc
    extends Bloc<ConfirmEmailEvent, ConfirmEmailState> {
  ConfirmEmailBloc(
    this._resendConfirmationEmail,
    this._observeAuthState,
    this._hasSelectedCategories,
  ) : super(const ConfirmEmailState()) {
    on<ConfirmEmailStarted>(_onStarted);
    on<ConfirmEmailAuthUpdated>(_onAuthUpdated);
    on<ConfirmEmailChanged>(_onEmailChanged);
    on<ConfirmEmailResendPressed>(_onResendPressed);
    on<ConfirmEmailNoticeHandled>(_onNoticeHandled);
    on<ConfirmEmailNavigationHandled>(_onNavigationHandled);
  }

  final IResendConfirmationEmail _resendConfirmationEmail;
  final IObserveAuthState _observeAuthState;
  final IHasSelectedCategories _hasSelectedCategories;

  StreamSubscription<AuthSession?>? _authSubscription;

  Future<void> _onStarted(
    ConfirmEmailStarted event,
    Emitter<ConfirmEmailState> emit,
  ) async {
    emit(state.copyWith(email: event.email));

    await _authSubscription?.cancel();
    _authSubscription = _observeAuthState().listen((session) {
      if (!isClosed) add(ConfirmEmailAuthUpdated(session));
    });
  }

  Future<void> _onAuthUpdated(
    ConfirmEmailAuthUpdated event,
    Emitter<ConfirmEmailState> emit,
  ) async {
    if (state.destination != null) return;

    final destination = await _destinationForConfirmedSession(event.session);
    if (destination == null || isClosed) return;

    await _authSubscription?.cancel();
    _authSubscription = null;

    emit(
      state.copyWith(
        notice: confirmEmailSuccessNotice,
        isError: false,
        destination: destination,
      ),
    );
  }

  Future<ConfirmEmailDestination?> _destinationForConfirmedSession(
    AuthSession? session,
  ) async {
    if (session == null ||
        !session.user.isEmailConfirmed ||
        session.isPasswordRecovery) {
      return null;
    }
    try {
      final hasSelected = await _hasSelectedCategories(forceRefresh: true);
      return hasSelected
          ? ConfirmEmailDestination.home
          : ConfirmEmailDestination.selectCategory;
    } on Object {
      return ConfirmEmailDestination.selectCategory;
    }
  }

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

  void _onNavigationHandled(
    ConfirmEmailNavigationHandled event,
    Emitter<ConfirmEmailState> emit,
  ) {
    emit(state.copyWith(clearDestination: true, clearNotice: true));
  }

  @override
  Future<void> close() async {
    await _authSubscription?.cancel();
    _authSubscription = null;
    return super.close();
  }
}
