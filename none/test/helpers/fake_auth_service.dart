import 'dart:async';

import 'package:lume/core/auth/auth_service.dart';
import 'package:lume/core/auth/auth_session.dart';

/// Controllable [IAuthService] for unit tests.
class FakeAuthService implements IAuthService {
  FakeAuthService({this.currentSession});

  @override
  AuthSessionSnapshot? currentSession;

  final controller = StreamController<AuthStateChange>.broadcast();

  var signOutCount = 0;

  AuthSessionSnapshot? nextSignIn;
  Object? signInError;
  AuthSignUpSnapshot? nextSignUp;
  Object? signUpError;

  @override
  Stream<AuthStateChange> get onAuthStateChange => controller.stream;

  @override
  Future<AuthSessionSnapshot?> restoreSession() async => currentSession;

  @override
  Future<AuthSessionSnapshot> signIn({
    required String email,
    required String password,
  }) async {
    final error = signInError;
    if (error != null) throw error;
    final session = nextSignIn;
    if (session == null) {
      throw StateError('FakeAuthService.nextSignIn was not set');
    }
    currentSession = session;
    return session;
  }

  @override
  Future<AuthSignUpSnapshot> signUp({
    required String email,
    required String password,
    required String emailRedirectTo,
  }) async {
    final error = signUpError;
    if (error != null) throw error;
    final result = nextSignUp;
    if (result == null) {
      throw StateError('FakeAuthService.nextSignUp was not set');
    }
    currentSession = result.session;
    return result;
  }

  @override
  Future<void> signOut() async {
    signOutCount += 1;
    currentSession = null;
  }

  @override
  Future<void> resendSignupEmail({
    required String email,
    required String emailRedirectTo,
  }) async {}

  @override
  Future<void> resetPasswordForEmail({
    required String email,
    required String redirectTo,
  }) async {}

  @override
  Future<void> updatePassword({required String password}) async {}

  Future<void> dispose() => controller.close();
}
