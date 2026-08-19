import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:lume/core/auth/auth_token_provider.dart';
import 'package:lume/core/config/app_config.dart';
import 'package:lume/core/errors/api_exception.dart';
import 'package:lume/core/network/api_response.dart';
import 'package:lume/core/network/http_method.dart';
import 'package:lume/core/network/interceptors/auth_interceptor.dart';
import 'package:lume/core/network/interceptors/sanitizing_log_interceptor.dart';
import 'package:lume/core/network/interceptors/supabase_headers_interceptor.dart';

/// HTTP transport. Knows verbs, endpoints, headers, and JSON — not tables
/// or domain models. Feature DataSources should prefer [rpc] for RPCs.
abstract interface class IApiClient {
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

/// [IApiClient] backed by Dio. DataSources depend on [IApiClient], not on Dio.
@LazySingleton(as: IApiClient)
final class ApiClient implements IApiClient {
  ApiClient({required Dio dio}) : _dio = dio;

  @factoryMethod
  factory ApiClient.fromInjection(
    AppConfig config,
    IAuthTokenProvider tokenProvider,
  ) =>
      ApiClient.create(
        baseUrl: config.supabaseUrl,
        apiKey: config.supabaseAnonKey,
        tokenProvider: tokenProvider,
      );

  /// Production wiring: timeouts, JSON headers, and optional interceptors.
  factory ApiClient.create({
    required String baseUrl,
    String? apiKey,
    IAuthTokenProvider? tokenProvider,
    bool enableLogging = kDebugMode,
    Duration connectTimeout = const Duration(seconds: 15),
    Duration receiveTimeout = const Duration(seconds: 15),
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout,
        headers: const {
          Headers.contentTypeHeader: Headers.jsonContentType,
          Headers.acceptHeader: Headers.jsonContentType,
        },
      ),
    );

    if (apiKey != null && apiKey.isNotEmpty) {
      dio.interceptors.add(SupabaseHeadersInterceptor(apiKey: apiKey));
    }
    if (tokenProvider != null) {
      dio.interceptors.add(AuthInterceptor(tokenProvider));
    }
    if (enableLogging) {
      dio.interceptors.add(SanitizingLogInterceptor());
    }

    return ApiClient(dio: dio);
  }

  final Dio _dio;

  @override
  Future<ApiResponse<T>> request<T>({
    required HttpMethod method,
    required String endpoint,
    Map<String, Object?>? queryParameters,
    Map<String, String>? headers,
    Object? body,
  }) async {
    try {
      final response = await _dio.request<dynamic>(
        endpoint,
        data: body,
        queryParameters: queryParameters,
        options: Options(
          method: method.verb,
          headers: headers,
        ),
      );

      final statusCode = response.statusCode ?? 0;
      if (statusCode < 200 || statusCode >= 300) {
        throw ApiHttpException(
          statusCode: statusCode,
          message: 'HTTP $statusCode',
          data: response.data,
        );
      }

      return ApiResponse<T>(
        statusCode: statusCode,
        data: response.data as T,
        headers: Map<String, List<String>>.from(response.headers.map),
      );
    } on ApiException {
      rethrow;
    } on DioException catch (error) {
      throw _mapDioException(error);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        ApiUnknownException(message: error.toString(), cause: error),
        stackTrace,
      );
    }
  }

  @override
  Future<T> get<T>({
    required String endpoint,
    Map<String, Object?> queryParameters = const {},
    Map<String, String> headers = const {},
  }) async {
    final response = await request<T>(
      method: HttpMethod.get,
      endpoint: endpoint,
      queryParameters: queryParameters,
      headers: headers,
    );
    return response.data;
  }

  @override
  Future<T> post<T>({
    required String endpoint,
    Object? body,
    Map<String, String> headers = const {},
  }) async {
    final response = await request<T>(
      method: HttpMethod.post,
      endpoint: endpoint,
      headers: headers,
      body: body,
    );
    return response.data;
  }

  @override
  Future<T> rpc<T>(
    String name, {
    Object? params,
    Map<String, String> headers = const {},
  }) {
    return post<T>(
      endpoint: 'rpc/$name',
      body: params ?? const <String, Object?>{},
      headers: headers,
    );
  }
}

ApiException _mapDioException(DioException error) {
  return switch (error.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.transformTimeout =>
      ApiTimeoutException(message: error.message, cause: error),
    DioExceptionType.connectionError ||
    DioExceptionType.badCertificate =>
      ApiNetworkException(message: error.message, cause: error),
    DioExceptionType.cancel =>
      ApiCancelledException(message: error.message, cause: error),
    DioExceptionType.badResponse => ApiHttpException(
        statusCode: error.response?.statusCode ?? 0,
        message: error.message ?? 'HTTP ${error.response?.statusCode}',
        data: error.response?.data,
        cause: error,
      ),
    DioExceptionType.unknown =>
      ApiUnknownException(message: error.message, cause: error),
  };
}
