import 'package:lume/core/errors/auth_failure.dart';

/// Maps auth failures to the Portuguese copy used on web.
String authFailureMessage(Object error) {
  if (error is AuthEmailNotConfirmedFailure) {
    return 'Confirme seu email antes de entrar.';
  }
  if (error is AuthOperationFailure) {
    final message = (error.message ?? '').toLowerCase();
    if (message.contains('invalid login credentials') ||
        message.contains('invalid_credentials')) {
      return 'Email ou senha incorretos.';
    }
    if (message.contains('user already registered') ||
        message.contains('already registered')) {
      return 'Este email já está cadastrado.';
    }
    if (message.contains('failed to fetch') ||
        message.contains('socket') ||
        message.contains('network')) {
      return 'Não foi possível conectar. Verifique sua conexão e tente novamente.';
    }
    if (error.message != null && error.message!.trim().isNotEmpty) {
      return error.message!;
    }
  }
  return 'Erro ao autenticar';
}
