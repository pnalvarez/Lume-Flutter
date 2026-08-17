import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/core/network/interceptors/sanitizing_log_interceptor.dart';

class _NoopRequestHandler extends RequestInterceptorHandler {
  @override
  void next(RequestOptions options) {}
}

void main() {
  group('SanitizingLogInterceptor', () {
    test('masks Authorization and apikey and redacts tokens in the body',
        () async {
      final logs = <String>[];
      final interceptor = SanitizingLogInterceptor(logPrint: logs.add);

      final options = RequestOptions(
        path: '/rest/v1/modulos',
        method: 'POST',
        headers: const {
          'Authorization': 'Bearer super-secret-access-token',
          'apikey': 'sb_publishable_secret_key_value',
          'Accept': 'application/json',
        },
        data: '{"access_token":"abc","name":"Ada"}',
      );

      interceptor.onRequest(options, _NoopRequestHandler());

      final joined = logs.join('\n');
      expect(joined, contains('--> POST'));
      expect(joined, contains('Accept: application/json'));
      expect(joined, isNot(contains('super-secret-access-token')));
      expect(joined, isNot(contains('sb_publishable_secret_key_value')));
      expect(joined, contains('Authorization:'));
      expect(joined, contains('***'));
      expect(joined, contains('"access_token":"***"'));
      expect(joined, contains('"name":"Ada"'));
    });
  });
}
