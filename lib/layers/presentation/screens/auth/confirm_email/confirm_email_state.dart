import 'package:flutter/foundation.dart';
import 'package:lume/layers/presentation/screens/auth/confirm_email/confirm_email_event.dart';

final _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

@immutable
final class ConfirmEmailState {
  const ConfirmEmailState({
    this.email = '',
    this.isSubmitting = false,
    this.notice,
    this.isError = false,
    this.destination,
  });

  final String email;
  final bool isSubmitting;
  final String? notice;
  final bool isError;
  final ConfirmEmailDestination? destination;

  bool get isEmailValid => _emailPattern.hasMatch(email.trim());
  bool get canResend => isEmailValid && !isSubmitting;

  ConfirmEmailState copyWith({
    String? email,
    bool? isSubmitting,
    String? notice,
    bool? isError,
    ConfirmEmailDestination? destination,
    bool clearNotice = false,
    bool clearDestination = false,
  }) {
    return ConfirmEmailState(
      email: email ?? this.email,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      notice: clearNotice ? null : notice ?? this.notice,
      isError: isError ?? this.isError,
      destination: clearDestination ? null : destination ?? this.destination,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ConfirmEmailState &&
      other.email == email &&
      other.isSubmitting == isSubmitting &&
      other.notice == notice &&
      other.isError == isError &&
      other.destination == destination;

  @override
  int get hashCode =>
      Object.hash(email, isSubmitting, notice, isError, destination);
}
