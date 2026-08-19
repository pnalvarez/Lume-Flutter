import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:lume/core/auth/auth_session.dart';
import 'package:lume/core/errors/auth_failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Thin adapter over Supabase Auth. The only type that may import the SDK.
abstract interface class IAuthService {
  AuthSessionSnapshot? get currentSession;

  Stream<AuthStateChange> get onAuthStateChange;

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

@LazySingleton(as: IAuthService)
final class AuthService implements IAuthService {
  AuthService() : this._();

  @visibleForTesting
  AuthService.withClient(SupabaseClient client) : this._(client: client);

  AuthService._({SupabaseClient? client}) : _clientOverride = client;

  final SupabaseClient? _clientOverride;

  GoTrueClient get _auth =>
      (_clientOverride ?? Supabase.instance.client).auth;

  @override
  AuthSessionSnapshot? get currentSession => _mapSession(_auth.currentSession);

  @override
  Stream<AuthStateChange> get onAuthStateChange {
    return _auth.onAuthStateChange.map(
      (data) => AuthStateChange(
        kind: _mapKind(data.event),
        session: _mapSession(data.session),
      ),
    );
  }

  @override
  Future<AuthSessionSnapshot?> restoreSession() async {
    return _mapSession(_auth.currentSession);
  }

  @override
  Future<AuthSessionSnapshot> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _auth.signInWithPassword(
        email: email,
        password: password,
      );
      final session = _mapSession(response.session);
      if (session == null) {
        throw const AuthOperationFailure(
          operation: 'signIn',
          message: 'Sign-in returned no session',
        );
      }
      return session;
    } on AuthFailure {
      rethrow;
    } on AuthException catch (error) {
      throw _mapAuthException(error, operation: 'signIn');
    } on ArgumentError catch (error) {
      throw _mapConfigError(error, operation: 'signIn');
    }
  }

  @override
  Future<AuthSignUpSnapshot> signUp({
    required String email,
    required String password,
    required String emailRedirectTo,
  }) async {
    try {
      final response = await _auth.signUp(
        email: email,
        password: password,
        emailRedirectTo: emailRedirectTo,
      );
      final session = _mapSession(response.session);
      final user = response.user;
      return AuthSignUpSnapshot(
        session: session,
        email: user?.email ?? email,
        isEmailConfirmed: _isEmailConfirmed(user),
      );
    } on AuthFailure {
      rethrow;
    } on AuthException catch (error) {
      throw _mapAuthException(error, operation: 'signUp');
    } on ArgumentError catch (error) {
      throw _mapConfigError(error, operation: 'signUp');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on AuthException catch (error) {
      throw _mapAuthException(error, operation: 'signOut');
    }
  }

  @override
  Future<void> resendSignupEmail({
    required String email,
    required String emailRedirectTo,
  }) async {
    try {
      await _auth.resend(
        type: OtpType.signup,
        email: email,
        emailRedirectTo: emailRedirectTo,
      );
    } on AuthException catch (error) {
      throw _mapAuthException(error, operation: 'resendSignupEmail');
    }
  }

  @override
  Future<void> resetPasswordForEmail({
    required String email,
    required String redirectTo,
  }) async {
    try {
      await _auth.resetPasswordForEmail(email, redirectTo: redirectTo);
    } on AuthException catch (error) {
      throw _mapAuthException(error, operation: 'resetPasswordForEmail');
    }
  }

  @override
  Future<void> updatePassword({required String password}) async {
    try {
      await _auth.updateUser(UserAttributes(password: password));
    } on AuthException catch (error) {
      throw _mapAuthException(error, operation: 'updatePassword');
    }
  }
}

AuthSessionSnapshot? _mapSession(Session? session) {
  final user = session?.user;
  if (session == null || user == null) return null;
  return AuthSessionSnapshot(
    accessToken: session.accessToken,
    userId: user.id,
    email: user.email,
    isEmailConfirmed: _isEmailConfirmed(user),
  );
}

bool _isEmailConfirmed(User? user) {
  if (user == null) return false;
  return user.emailConfirmedAt != null && user.emailConfirmedAt!.isNotEmpty;
}

AuthChangeKind _mapKind(AuthChangeEvent event) {
  return switch (event) {
    AuthChangeEvent.signedIn => AuthChangeKind.signedIn,
    AuthChangeEvent.signedOut => AuthChangeKind.signedOut,
    AuthChangeEvent.passwordRecovery => AuthChangeKind.passwordRecovery,
    AuthChangeEvent.userUpdated => AuthChangeKind.userUpdated,
    AuthChangeEvent.tokenRefreshed => AuthChangeKind.tokenRefreshed,
    _ => AuthChangeKind.other,
  };
}

AuthFailure _mapAuthException(
  AuthException error, {
  required String operation,
}) {
  final code = error.code;
  final message = error.message.toLowerCase();
  final unconfirmed = code == 'email_not_confirmed' ||
      code == 'phone_not_confirmed' ||
      message.contains('email not confirmed');
  if (unconfirmed) {
    return AuthEmailNotConfirmedFailure(
      message: error.message,
      cause: error,
    );
  }
  return AuthOperationFailure(
    operation: operation,
    message: error.message,
    cause: error,
  );
}

AuthFailure _mapConfigError(ArgumentError error, {required String operation}) {
  return AuthOperationFailure(
    operation: operation,
    message: 'failed to fetch',
    cause: error,
  );
}
