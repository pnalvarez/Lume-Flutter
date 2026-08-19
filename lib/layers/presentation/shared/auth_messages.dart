import 'package:lume/common/strings/auth_strings.dart';
import 'package:lume/core/errors/auth_failure.dart';

/// Maps auth failures to the Portuguese copy used on web.
String authFailureMessage(Object error) {
  if (error is AuthEmailNotConfirmedFailure) {
    return authErrorEmailNotConfirmed;
  }
  if (error is AuthOperationFailure) {
    final message = (error.message ?? '').toLowerCase();
    if (message.contains('invalid login credentials') ||
        message.contains('invalid_credentials')) {
      return authErrorInvalidCredentials;
    }
    if (message.contains('user already registered') ||
        message.contains('already registered')) {
      return authErrorEmailAlreadyRegistered;
    }
    if (message.contains('failed to fetch') ||
        message.contains('socket') ||
        message.contains('network')) {
      return authErrorNetwork;
    }
    if (error.message != null && error.message!.trim().isNotEmpty) {
      return error.message!;
    }
  }
  return authErrorGeneric;
}
