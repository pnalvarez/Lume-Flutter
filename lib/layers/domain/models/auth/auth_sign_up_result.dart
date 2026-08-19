import 'package:lume/layers/domain/models/auth/auth_session.dart';

/// Outcome of email+password sign-up.
class AuthSignUpResult {
  const AuthSignUpResult({
    this.session,
    this.email,
    required this.needsEmailConfirmation,
  });

  final AuthSession? session;
  final String? email;
  final bool needsEmailConfirmation;
}
