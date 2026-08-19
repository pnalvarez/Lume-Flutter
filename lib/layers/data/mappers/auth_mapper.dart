import 'package:lume/core/auth/auth_session.dart';
import 'package:lume/layers/domain/models/auth/auth_session.dart';
import 'package:lume/layers/domain/models/auth/auth_user.dart';

abstract final class AuthMapper {
  static AuthSession? toDomain(
    AuthSessionSnapshot? snapshot, {
    required bool isPasswordRecovery,
  }) {
    if (snapshot == null) return null;
    return AuthSession(
      user: AuthUser(
        id: snapshot.userId,
        email: snapshot.email,
        isEmailConfirmed: snapshot.isEmailConfirmed,
      ),
      isPasswordRecovery: isPasswordRecovery,
    );
  }

  static AuthSession toDomainOrThrow(
    AuthSessionSnapshot snapshot, {
    required bool isPasswordRecovery,
  }) {
    return toDomain(snapshot, isPasswordRecovery: isPasswordRecovery)!;
  }
}
