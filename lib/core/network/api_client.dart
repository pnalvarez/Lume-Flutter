import 'package:lume/core/network/api_response.dart';
import 'package:lume/core/network/http_method.dart';

/// HTTP transport. Knows verbs, endpoints, headers, and JSON — not tables
/// or domain models. Feature DataSources should prefer [rpc] for RPCs.
abstract interface class ApiClient {
  /// Low-level request. Prefer [get], [post], or [rpc].
  Future<ApiResponse<T>> request<T>({
    required HttpMethod method,
    required String endpoint,
    Map<String, Object?>? queryParameters,
    Map<String, String>? headers,
    Object? body,
  });

  /// GET `{baseUrl}/{endpoint}`.
  Future<T> get<T>({
    required String endpoint,
    Map<String, Object?> queryParameters = const {},
    Map<String, String> headers = const {},
  });

  /// POST `{baseUrl}/{endpoint}`.
  Future<T> post<T>({
    required String endpoint,
    Object? body,
    Map<String, String> headers = const {},
  });

  /// POST `{baseUrl}/rpc/{name}` with JSON [params].
  ///
  /// The authenticated user comes from the JWT interceptor, not from [params].
  Future<T> rpc<T>(
    String name, {
    Object? params,
    Map<String, String> headers = const {},
  });
}
