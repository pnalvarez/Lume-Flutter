import 'dart:async';

import 'package:lume/core/auth/auth_session.dart';
import 'package:lume/core/auth/auth_session_provider.dart';

/// In-memory [IAuthSessionProvider] for widget and unit tests.
class FakeAuthSessionProvider implements IAuthSessionProvider {
  FakeAuthSessionProvider({this.session, this.isPasswordRecovery = false});

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

  final _changes = StreamController<void>.broadcast();

  @override
  Stream<void> get changes => _changes.stream;

  /// Sets [session] and notifies listeners, like the real provider does.
  void emit(AuthSessionSnapshot? next) {
    session = next;
    _changes.add(null);
  }

  @override
  void clearPasswordRecovery() {
    isPasswordRecovery = false;
  }

  @override
  Future<void> restore() async {}

  @override
  void dispose() {
    _changes.close();
  }
}
