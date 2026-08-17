import 'package:dio/dio.dart';

/// Fake [HttpClientAdapter] that records the request and returns a canned body.
final class StubHttpAdapter implements HttpClientAdapter {
  StubHttpAdapter(this.onFetch);

  final Future<ResponseBody> Function(
    RequestOptions options,
    Stream<List<int>>? requestStream,
  ) onFetch;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) {
    return onFetch(options, requestStream);
  }
}

ResponseBody jsonResponse(String body, {int statusCode = 200}) {
  return ResponseBody.fromString(
    body,
    statusCode,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );
}
