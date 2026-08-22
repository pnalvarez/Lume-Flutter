import 'package:flutter/foundation.dart';
import 'package:lume/common/strings/auth_strings.dart';
import 'package:lume/layers/presentation/screens/auth/define_password/define_password_event.dart';

@immutable
final class DefinePasswordState {
  const DefinePasswordState({
    this.status = DefinePasswordStatus.checking,
    this.password = '',
    this.confirmation = '',
    this.isSubmitting = false,
    this.errorMessage,
    this.notice,
    this.destination,
  });

  final DefinePasswordStatus status;
  final String password;
  final String confirmation;
  final bool isSubmitting;
  final String? errorMessage;
  final String? notice;
  final DefinePasswordDestination? destination;

  String? get validationError {
    if (password.isEmpty && confirmation.isEmpty) {
      return definePasswordValidationBothEmpty;
    }
    if (password.isEmpty) return definePasswordValidationPasswordEmpty;
    if (confirmation.isEmpty) return definePasswordValidationConfirmEmpty;
    if (password.length < 6) {
      return definePasswordValidationPasswordShort;
    }
    if (confirmation.length < 6) {
      return definePasswordValidationConfirmShort;
    }
    if (password != confirmation) return definePasswordValidationMismatch;
    return null;
  }

  bool get canSubmit =>
      !isSubmitting &&
      validationError == null &&
      status == DefinePasswordStatus.ready;

  DefinePasswordState copyWith({
    DefinePasswordStatus? status,
    String? password,
    String? confirmation,
    bool? isSubmitting,
    String? errorMessage,
    String? notice,
    DefinePasswordDestination? destination,
    bool clearError = false,
    bool clearNotice = false,
    bool clearDestination = false,
  }) {
    return DefinePasswordState(
      status: status ?? this.status,
      password: password ?? this.password,
      confirmation: confirmation ?? this.confirmation,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      notice: clearNotice ? null : notice ?? this.notice,
      destination: clearDestination ? null : destination ?? this.destination,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is DefinePasswordState &&
      other.status == status &&
      other.password == password &&
      other.confirmation == confirmation &&
      other.isSubmitting == isSubmitting &&
      other.errorMessage == errorMessage &&
      other.notice == notice &&
      other.destination == destination;

  @override
  int get hashCode => Object.hash(
    status,
    password,
    confirmation,
    isSubmitting,
    errorMessage,
    notice,
    destination,
  );
}
