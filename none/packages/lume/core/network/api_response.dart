/// Raw HTTP response. [data] is decoded JSON (or `null` for empty bodies).
final class ApiResponse<T> {
  const ApiResponse({
    required this.statusCode,
    required this.data,
    this.headers = const {},
  });

  final int statusCode;
  final T data;
  final Map<String, List<String>> headers;

  bool get isSuccess => statusCode >= 200 && statusCode < 300;
}
