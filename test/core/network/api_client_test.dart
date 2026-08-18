import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/core/errors/api_exception.dart';
import 'package:lume/core/network/api_client.dart';
import 'package:lume/core/network/http_method.dart';
import 'package:lume/core/network/interceptors/auth_interceptor.dart';
import 'package:lume/core/network/interceptors/supabase_headers_interceptor.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/mocks.mocks.dart';
import '../../helpers/stub_http_adapter.dart';

void main() {
  const baseUrl = 'https://example.com/rest/v1/';

  ApiClient clientWith(
    Future<ResponseBody> Function(
      RequestOptions options,
      Stream<List<int>>? requestStream,
    ) onFetch, {
    List<Interceptor> interceptors = const [],
  }) {
    final dio = Dio(BaseOptions(baseUrl: baseUrl));
    dio.interceptors.addAll(interceptors);
    dio.httpClientAdapter = StubHttpAdapter(onFetch);
    return ApiClient(dio: dio);
  }

  group('ApiClient', () {
    test('get returns decoded JSON on success', () async {
      final client = clientWith((options, _) async {
        expect(options.method, 'GET');
        expect(options.path, 'modulos');
        expect(options.queryParameters['select'], '*');
        expect(options.headers['Prefer'], 'return=representation');
        return jsonResponse(jsonEncode([
          {'id': 1, 'nome': 'História'},
        ]));
      });

      final data = await client.get<List<dynamic>>(
        endpoint: 'modulos',
        queryParameters: const {'select': '*'},
        headers: const {'Prefer': 'return=representation'},
      );

      expect(data, isA<List<dynamic>>());
      expect(data.first['nome'], 'História');
    });

    test('rpc posts to rpc/{name} and returns the decoded body', () async {
      final client = clientWith((options, _) async {
        expect(options.method, 'POST');
        expect(options.path, 'rpc/get_trail_bootstrap');
        expect(options.data, <String, Object?>{});
        return jsonResponse(jsonEncode({'modulos': []}));
      });

      final data = await client.rpc<Map<String, dynamic>>('get_trail_bootstrap');

      expect(data['modulos'], isEmpty);
    });

    test('rpc forwards params in the JSON body', () async {
      final client = clientWith((options, _) async {
        expect(options.path, 'rpc/save_pair_progress');
        expect(options.data, {'p_par_id': 12, 'p_score_pct': 80});
        return jsonResponse(jsonEncode({'concluido': true}));
      });

      final data = await client.rpc<Map<String, dynamic>>(
        'save_pair_progress',
        params: const {'p_par_id': 12, 'p_score_pct': 80},
      );

      expect(data['concluido'], isTrue);
    });

    test('put, patch and delete use the matching HTTP verb', () async {
      final verbs = <HttpMethod, String>{
        HttpMethod.put: 'PUT',
        HttpMethod.patch: 'PATCH',
        HttpMethod.delete: 'DELETE',
      };

      for (final entry in verbs.entries) {
        final client = clientWith((options, _) async {
          expect(options.method, entry.value);
          return jsonResponse('{}', statusCode: 204);
        });

        final response = await client.request<dynamic>(
          method: entry.key,
          endpoint: 'progresso_par',
          body: const {'par_id': 1},
        );
        expect(response.statusCode, 204);
      }
    });

    test('throws ApiHttpException on non-2xx status', () async {
      final client = clientWith(
        (_, _) async => jsonResponse('{"message":"boom"}', statusCode: 500),
      );

      expect(
        () => client.get<dynamic>(endpoint: 'modulos'),
        throwsA(
          isA<ApiHttpException>()
              .having((e) => e.statusCode, 'statusCode', 500)
              .having((e) => e.data, 'data', {'message': 'boom'}),
        ),
      );
    });

    test('maps receive timeout to ApiTimeoutException', () async {
      final client = clientWith((options, _) async {
        throw DioException(
          requestOptions: options,
          type: DioExceptionType.receiveTimeout,
          message: 'timeout',
        );
      });

      expect(
        () => client.get<dynamic>(endpoint: 'modulos'),
        throwsA(isA<ApiTimeoutException>()),
      );
    });

    test('maps connection errors to ApiNetworkException', () async {
      final client = clientWith((options, _) async {
        throw DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          message: 'Failed host lookup',
        );
      });

      expect(
        () => client.get<dynamic>(endpoint: 'modulos'),
        throwsA(isA<ApiNetworkException>()),
      );
    });

    test('maps cancellation to ApiCancelledException', () async {
      final client = clientWith((options, _) async {
        throw DioException(
          requestOptions: options,
          type: DioExceptionType.cancel,
          message: 'cancelled',
        );
      });

      expect(
        () => client.get<dynamic>(endpoint: 'modulos'),
        throwsA(isA<ApiCancelledException>()),
      );
    });

    test('maps unknown Dio failures to ApiUnknownException', () async {
      final client = clientWith((options, _) async {
        throw DioException(
          requestOptions: options,
          type: DioExceptionType.unknown,
          message: 'unexpected',
        );
      });

      expect(
        () => client.get<dynamic>(endpoint: 'modulos'),
        throwsA(isA<ApiUnknownException>()),
      );
    });

    test('create wires a usable client', () {
      final tokens = MockIAuthTokenProvider();
      when(tokens.accessToken).thenReturn(null);

      expect(
        ApiClient.create(
          baseUrl: baseUrl,
          apiKey: 'anon-key',
          tokenProvider: tokens,
          enableLogging: false,
        ),
        isA<ApiClient>(),
      );
    });
  });

  group('AuthInterceptor', () {
    test('attaches Bearer token from IAuthTokenProvider', () async {
      final tokens = MockIAuthTokenProvider();
      when(tokens.accessToken).thenReturn('jwt-123');

      final client = clientWith(
        (options, _) async {
          expect(options.headers['Authorization'], 'Bearer jwt-123');
          return jsonResponse('[]');
        },
        interceptors: [AuthInterceptor(tokens)],
      );

      await client.get<dynamic>(endpoint: 'modulos');
      verify(tokens.accessToken).called(1);
    });

    test('skips Authorization when there is no session token', () async {
      final tokens = MockIAuthTokenProvider();
      when(tokens.accessToken).thenReturn(null);

      final client = clientWith(
        (options, _) async {
          expect(options.headers.containsKey('Authorization'), isFalse);
          return jsonResponse('[]');
        },
        interceptors: [AuthInterceptor(tokens)],
      );

      await client.get<dynamic>(endpoint: 'modulos');
    });

    test('does not overwrite an Authorization header already on the request',
        () async {
      final tokens = MockIAuthTokenProvider();
      when(tokens.accessToken).thenReturn('interceptor-token');

      final client = clientWith(
        (options, _) async {
          expect(options.headers['Authorization'], 'Bearer request-token');
          return jsonResponse('[]');
        },
        interceptors: [AuthInterceptor(tokens)],
      );

      await client.get<dynamic>(
        endpoint: 'modulos',
        headers: const {'Authorization': 'Bearer request-token'},
      );
    });
  });

  group('SupabaseHeadersInterceptor', () {
    test('attaches apikey when missing', () async {
      final client = clientWith(
        (options, _) async {
          expect(options.headers['apikey'], 'anon-key');
          return jsonResponse('[]');
        },
        interceptors: [SupabaseHeadersInterceptor(apiKey: 'anon-key')],
      );

      await client.get<dynamic>(endpoint: 'modulos');
    });

    test('does not overwrite an existing apikey', () async {
      final client = clientWith(
        (options, _) async {
          expect(options.headers['apikey'], 'override');
          return jsonResponse('[]');
        },
        interceptors: [SupabaseHeadersInterceptor(apiKey: 'anon-key')],
      );

      await client.get<dynamic>(
        endpoint: 'modulos',
        headers: const {'apikey': 'override'},
      );
    });
  });
}
