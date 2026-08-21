import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Debug logger that never prints access tokens, API keys, or cookies in full.
final class SanitizingLogInterceptor extends Interceptor {
  SanitizingLogInterceptor({void Function(String message)? logPrint})
    : _logPrint = logPrint ?? debugPrint;

  final void Function(String message) _logPrint;

  static const _maxBodyChars = 4000;

  static const _sensitiveHeaderNames = {
    'authorization',
    'apikey',
    'api-key',
    'x-api-key',
    'cookie',
    'set-cookie',
  };

  static final _sensitiveJsonKeys = RegExp(
    r'"(access_token|refresh_token|password|token|apikey|api_key)"\s*:\s*"[^"]*"',
    caseSensitive: false,
  );

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final buffer = StringBuffer()
      ..writeln('--> ${options.method} ${options.uri}');
    options.headers.forEach((key, value) {
      buffer.writeln('  $key: ${_maskHeader(key, value)}');
    });
    if (options.data != null) {
      buffer.writeln('  body: ${_sanitizeBody(options.data)}');
    }
    _logPrint(buffer.toString().trimRight());
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final buffer = StringBuffer()
      ..writeln(
        '<-- ${response.statusCode} ${response.requestOptions.method} '
        '${response.requestOptions.uri}',
      );
    if (response.data != null) {
      buffer.writeln('  body: ${_sanitizeBody(response.data)}');
    }
    _logPrint(buffer.toString().trimRight());
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logPrint(
      'xx ${err.type.name} ${err.requestOptions.method} '
      '${err.requestOptions.uri}: ${err.message}',
    );
    handler.next(err);
  }

  static Object _maskHeader(String name, Object? value) {
    if (_sensitiveHeaderNames.contains(name.toLowerCase())) {
      return _maskSecret('$value');
    }
    return value ?? '';
  }

  static String _maskSecret(String value) {
    if (value.length <= 12) return '***';
    return '${value.substring(0, 8)}… (len ${value.length})';
  }

  static String _sanitizeBody(Object? data) {
    var text = '$data';
    text = text.replaceAllMapped(
      _sensitiveJsonKeys,
      (match) => '"${match.group(1)}":"***"',
    );
    if (text.length <= _maxBodyChars) return text;
    return '${text.substring(0, _maxBodyChars)}… '
        '[truncated ${text.length - _maxBodyChars} chars]';
  }
}
