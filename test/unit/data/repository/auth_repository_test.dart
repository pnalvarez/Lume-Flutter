import 'package:flutter_test/flutter_test.dart';
import 'package:lume/core/auth/auth_session.dart';
import 'package:lume/core/config/app_config.dart';
import 'package:lume/layers/data/datasource/auth_data_source.dart';
import 'package:lume/layers/data/repository/auth_repository.dart';
import 'package:lume/layers/domain/models/auth/auth_session.dart';

import '../../../helpers/fake_auth_session_provider.dart';

class _FakeAuthDataSource implements IAuthDataSource {
  _FakeAuthDataSource();

  @override
  AuthSessionSnapshot? currentSession;

  var signOutCount = 0;
  AuthSignUpSnapshot? nextSignUp;
  AuthSessionSnapshot? nextSignIn;
  String? lastEmailRedirectTo;
  String? lastRecoveryRedirectTo;

  @override
  Future<AuthSessionSnapshot?> restoreSession() async => currentSession;

  @override
  Future<AuthSessionSnapshot> signIn({
    required String email,
    required String password,
  }) async {
    return nextSignIn!;
  }

  @override
  Future<AuthSignUpSnapshot> signUp({
    required String email,
    required String password,
    required String emailRedirectTo,
  }) async {
    lastEmailRedirectTo = emailRedirectTo;
    return nextSignUp!;
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
  }) async {
    lastEmailRedirectTo = emailRedirectTo;
  }

  @override
  Future<void> resetPasswordForEmail({
    required String email,
    required String redirectTo,
  }) async {
    lastRecoveryRedirectTo = redirectTo;
  }

  @override
  Future<void> updatePassword({required String password}) async {}
}

void main() {
  const snapshot = AuthSessionSnapshot(
    accessToken: 'jwt',
    userId: 'user-1',
    email: 'ada@example.com',
    isEmailConfirmed: true,
  );

  const config = AppConfig(
    supabaseUrl: 'https://example.supabase.co',
    supabaseAnonKey: 'anon',
  );

  late _FakeAuthDataSource dataSource;
  late FakeAuthSessionProvider session;
  late AuthRepository sut;

  setUp(() {
    dataSource = _FakeAuthDataSource();
    session = FakeAuthSessionProvider(session: snapshot);
    sut = AuthRepository(dataSource, session, config);
  });

  test('currentSession maps the provider snapshot to domain', () {
    final domain = sut.currentSession;
    expect(domain, isA<AuthSession>());
    expect(domain!.user.id, 'user-1');
    expect(domain.user.isEmailConfirmed, isTrue);
    expect(domain.isPasswordRecovery, isFalse);
  });

  test('unconfirmed sign-up signs out leftover session', () async {
    dataSource.nextSignUp = AuthSignUpSnapshot(
      session: snapshot.copyWith(isEmailConfirmed: false),
      email: 'ada@example.com',
      isEmailConfirmed: false,
    );

    final result = await sut.signUp(
      email: 'ada@example.com',
      password: 'secret1',
    );

    expect(result.needsEmailConfirmation, isTrue);
    expect(result.session, isNull);
    expect(dataSource.signOutCount, 1);
    expect(dataSource.lastEmailRedirectTo, AppConfig.defaultAuthCallbackUrl);
  });

  test('confirmed sign-up keeps the session', () async {
    dataSource.nextSignUp = const AuthSignUpSnapshot(
      session: snapshot,
      email: 'ada@example.com',
      isEmailConfirmed: true,
    );

    final result = await sut.signUp(
      email: 'ada@example.com',
      password: 'secret1',
    );

    expect(result.needsEmailConfirmation, isFalse);
    expect(result.session?.user.id, 'user-1');
    expect(dataSource.signOutCount, 0);
  });

  test('requestPasswordRecovery uses the recovery deep link', () async {
    await sut.requestPasswordRecovery(email: 'ada@example.com');
    expect(
      dataSource.lastRecoveryRedirectTo,
      AppConfig.defaultPasswordRecoveryUrl,
    );
  });
}

extension on AuthSessionSnapshot {
  AuthSessionSnapshot copyWith({bool? isEmailConfirmed}) {
    return AuthSessionSnapshot(
      accessToken: accessToken,
      userId: userId,
      email: email,
      isEmailConfirmed: isEmailConfirmed ?? this.isEmailConfirmed,
    );
  }
}
