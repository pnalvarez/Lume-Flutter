import 'package:json_annotation/json_annotation.dart';

/// Parses ISO-8601 (or DateTime) values; null/empty/invalid → null (no throw).
class NullableDateTimeConverter implements JsonConverter<DateTime?, Object?> {
  const NullableDateTimeConverter();

  @override
  DateTime? fromJson(Object? json) {
    if (json == null) return null;
    if (json is DateTime) return json;
    if (json is! String) return null;
    final value = json.trim();
    if (value.isEmpty) return null;
    try {
      return DateTime.parse(value);
    } on FormatException {
      return null;
    }
  }

  @override
  Object? toJson(DateTime? object) => object?.toIso8601String();
}
