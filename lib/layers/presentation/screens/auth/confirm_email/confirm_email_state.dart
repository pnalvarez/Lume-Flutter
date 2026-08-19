import 'package:flutter/foundation.dart';

final _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

@immutable
final class ConfirmEmailState {
  const ConfirmEmailState({
    this.email = '',
    this.isSubmitting = false,
    this.notice,
    this.isError = false,
  });

  final String email;
  final bool isSubmitting;
  final String? notice;
  final bool isError;

  bool get isEmailValid => _emailPattern.hasMatch(email.trim());
  bool get canResend => isEmailValid && !isSubmitting;

  ConfirmEmailState copyWith({
    String? email,
    bool? isSubmitting,
    String? notice,
    bool? isError,
    bool clearNotice = false,
  }) {
    return ConfirmEmailState(
      email: email ?? this.email,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      notice: clearNotice ? null : notice ?? this.notice,
      isError: isError ?? this.isError,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ConfirmEmailState &&
      other.email == email &&
      other.isSubmitting == isSubmitting &&
      other.notice == notice &&
      other.isError == isError;

  @override
  int get hashCode => Object.hash(email, isSubmitting, notice, isError);
}
