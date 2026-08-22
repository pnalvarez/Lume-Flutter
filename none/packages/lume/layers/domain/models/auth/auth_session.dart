import 'package:lume/layers/domain/models/auth/auth_user.dart';

/// Current auth session for use cases and presentation.
class AuthSession {
  const AuthSession({required this.user, required this.isPasswordRecovery});

  final AuthUser user;
  final bool isPasswordRecovery;
}
