import 'package:flutter_test/flutter_test.dart';
import 'package:lume/core/auth/auth_session.dart';
import 'package:lume/core/errors/auth_failure.dart';
import 'package:lume/layers/data/datasource/auth_data_source.dart';

import '../../helpers/fake_auth_service.dart';

void main() {
  const snapshot = AuthSessionSnapshot(
    accessToken: 'jwt',
    userId: 'user-1',
    email: 'ada@example.com',
    isEmailConfirmed: true,
  );

  late FakeAuthService service;
  late AuthDataSource sut;

  setUp(() {
    service = FakeAuthService();
    sut = AuthDataSource(service);
  });

  tearDown(() async {
    await service.dispose();
  });

  test('signIn returns the session from the auth service', () async {
    service.nextSignIn = snapshot;

    final result = await sut.signIn(
      email: 'ada@example.com',
      password: 'secret1',
    );

    expect(result.userId, 'user-1');
  });

  test('signIn rethrows AuthEmailNotConfirmedFailure', () async {
    service.signInError = const AuthEmailNotConfirmedFailure(
      email: 'ada@example.com',
    );

    expect(
      () => sut.signIn(email: 'ada@example.com', password: 'secret1'),
      throwsA(isA<AuthEmailNotConfirmedFailure>()),
    );
  });
}
