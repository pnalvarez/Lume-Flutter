import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:lume/core/auth/auth_service.dart';
import 'package:lume/core/auth/auth_session.dart';
import 'package:lume/core/auth/auth_token_provider.dart';

/// Live auth session for interceptors and route guards.
abstract interface class IAuthSessionProvider implements IAuthTokenProvider {
  AuthSessionSnapshot? get session;

  bool get hasSession;

  bool get isEmailConfirmed;

  bool get isPasswordRecovery;

  String? get userId;

  String? get email;

  /// Fires after [session] or [isPasswordRecovery] changes.
  Stream<void> get changes;

  void clearPasswordRecovery();

  /// Reads the persisted SDK session into this provider.
  Future<void> restore();

  void dispose();
}

@LazySingleton(as: IAuthSessionProvider)
final class AuthSessionProvider implements IAuthSessionProvider {
  AuthSessionProvider(this._authService) {
    _subscription = _authService.onAuthStateChange.listen(_onAuthStateChange);
    _session = _authService.currentSession;
  }

  final IAuthService _authService;

  AuthSessionSnapshot? _session;
  var _isPasswordRecovery = false;
  final _changes = StreamController<void>.broadcast();
  StreamSubscription<AuthStateChange>? _subscription;

  @override
  String? get accessToken => _session?.accessToken;

  @override
  AuthSessionSnapshot? get session => _session;

  @override
  bool get hasSession => _session != null;

  @override
  bool get isEmailConfirmed => _session?.isEmailConfirmed ?? false;

  @override
  bool get isPasswordRecovery => _isPasswordRecovery;

  @override
  String? get userId => _session?.userId;

  @override
  String? get email => _session?.email;

  @override
  Stream<void> get changes => _changes.stream;

  @override
  void clearPasswordRecovery() {
    if (!_isPasswordRecovery) return;
    _isPasswordRecovery = false;
    _emit();
  }

  @override
  Future<void> restore() async {
    _session = await _authService.restoreSession();
    _emit();
  }

  void _onAuthStateChange(AuthStateChange change) {
    if (change.kind == AuthChangeKind.passwordRecovery) {
      _isPasswordRecovery = true;
    }
    if (change.kind == AuthChangeKind.signedOut) {
      _isPasswordRecovery = false;
    }
    _session = change.session;
    _emit();
  }

  void _emit() {
    if (!_changes.isClosed) _changes.add(null);
  }

  @override
  @disposeMethod
  void dispose() {
    _subscription?.cancel();
    _changes.close();
  }
}
