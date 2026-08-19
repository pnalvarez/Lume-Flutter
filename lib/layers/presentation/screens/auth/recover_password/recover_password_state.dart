import 'package:flutter/foundation.dart';

final _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

@immutable
final class RecoverPasswordState {
  const RecoverPasswordState({
    this.email = '',
    this.isSubmitting = false,
    this.sent = false,
    this.errorMessage,
    this.goToLogin = false,
  });

  final String email;
  final bool isSubmitting;
  final bool sent;
  final String? errorMessage;
  final bool goToLogin;

  bool get isEmailValid => _emailPattern.hasMatch(email.trim());
  bool get canSubmit => isEmailValid && !isSubmitting;

  RecoverPasswordState copyWith({
    String? email,
    bool? isSubmitting,
    bool? sent,
    String? errorMessage,
    bool? goToLogin,
    bool clearError = false,
  }) {
    return RecoverPasswordState(
      email: email ?? this.email,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      sent: sent ?? this.sent,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      goToLogin: goToLogin ?? this.goToLogin,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is RecoverPasswordState &&
      other.email == email &&
      other.isSubmitting == isSubmitting &&
      other.sent == sent &&
      other.errorMessage == errorMessage &&
      other.goToLogin == goToLogin;

  @override
  int get hashCode =>
      Object.hash(email, isSubmitting, sent, errorMessage, goToLogin);
}
