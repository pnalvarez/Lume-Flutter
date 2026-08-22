import 'package:flutter_test/flutter_test.dart';
import 'package:lume/core/auth/auth_session.dart';
import 'package:lume/core/auth/auth_session_provider.dart';

import '../../helpers/fake_auth_service.dart';

void main() {
  const snapshot = AuthSessionSnapshot(
    accessToken: 'jwt',
    userId: 'user-1',
    email: 'ada@example.com',
    isEmailConfirmed: true,
  );

  late FakeAuthService service;
  late AuthSessionProvider sut;

  setUp(() {
    service = FakeAuthService();
    sut = AuthSessionProvider(service);
  });

  tearDown(() {
    sut.dispose();
    service.dispose();
  });

  test('restore copies the SDK session into the provider', () async {
    service.currentSession = snapshot;

    await sut.restore();

    expect(sut.accessToken, 'jwt');
    expect(sut.hasSession, isTrue);
    expect(sut.isEmailConfirmed, isTrue);
    expect(sut.email, 'ada@example.com');
  });

  test('PASSWORD_RECOVERY sets the recovery flag', () async {
    service.controller.add(
      const AuthStateChange(
        kind: AuthChangeKind.passwordRecovery,
        session: snapshot,
      ),
    );
    await Future<void>.delayed(Duration.zero);

    expect(sut.isPasswordRecovery, isTrue);
    expect(sut.hasSession, isTrue);

    sut.clearPasswordRecovery();
    expect(sut.isPasswordRecovery, isFalse);
  });

  test('SIGNED_OUT clears session and recovery', () async {
    service.currentSession = snapshot;
    await sut.restore();
    service.controller.add(
      const AuthStateChange(
        kind: AuthChangeKind.passwordRecovery,
        session: snapshot,
      ),
    );
    await Future<void>.delayed(Duration.zero);

    service.controller.add(
      const AuthStateChange(kind: AuthChangeKind.signedOut),
    );
    await Future<void>.delayed(Duration.zero);

    expect(sut.hasSession, isFalse);
    expect(sut.isPasswordRecovery, isFalse);
  });
}
