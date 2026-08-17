import 'package:dio/dio.dart';

/// Attaches the Supabase publishable key required by PostgREST / GoTrue gateways.
///
/// Does not overwrite a header already set on the request.
final class SupabaseHeadersInterceptor extends Interceptor {
  SupabaseHeadersInterceptor({required this.apiKey});

  final String apiKey;

  static const apiKeyHeader = 'apikey';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (apiKey.isNotEmpty) {
      options.headers.putIfAbsent(apiKeyHeader, () => apiKey);
    }
    handler.next(options);
  }
}
