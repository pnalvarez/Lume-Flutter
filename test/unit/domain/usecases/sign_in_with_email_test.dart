import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/domain/models/auth/auth_session.dart';
import 'package:lume/layers/domain/models/auth/auth_user.dart';
import 'package:lume/layers/domain/usecases/sign_in_with_email.dart';
import 'package:lume/layers/domain/usecases/sign_up_with_email.dart';
import 'package:lume/layers/domain/models/auth/auth_sign_up_result.dart';
import 'package:lume/layers/domain/repository/auth_repository.dart';

class _FakeAuthRepository implements IAuthRepository {
  AuthSession? session;
  AuthSignUpResult? signUpResult;
  var signInCount = 0;

  @override
  AuthSession? get currentSession => session;

  @override
  Stream<AuthSession?> observe() => const Stream.empty();

  @override
  Future<AuthSession?> restore() async => session;

  @override
  Future<AuthSession> signIn({
    required String email,
    required String password,
  }) async {
    signInCount += 1;
    return session!;
  }

  @override
  Future<AuthSignUpResult> signUp({
    required String email,
    required String password,
  }) async {
    return signUpResult!;
  }

  @override
  Future<void> signOut() async {}

  @override
  Future<void> resendConfirmationEmail({required String email}) async {}

  @override
  Future<void> requestPasswordRecovery({required String email}) async {}

  @override
  Future<void> updatePassword({required String password}) async {}

  @override
  void clearPasswordRecovery() {}
}

void main() {
  const session = AuthSession(
    user: AuthUser(
      id: 'user-1',
      email: 'ada@example.com',
      isEmailConfirmed: true,
    ),
    isPasswordRecovery: false,
  );

  test('SignInWithEmail delegates to the repository', () async {
    final repository = _FakeAuthRepository()..session = session;
    final result = await SignInWithEmail(repository)(
      email: 'ada@example.com',
      password: 'secret1',
    );

    expect(result.user.id, 'user-1');
    expect(repository.signInCount, 1);
  });

  test('SignUpWithEmail delegates to the repository', () async {
    final repository = _FakeAuthRepository()
      ..signUpResult = const AuthSignUpResult(
        email: 'ada@example.com',
        needsEmailConfirmation: true,
      );

    final result = await SignUpWithEmail(repository)(
      email: 'ada@example.com',
      password: 'secret1',
    );

    expect(result.needsEmailConfirmation, isTrue);
  });
}
