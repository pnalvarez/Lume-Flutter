import 'package:json_annotation/json_annotation.dart';

part 'category_data.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CategoryData {
  const CategoryData({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory CategoryData.fromJson(Map<String, dynamic> json) =>
      _$CategoryDataFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryDataToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CategoryPreferencesData {
  const CategoryPreferencesData({
    this.categories = const [],
    this.selectedIds = const [],
  });

  @JsonKey(defaultValue: <CategoryData>[])
  final List<CategoryData> categories;

  @JsonKey(defaultValue: <int>[])
  final List<int> selectedIds;

  factory CategoryPreferencesData.fromJson(Map<String, dynamic> json) =>
      _$CategoryPreferencesDataFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryPreferencesDataToJson(this);
}
