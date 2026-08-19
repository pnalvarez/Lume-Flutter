import 'package:lume/core/auth/auth_session.dart';
import 'package:lume/core/auth/auth_session_provider.dart';

/// In-memory [IAuthSessionProvider] for widget and unit tests.
class FakeAuthSessionProvider implements IAuthSessionProvider {
  FakeAuthSessionProvider({
    this.session,
    this.isPasswordRecovery = false,
  });

  @override
  AuthSessionSnapshot? session;

  @override
  bool isPasswordRecovery;

  @override
  String? get accessToken => session?.accessToken;

  @override
  bool get hasSession => session != null;

  @override
  bool get isEmailConfirmed => session?.isEmailConfirmed ?? false;

  @override
  String? get userId => session?.userId;

  @override
  String? get email => session?.email;

  @override
  Stream<void> get changes => const Stream.empty();

  @override
  void clearPasswordRecovery() {
    isPasswordRecovery = false;
  }

  @override
  Future<void> restore() async {}

  @override
  void dispose() {}
}
