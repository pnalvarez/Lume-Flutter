import 'package:lume/layers/domain/models/auth/auth_session.dart';
import 'package:lume/layers/domain/models/auth/auth_sign_up_result.dart';

abstract interface class IAuthRepository {
  AuthSession? get currentSession;

  Stream<AuthSession?> observe();

  Future<AuthSession?> restore();

  Future<AuthSession> signIn({required String email, required String password});

  Future<AuthSignUpResult> signUp({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<void> resendConfirmationEmail({required String email});

  Future<void> requestPasswordRecovery({required String email});

  Future<void> updatePassword({required String password});

  void clearPasswordRecovery();
}
