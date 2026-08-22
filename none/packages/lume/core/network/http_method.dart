/// HTTP verbs supported by [IApiClient].
enum HttpMethod {
  get,
  post,
  put,
  patch,
  delete;

  /// Wire value, e.g. `GET`.
  String get verb => name.toUpperCase();
}
