/// Live session snapshot used by the JWT interceptor and route guards.
///
/// Distinct from the domain [AuthSession]: this type lives in core so the
/// interceptor never depends on domain models.
class AuthSessionSnapshot {
  const AuthSessionSnapshot({
    required this.accessToken,
    required this.userId,
    this.email,
    required this.isEmailConfirmed,
  });

  final String accessToken;
  final String userId;
  final String? email;
  final bool isEmailConfirmed;
}

/// Kind of auth-state event from the SDK adapter.
enum AuthChangeKind {
  signedIn,
  signedOut,
  passwordRecovery,
  userUpdated,
  tokenRefreshed,
  other,
}

/// One event from [IAuthService.onAuthStateChange].
class AuthStateChange {
  const AuthStateChange({required this.kind, this.session});

  final AuthChangeKind kind;
  final AuthSessionSnapshot? session;
}

/// Result of a sign-up call before mapping to domain.
class AuthSignUpSnapshot {
  const AuthSignUpSnapshot({
    this.session,
    this.email,
    required this.isEmailConfirmed,
  });

  final AuthSessionSnapshot? session;
  final String? email;
  final bool isEmailConfirmed;
}
