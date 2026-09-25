import 'package:json_annotation/json_annotation.dart';
import 'package:lume/layers/data/nullable_date_time_converter.dart';

part 'achievement_data.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AchievementData {
  const AchievementData({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    this.icon,
    required this.conditionType,
    required this.conditionTarget,
    required this.rewardType,
    required this.rewardAmount,
    this.progress = 0,
    this.completedAt,
    this.rewardClaimedAt,
  });

  final String id;
  final String code;
  final String name;
  final String description;
  final String? icon;
  final String conditionType;
  final int conditionTarget;
  final String rewardType;
  final int rewardAmount;

  @JsonKey(defaultValue: 0)
  final int progress;

  @NullableDateTimeConverter()
  final DateTime? completedAt;

  @NullableDateTimeConverter()
  final DateTime? rewardClaimedAt;

  factory AchievementData.fromJson(Map<String, dynamic> json) =>
      _$AchievementDataFromJson(json);

  Map<String, dynamic> toJson() => _$AchievementDataToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class AchievementsResponseData {
  const AchievementsResponseData({this.achievements = const []});

  @JsonKey(defaultValue: <AchievementData>[])
  final List<AchievementData> achievements;

  factory AchievementsResponseData.fromJson(Map<String, dynamic> json) =>
      _$AchievementsResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$AchievementsResponseDataToJson(this);
}
