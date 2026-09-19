import 'package:flutter_test/flutter_test.dart';
import 'package:lume/core/errors/api_exception.dart';
import 'package:lume/core/network/rpc_retry.dart';

void main() {
  test('returns on first success', () async {
    var calls = 0;
    final value = await withRpcRetries(() async {
      calls += 1;
      return 42;
    }, wait: (_) async {});

    expect(value, 42);
    expect(calls, 1);
  });

  test('retries transient failures then succeeds', () async {
    var calls = 0;
    final delays = <Duration>[];

    final value = await withRpcRetries(
      () async {
        calls += 1;
        if (calls < 3) {
          throw const ApiTimeoutException(message: 'timeout');
        }
        return 'ok';
      },
      maxAttempts: 3,
      delayBetweenAttempts: const Duration(milliseconds: 10),
      wait: (delay) async => delays.add(delay),
    );

    expect(value, 'ok');
    expect(calls, 3);
    expect(delays, hasLength(2));
  });

  test('does not retry non-transient failures', () async {
    var calls = 0;

    await expectLater(
      () => withRpcRetries(
        () async {
          calls += 1;
          throw const FormatException('bad payload');
        },
        maxAttempts: 3,
        wait: (_) async {},
      ),
      throwsA(isA<FormatException>()),
    );
    expect(calls, 1);
  });

  test('rethrows after exhausting attempts', () async {
    var calls = 0;

    await expectLater(
      () => withRpcRetries(
        () async {
          calls += 1;
          throw const ApiNetworkException(message: 'offline');
        },
        maxAttempts: 3,
        wait: (_) async {},
      ),
      throwsA(isA<ApiNetworkException>()),
    );
    expect(calls, 3);
  });

  test('isTransientRpcFailure covers auth and server errors', () {
    expect(isTransientRpcFailure(const ApiTimeoutException()), isTrue);
    expect(isTransientRpcFailure(const ApiNetworkException()), isTrue);
    expect(
      isTransientRpcFailure(const ApiHttpException(statusCode: 401)),
      isTrue,
    );
    expect(
      isTransientRpcFailure(const ApiHttpException(statusCode: 503)),
      isTrue,
    );
    expect(
      isTransientRpcFailure(const ApiHttpException(statusCode: 400)),
      isFalse,
    );
    expect(isTransientRpcFailure(const FormatException('x')), isFalse);
    expect(isTransientRpcFailure(const ApiCancelledException()), isFalse);
  });
}
