import 'package:injectable/injectable.dart';
import 'package:lume/core/auth/auth_service.dart';
import 'package:lume/core/auth/auth_session.dart';

abstract interface class IAuthDataSource {
  AuthSessionSnapshot? get currentSession;

  Future<AuthSessionSnapshot?> restoreSession();

  Future<AuthSessionSnapshot> signIn({
    required String email,
    required String password,
  });

  Future<AuthSignUpSnapshot> signUp({
    required String email,
    required String password,
    required String emailRedirectTo,
  });

  Future<void> signOut();

  Future<void> resendSignupEmail({
    required String email,
    required String emailRedirectTo,
  });

  Future<void> resetPasswordForEmail({
    required String email,
    required String redirectTo,
  });

  Future<void> updatePassword({required String password});
}

@Injectable(as: IAuthDataSource)
final class AuthDataSource implements IAuthDataSource {
  AuthDataSource(this._authService);

  final IAuthService _authService;

  @override
  AuthSessionSnapshot? get currentSession => _authService.currentSession;

  @override
  Future<AuthSessionSnapshot?> restoreSession() {
    return _authService.restoreSession();
  }

  @override
  Future<AuthSessionSnapshot> signIn({
    required String email,
    required String password,
  }) {
    return _authService.signIn(email: email, password: password);
  }

  @override
  Future<AuthSignUpSnapshot> signUp({
    required String email,
    required String password,
    required String emailRedirectTo,
  }) {
    return _authService.signUp(
      email: email,
      password: password,
      emailRedirectTo: emailRedirectTo,
    );
  }

  @override
  Future<void> signOut() => _authService.signOut();

  @override
  Future<void> resendSignupEmail({
    required String email,
    required String emailRedirectTo,
  }) {
    return _authService.resendSignupEmail(
      email: email,
      emailRedirectTo: emailRedirectTo,
    );
  }

  @override
  Future<void> resetPasswordForEmail({
    required String email,
    required String redirectTo,
  }) {
    return _authService.resetPasswordForEmail(
      email: email,
      redirectTo: redirectTo,
    );
  }

  @override
  Future<void> updatePassword({required String password}) {
    return _authService.updatePassword(password: password);
  }
}
