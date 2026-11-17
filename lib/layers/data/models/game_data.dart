import 'package:json_annotation/json_annotation.dart';
import 'package:lume/layers/data/json_object_converter.dart';
import 'package:lume/layers/data/models/game_type.dart';

part 'game_data.g.dart';

/// Three-slide split of a submodule preview (`preview_slides`).
@JsonSerializable(fieldRename: FieldRename.snake)
class PreviewSlidesData {
  const PreviewSlidesData({
    this.introduction = '',
    this.elaboration = '',
    this.conclusion = '',
  });

  @JsonKey(defaultValue: '')
  final String introduction;

  @JsonKey(defaultValue: '')
  final String elaboration;

  @JsonKey(defaultValue: '')
  final String conclusion;

  factory PreviewSlidesData.fromJson(Map<String, dynamic> json) =>
      _$PreviewSlidesDataFromJson(json);

  Map<String, dynamic> toJson() => _$PreviewSlidesDataToJson(this);
}

/// Tolerates a missing / null `preview_slides` (older backend, cached payloads).
PreviewSlidesData _previewSlidesFromJson(Object? json) {
  if (json is Map) {
    return PreviewSlidesData.fromJson(Map<String, dynamic>.from(json));
  }
  return const PreviewSlidesData();
}

@JsonSerializable(fieldRename: FieldRename.snake)
class GameItemData {
  const GameItemData({
    required this.pairId,
    required this.sortOrder,
    required this.gameType,
    this.conceptId,
    this.gamePayload,
  });

  final int pairId;
  final int sortOrder;

  @JsonKey(name: 'game_format')
  @GameTypeConverter()
  final GameType gameType;
  final int? conceptId;

  @JsonKey(name: 'game_payload')
  @JsonObjectConverter()
  final Map<String, dynamic>? gamePayload;

  factory GameItemData.fromJson(Map<String, dynamic> json) =>
      _$GameItemDataFromJson(json);

  Map<String, dynamic> toJson() => _$GameItemDataToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class GameTrailSubmoduleData {
  const GameTrailSubmoduleData({
    required this.id,
    required this.title,
    required this.sortOrder,
    this.imageUrl,
    this.preview = '',
    this.previewSlides = const PreviewSlidesData(),
    this.games = const [],
  });

  final int id;
  final String title;
  final int sortOrder;
  final String? imageUrl;

  @JsonKey(defaultValue: '')
  final String preview;

  @JsonKey(fromJson: _previewSlidesFromJson)
  final PreviewSlidesData previewSlides;

  @JsonKey(defaultValue: <GameItemData>[])
  final List<GameItemData> games;

  factory GameTrailSubmoduleData.fromJson(Map<String, dynamic> json) =>
      _$GameTrailSubmoduleDataFromJson(json);

  Map<String, dynamic> toJson() => _$GameTrailSubmoduleDataToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class GameTrailLevelData {
  const GameTrailLevelData({
    required this.id,
    required this.title,
    required this.sortOrder,
    this.submodules = const [],
  });

  final int id;
  final String title;
  final int sortOrder;

  @JsonKey(defaultValue: <GameTrailSubmoduleData>[])
  final List<GameTrailSubmoduleData> submodules;

  factory GameTrailLevelData.fromJson(Map<String, dynamic> json) =>
      _$GameTrailLevelDataFromJson(json);

  Map<String, dynamic> toJson() => _$GameTrailLevelDataToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class GameTrailData {
  const GameTrailData({
    required this.id,
    required this.title,
    required this.sortOrder,
    this.emoji,
    this.levels = const [],
  });

  final int id;
  final String title;
  final String? emoji;
  final int sortOrder;

  @JsonKey(defaultValue: <GameTrailLevelData>[])
  final List<GameTrailLevelData> levels;

  factory GameTrailData.fromJson(Map<String, dynamic> json) =>
      _$GameTrailDataFromJson(json);

  Map<String, dynamic> toJson() => _$GameTrailDataToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class SubmoduleGamesData {
  const SubmoduleGamesData({
    required this.id,
    required this.title,
    required this.sortOrder,
    this.imageUrl,
    this.levelId,
    this.moduleId,
    this.preview = '',
    this.previewSlides = const PreviewSlidesData(),
    this.games = const [],
  });

  final int id;
  final String title;
  final int sortOrder;
  final String? imageUrl;
  final int? levelId;
  final int? moduleId;

  @JsonKey(defaultValue: '')
  final String preview;

  @JsonKey(fromJson: _previewSlidesFromJson)
  final PreviewSlidesData previewSlides;

  @JsonKey(defaultValue: <GameItemData>[])
  final List<GameItemData> games;

  factory SubmoduleGamesData.fromJson(Map<String, dynamic> json) =>
      _$SubmoduleGamesDataFromJson(json);

  Map<String, dynamic> toJson() => _$SubmoduleGamesDataToJson(this);
}
