// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryData _$CategoryDataFromJson(Map<String, dynamic> json) =>
    CategoryData(id: (json['id'] as num).toInt(), name: json['name'] as String);

Map<String, dynamic> _$CategoryDataToJson(CategoryData instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

CategoryPreferencesData _$CategoryPreferencesDataFromJson(
  Map<String, dynamic> json,
) => CategoryPreferencesData(
  categories:
      (json['categories'] as List<dynamic>?)
          ?.map((e) => CategoryData.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  selectedIds:
      (json['selected_ids'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      [],
);

Map<String, dynamic> _$CategoryPreferencesDataToJson(
  CategoryPreferencesData instance,
) => <String, dynamic>{
  'categories': instance.categories.map((e) => e.toJson()).toList(),
  'selected_ids': instance.selectedIds,
};
