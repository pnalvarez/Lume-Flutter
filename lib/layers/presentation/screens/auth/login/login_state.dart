import 'package:flutter/foundation.dart';
import 'package:lume/layers/presentation/screens/auth/login/login_event.dart';

@immutable
final class LoginState {
  const LoginState({
    this.mode = LoginMode.login,
    this.email = '',
    this.password = '',
    this.isSubmitting = false,
    this.errorMessage,
    this.notice,
    this.destination,
  });

  final LoginMode mode;
  final String email;
  final String password;
  final bool isSubmitting;
  final String? errorMessage;
  final String? notice;
  final LoginDestination? destination;

  bool get canSubmit =>
      !isSubmitting && email.trim().isNotEmpty && password.length >= 6;

  LoginState copyWith({
    LoginMode? mode,
    String? email,
    String? password,
    bool? isSubmitting,
    String? errorMessage,
    String? notice,
    LoginDestination? destination,
    bool clearError = false,
    bool clearNotice = false,
    bool clearDestination = false,
  }) {
    return LoginState(
      mode: mode ?? this.mode,
      email: email ?? this.email,
      password: password ?? this.password,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      notice: clearNotice ? null : notice ?? this.notice,
      destination: clearDestination ? null : destination ?? this.destination,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is LoginState &&
      other.mode == mode &&
      other.email == email &&
      other.password == password &&
      other.isSubmitting == isSubmitting &&
      other.errorMessage == errorMessage &&
      other.notice == notice &&
      other.destination == destination;

  @override
  int get hashCode => Object.hash(
    mode,
    email,
    password,
    isSubmitting,
    errorMessage,
    notice,
    destination,
  );
}
