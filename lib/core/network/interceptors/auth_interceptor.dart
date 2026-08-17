import 'package:dio/dio.dart';
import 'package:lume/core/auth/auth_token_provider.dart';

/// Attaches `Authorization: Bearer <token>` when a session token is available.
///
/// Does not overwrite a header already set on the request.
final class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokenProvider);

  final AuthTokenProvider _tokenProvider;

  static const authorizationHeader = 'Authorization';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _tokenProvider.accessToken;
    if (token != null && token.isNotEmpty) {
      options.headers.putIfAbsent(
        authorizationHeader,
        () => 'Bearer $token',
      );
    }
    handler.next(options);
  }
}
