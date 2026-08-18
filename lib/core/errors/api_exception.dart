/// Transport-level failure from [IApiClient]. Independent of Dio.
sealed class ApiException implements Exception {
  const ApiException({this.message, this.statusCode, this.cause});

  final String? message;
  final int? statusCode;
  final Object? cause;

  @override
  String toString() => '$runtimeType(${statusCode ?? '-'}): ${message ?? ''}';
}

/// Non-2xx HTTP response.
final class ApiHttpException extends ApiException {
  const ApiHttpException({
    required int statusCode,
    super.message,
    this.data,
    super.cause,
  }) : super(statusCode: statusCode);

  /// Decoded error body, when present.
  final Object? data;
}

/// Connect, send, or receive timeout.
final class ApiTimeoutException extends ApiException {
  const ApiTimeoutException({super.message, super.cause});
}

/// DNS failure, connection refused, TLS issues, or offline.
final class ApiNetworkException extends ApiException {
  const ApiNetworkException({super.message, super.cause});
}

/// Request was cancelled before completion.
final class ApiCancelledException extends ApiException {
  const ApiCancelledException({super.message, super.cause});
}

/// Unexpected client error that does not fit the other kinds.
final class ApiUnknownException extends ApiException {
  const ApiUnknownException({super.message, super.cause});
}
