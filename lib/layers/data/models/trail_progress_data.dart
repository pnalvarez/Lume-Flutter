import 'package:json_annotation/json_annotation.dart';
import 'package:lume/layers/data/models/category_data.dart';
import 'package:lume/layers/data/models/trail_catalog_data.dart';

part 'trail_progress_data.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class LevelProgressData {
  const LevelProgressData({
    required this.levelId,
    this.quizScore,
    this.completed = false,
    this.completedAt,
  });

  final int levelId;
  final double? quizScore;

  @JsonKey(defaultValue: false)
  final bool completed;
  final DateTime? completedAt;

  factory LevelProgressData.fromJson(Map<String, dynamic> json) =>
      _$LevelProgressDataFromJson(json);

  Map<String, dynamic> toJson() => _$LevelProgressDataToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class PairProgressData {
  const PairProgressData({
    required this.pairId,
    this.previewSeen = false,
    this.scorePct = 0,
    this.completed = false,
    this.updatedAt,
  });

  final int pairId;

  @JsonKey(defaultValue: false)
  final bool previewSeen;

  @JsonKey(defaultValue: 0)
  final int scorePct;

  @JsonKey(defaultValue: false)
  final bool completed;
  final DateTime? updatedAt;

  factory PairProgressData.fromJson(Map<String, dynamic> json) =>
      _$PairProgressDataFromJson(json);

  Map<String, dynamic> toJson() => _$PairProgressDataToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class TrailProgressData {
  const TrailProgressData({
    this.levelProgress = const [],
    this.pairProgress = const [],
  });

  @JsonKey(defaultValue: <LevelProgressData>[])
  final List<LevelProgressData> levelProgress;

  @JsonKey(defaultValue: <PairProgressData>[])
  final List<PairProgressData> pairProgress;

  factory TrailProgressData.fromJson(Map<String, dynamic> json) =>
      _$TrailProgressDataFromJson(json);

  Map<String, dynamic> toJson() => _$TrailProgressDataToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class TrailBootstrapData {
  const TrailBootstrapData({
    this.trailStartedAt,
    this.modules = const [],
    this.categories = const [],
    this.levels = const [],
    this.submodules = const [],
    this.quizQuestions = const [],
    this.submodulePairs = const [],
    this.levelProgress = const [],
    this.pairProgress = const [],
  });

  final DateTime? trailStartedAt;

  @JsonKey(defaultValue: <ModuleData>[])
  final List<ModuleData> modules;

  @JsonKey(defaultValue: <CategoryData>[])
  final List<CategoryData> categories;

  @JsonKey(defaultValue: <LevelData>[])
  final List<LevelData> levels;

  @JsonKey(defaultValue: <SubmoduleData>[])
  final List<SubmoduleData> submodules;

  @JsonKey(defaultValue: <QuizQuestionData>[])
  final List<QuizQuestionData> quizQuestions;

  @JsonKey(defaultValue: <SubmodulePairData>[])
  final List<SubmodulePairData> submodulePairs;

  @JsonKey(defaultValue: <LevelProgressData>[])
  final List<LevelProgressData> levelProgress;

  @JsonKey(defaultValue: <PairProgressData>[])
  final List<PairProgressData> pairProgress;

  factory TrailBootstrapData.fromJson(Map<String, dynamic> json) =>
      _$TrailBootstrapDataFromJson(json);

  Map<String, dynamic> toJson() => _$TrailBootstrapDataToJson(this);
}
