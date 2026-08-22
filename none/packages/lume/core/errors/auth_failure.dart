/// Auth-layer failure. Independent of the Supabase SDK type of the same name.
sealed class AuthFailure implements Exception {
  const AuthFailure({this.message, this.cause});

  final String? message;
  final Object? cause;

  @override
  String toString() => '$runtimeType: ${message ?? ''}';
}

/// Sign-in rejected because the email has not been confirmed.
final class AuthEmailNotConfirmedFailure extends AuthFailure {
  const AuthEmailNotConfirmedFailure({super.message, super.cause, this.email});

  final String? email;
}

/// Any other auth operation failure (invalid credentials, network, etc.).
final class AuthOperationFailure extends AuthFailure {
  const AuthOperationFailure({
    required this.operation,
    super.message,
    super.cause,
  });

  final String operation;
}
