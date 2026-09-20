import 'package:lume/core/errors/api_exception.dart';

/// Runs [action] up to [maxAttempts] times for transient RPC failures.
///
/// Used by trail read RPCs so cold-start flakes (timeout, network, auth race)
/// do not surface as a Home error before a short automatic retry window.
Future<T> withRpcRetries<T>(
  Future<T> Function() action, {
  int maxAttempts = 3,
  Duration delayBetweenAttempts = const Duration(milliseconds: 300),
  Future<void> Function(Duration delay)? wait,
  bool Function(Object error)? retryIf,
}) async {
  assert(maxAttempts >= 1, 'maxAttempts must be >= 1');
  final shouldRetry = retryIf ?? isTransientRpcFailure;
  final sleeper = wait ?? Future<void>.delayed;

  Object? lastError;
  for (var attempt = 1; attempt <= maxAttempts; attempt++) {
    try {
      return await action();
    } on Object catch (error) {
      lastError = error;
      final hasMoreAttempts = attempt < maxAttempts;
      if (!hasMoreAttempts || !shouldRetry(error)) {
        rethrow;
      }
      await sleeper(delayBetweenAttempts);
    }
  }
  // Unreachable when maxAttempts >= 1, but keeps the analyzer happy.
  Error.throwWithStackTrace(lastError!, StackTrace.current);
}

/// Transient transport / auth failures that are worth retrying on cold start.
bool isTransientRpcFailure(Object error) {
  if (error is ApiCancelledException) return false;
  if (error is ApiTimeoutException || error is ApiNetworkException) {
    return true;
  }
  if (error is ApiHttpException) {
    final code = error.statusCode ?? 0;
    return code == 401 ||
        code == 403 ||
        code == 408 ||
        code == 429 ||
        code >= 500;
  }
  if (error is ApiUnknownException) return true;
  return false;
}
