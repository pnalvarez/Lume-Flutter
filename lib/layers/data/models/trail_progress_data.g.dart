// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trail_progress_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LevelProgressData _$LevelProgressDataFromJson(Map<String, dynamic> json) =>
    LevelProgressData(
      levelId: (json['level_id'] as num).toInt(),
      quizScore: (json['quiz_score'] as num?)?.toDouble(),
      completed: json['completed'] as bool? ?? false,
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'] as String),
    );

Map<String, dynamic> _$LevelProgressDataToJson(LevelProgressData instance) =>
    <String, dynamic>{
      'level_id': instance.levelId,
      'quiz_score': instance.quizScore,
      'completed': instance.completed,
      'completed_at': instance.completedAt?.toIso8601String(),
    };

PairProgressData _$PairProgressDataFromJson(Map<String, dynamic> json) =>
    PairProgressData(
      pairId: (json['pair_id'] as num).toInt(),
      previewSeen: json['preview_seen'] as bool? ?? false,
      scorePct: (json['score_pct'] as num?)?.toInt() ?? 0,
      completed: json['completed'] as bool? ?? false,
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$PairProgressDataToJson(PairProgressData instance) =>
    <String, dynamic>{
      'pair_id': instance.pairId,
      'preview_seen': instance.previewSeen,
      'score_pct': instance.scorePct,
      'completed': instance.completed,
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

TrailProgressData _$TrailProgressDataFromJson(Map<String, dynamic> json) =>
    TrailProgressData(
      levelProgress:
          (json['level_progress'] as List<dynamic>?)
              ?.map(
                (e) => LevelProgressData.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      pairProgress:
          (json['pair_progress'] as List<dynamic>?)
              ?.map((e) => PairProgressData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$TrailProgressDataToJson(TrailProgressData instance) =>
    <String, dynamic>{
      'level_progress': instance.levelProgress.map((e) => e.toJson()).toList(),
      'pair_progress': instance.pairProgress.map((e) => e.toJson()).toList(),
    };

TrailBootstrapData _$TrailBootstrapDataFromJson(
  Map<String, dynamic> json,
) => TrailBootstrapData(
  trailStartedAt: json['trail_started_at'] == null
      ? null
      : DateTime.parse(json['trail_started_at'] as String),
  modules:
      (json['modules'] as List<dynamic>?)
          ?.map((e) => ModuleData.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  categories:
      (json['categories'] as List<dynamic>?)
          ?.map((e) => CategoryData.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  levels:
      (json['levels'] as List<dynamic>?)
          ?.map((e) => LevelData.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  submodules:
      (json['submodules'] as List<dynamic>?)
          ?.map((e) => SubmoduleData.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  quizQuestions:
      (json['quiz_questions'] as List<dynamic>?)
          ?.map((e) => QuizQuestionData.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  submodulePairs:
      (json['submodule_pairs'] as List<dynamic>?)
          ?.map((e) => SubmodulePairData.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  levelProgress:
      (json['level_progress'] as List<dynamic>?)
          ?.map((e) => LevelProgressData.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  pairProgress:
      (json['pair_progress'] as List<dynamic>?)
          ?.map((e) => PairProgressData.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$TrailBootstrapDataToJson(
  TrailBootstrapData instance,
) => <String, dynamic>{
  'trail_started_at': instance.trailStartedAt?.toIso8601String(),
  'modules': instance.modules.map((e) => e.toJson()).toList(),
  'categories': instance.categories.map((e) => e.toJson()).toList(),
  'levels': instance.levels.map((e) => e.toJson()).toList(),
  'submodules': instance.submodules.map((e) => e.toJson()).toList(),
  'quiz_questions': instance.quizQuestions.map((e) => e.toJson()).toList(),
  'submodule_pairs': instance.submodulePairs.map((e) => e.toJson()).toList(),
  'level_progress': instance.levelProgress.map((e) => e.toJson()).toList(),
  'pair_progress': instance.pairProgress.map((e) => e.toJson()).toList(),
};
