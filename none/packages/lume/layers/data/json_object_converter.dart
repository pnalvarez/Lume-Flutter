import 'package:json_annotation/json_annotation.dart';
import 'package:lume/layers/data/json_map.dart';

class JsonObjectConverter
    implements JsonConverter<Map<String, dynamic>?, Object?> {
  const JsonObjectConverter();

  @override
  Map<String, dynamic>? fromJson(Object? json) => asNullableJsonMap(json);

  @override
  Object? toJson(Map<String, dynamic>? object) => object;
}
