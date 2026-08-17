Map<String, dynamic> asJsonMap(Object? value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) {
    return {
      for (final entry in value.entries) entry.key.toString(): entry.value,
    };
  }
  throw FormatException('Expected a JSON object, got ${value.runtimeType}');
}

Map<String, dynamic>? asNullableJsonMap(Object? value) {
  if (value == null) return null;
  return asJsonMap(value);
}

List<T> parseJsonList<T>(
  Object? value,
  T Function(Map<String, dynamic> json) fromJson,
) {
  if (value == null) return const [];
  if (value is! List) {
    throw FormatException('Expected a JSON array, got ${value.runtimeType}');
  }
  return [for (final item in value) fromJson(asJsonMap(item))];
}
