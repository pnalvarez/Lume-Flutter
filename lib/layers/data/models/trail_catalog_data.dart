import 'package:json_annotation/json_annotation.dart';
import 'package:lume/layers/data/models/game_type.dart';

part 'trail_catalog_data.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ModuleData {
  const ModuleData({
    required this.id,
    required this.sortOrder,
    required this.title,
    required this.emoji,
    required this.color,
    this.categoryId,
    this.description,
  });

  final int id;
  final int sortOrder;
  final String title;
  final String emoji;
  final String color;
  final int? categoryId;
  final String? description;

  factory ModuleData.fromJson(Map<String, dynamic> json) =>
      _$ModuleDataFromJson(json);

  Map<String, dynamic> toJson() => _$ModuleDataToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class LevelData {
  const LevelData({
    required this.id,
    required this.moduleId,
    required this.sortOrder,
    required this.title,
  });

  final int id;
  final int moduleId;
  final int sortOrder;
  final String title;

  factory LevelData.fromJson(Map<String, dynamic> json) =>
      _$LevelDataFromJson(json);

  Map<String, dynamic> toJson() => _$LevelDataToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class SubmoduleData {
  const SubmoduleData({
    required this.id,
    required this.moduleId,
    required this.sortOrder,
    required this.title,
    this.levelId,
    this.unlockDaysFromStart = 0,
    this.imageUrl,
  });

  final int id;
  final int moduleId;
  final int? levelId;
  final int sortOrder;
  final String title;

  @JsonKey(defaultValue: 0)
  final int unlockDaysFromStart;
  final String? imageUrl;

  factory SubmoduleData.fromJson(Map<String, dynamic> json) =>
      _$SubmoduleDataFromJson(json);

  Map<String, dynamic> toJson() => _$SubmoduleDataToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class QuizQuestionData {
  const QuizQuestionData({
    required this.id,
    required this.sortOrder,
    required this.prompt,
    this.levelId,
    this.options = const [],
    this.imageUrl,
  });

  final int id;
  final int? levelId;
  final int sortOrder;
  final String prompt;

  @JsonKey(defaultValue: <String>[])
  final List<String> options;
  final String? imageUrl;

  factory QuizQuestionData.fromJson(Map<String, dynamic> json) =>
      _$QuizQuestionDataFromJson(json);

  Map<String, dynamic> toJson() => _$QuizQuestionDataToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class SubmodulePairData {
  const SubmodulePairData({
    required this.id,
    required this.submoduleId,
    required this.sortOrder,
    required this.previewHook,
    required this.gameType,
    required this.contentType,
    required this.cognitiveDemand,
    this.conceptId,
    this.createdAt,
  });

  final int id;
  final int submoduleId;
  final int sortOrder;
  final String previewHook;

  @JsonKey(name: 'game_format')
  @GameTypeConverter()
  final GameType gameType;
  final String contentType;
  final String cognitiveDemand;
  final int? conceptId;
  final DateTime? createdAt;

  factory SubmodulePairData.fromJson(Map<String, dynamic> json) =>
      _$SubmodulePairDataFromJson(json);

  Map<String, dynamic> toJson() => _$SubmodulePairDataToJson(this);
}
