// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameItemData _$GameItemDataFromJson(Map<String, dynamic> json) => GameItemData(
  pairId: (json['pair_id'] as num).toInt(),
  sortOrder: (json['sort_order'] as num).toInt(),
  gameType: const GameTypeConverter().fromJson(json['game_format'] as String),
  conceptId: (json['concept_id'] as num?)?.toInt(),
  gamePayload: const JsonObjectConverter().fromJson(json['game_payload']),
);

Map<String, dynamic> _$GameItemDataToJson(GameItemData instance) =>
    <String, dynamic>{
      'pair_id': instance.pairId,
      'sort_order': instance.sortOrder,
      'game_format': const GameTypeConverter().toJson(instance.gameType),
      'concept_id': instance.conceptId,
      'game_payload': const JsonObjectConverter().toJson(instance.gamePayload),
    };

GameTrailSubmoduleData _$GameTrailSubmoduleDataFromJson(
  Map<String, dynamic> json,
) => GameTrailSubmoduleData(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  sortOrder: (json['sort_order'] as num).toInt(),
  imageUrl: json['image_url'] as String?,
  preview: json['preview'] as String? ?? '',
  games:
      (json['games'] as List<dynamic>?)
          ?.map((e) => GameItemData.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$GameTrailSubmoduleDataToJson(
  GameTrailSubmoduleData instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'sort_order': instance.sortOrder,
  'image_url': instance.imageUrl,
  'preview': instance.preview,
  'games': instance.games.map((e) => e.toJson()).toList(),
};

GameTrailLevelData _$GameTrailLevelDataFromJson(Map<String, dynamic> json) =>
    GameTrailLevelData(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      sortOrder: (json['sort_order'] as num).toInt(),
      submodules:
          (json['submodules'] as List<dynamic>?)
              ?.map(
                (e) =>
                    GameTrailSubmoduleData.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );

Map<String, dynamic> _$GameTrailLevelDataToJson(GameTrailLevelData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'sort_order': instance.sortOrder,
      'submodules': instance.submodules.map((e) => e.toJson()).toList(),
    };

GameTrailData _$GameTrailDataFromJson(Map<String, dynamic> json) =>
    GameTrailData(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      sortOrder: (json['sort_order'] as num).toInt(),
      emoji: json['emoji'] as String?,
      levels:
          (json['levels'] as List<dynamic>?)
              ?.map(
                (e) => GameTrailLevelData.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );

Map<String, dynamic> _$GameTrailDataToJson(GameTrailData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'emoji': instance.emoji,
      'sort_order': instance.sortOrder,
      'levels': instance.levels.map((e) => e.toJson()).toList(),
    };

SubmoduleGamesData _$SubmoduleGamesDataFromJson(Map<String, dynamic> json) =>
    SubmoduleGamesData(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      sortOrder: (json['sort_order'] as num).toInt(),
      imageUrl: json['image_url'] as String?,
      levelId: (json['level_id'] as num?)?.toInt(),
      moduleId: (json['module_id'] as num?)?.toInt(),
      preview: json['preview'] as String? ?? '',
      games:
          (json['games'] as List<dynamic>?)
              ?.map((e) => GameItemData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$SubmoduleGamesDataToJson(SubmoduleGamesData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'sort_order': instance.sortOrder,
      'image_url': instance.imageUrl,
      'level_id': instance.levelId,
      'module_id': instance.moduleId,
      'preview': instance.preview,
      'games': instance.games.map((e) => e.toJson()).toList(),
    };
