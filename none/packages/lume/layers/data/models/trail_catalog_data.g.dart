// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trail_catalog_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModuleData _$ModuleDataFromJson(Map<String, dynamic> json) => ModuleData(
  id: (json['id'] as num).toInt(),
  sortOrder: (json['sort_order'] as num).toInt(),
  title: json['title'] as String,
  emoji: json['emoji'] as String,
  color: json['color'] as String,
  categoryId: (json['category_id'] as num?)?.toInt(),
  description: json['description'] as String?,
);

Map<String, dynamic> _$ModuleDataToJson(ModuleData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sort_order': instance.sortOrder,
      'title': instance.title,
      'emoji': instance.emoji,
      'color': instance.color,
      'category_id': instance.categoryId,
      'description': instance.description,
    };

LevelData _$LevelDataFromJson(Map<String, dynamic> json) => LevelData(
  id: (json['id'] as num).toInt(),
  moduleId: (json['module_id'] as num).toInt(),
  sortOrder: (json['sort_order'] as num).toInt(),
  title: json['title'] as String,
);

Map<String, dynamic> _$LevelDataToJson(LevelData instance) => <String, dynamic>{
  'id': instance.id,
  'module_id': instance.moduleId,
  'sort_order': instance.sortOrder,
  'title': instance.title,
};

SubmoduleData _$SubmoduleDataFromJson(Map<String, dynamic> json) =>
    SubmoduleData(
      id: (json['id'] as num).toInt(),
      moduleId: (json['module_id'] as num).toInt(),
      sortOrder: (json['sort_order'] as num).toInt(),
      title: json['title'] as String,
      levelId: (json['level_id'] as num?)?.toInt(),
      unlockDaysFromStart:
          (json['unlock_days_from_start'] as num?)?.toInt() ?? 0,
      imageUrl: json['image_url'] as String?,
    );

Map<String, dynamic> _$SubmoduleDataToJson(SubmoduleData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'module_id': instance.moduleId,
      'level_id': instance.levelId,
      'sort_order': instance.sortOrder,
      'title': instance.title,
      'unlock_days_from_start': instance.unlockDaysFromStart,
      'image_url': instance.imageUrl,
    };

SubmodulePairData _$SubmodulePairDataFromJson(Map<String, dynamic> json) =>
    SubmodulePairData(
      id: (json['id'] as num).toInt(),
      submoduleId: (json['submodule_id'] as num).toInt(),
      sortOrder: (json['sort_order'] as num).toInt(),
      previewHook: json['preview_hook'] as String,
      gameType: const GameTypeConverter().fromJson(
        json['game_format'] as String,
      ),
      contentType: json['content_type'] as String,
      cognitiveDemand: json['cognitive_demand'] as String,
      conceptId: (json['concept_id'] as num?)?.toInt(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$SubmodulePairDataToJson(SubmodulePairData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'submodule_id': instance.submoduleId,
      'sort_order': instance.sortOrder,
      'preview_hook': instance.previewHook,
      'game_format': const GameTypeConverter().toJson(instance.gameType),
      'content_type': instance.contentType,
      'cognitive_demand': instance.cognitiveDemand,
      'concept_id': instance.conceptId,
      'created_at': instance.createdAt?.toIso8601String(),
    };
