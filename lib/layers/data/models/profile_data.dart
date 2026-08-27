import 'package:json_annotation/json_annotation.dart';

part 'profile_data.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ProfileData {
  const ProfileData({
    required this.id,
    this.email,
    this.fullName,
    this.trailStartedAt,
    this.playerLevel = 1,
    this.totalXp = 0,
    this.xpToNextLevel = 0,
    this.xpInLevel = 0,
    this.xpForNextLevel = 0,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.streakShields = 0,
    this.xpToday = 0,
    this.xpWeek = 0,
    this.daysInApp = 0,
    this.submodulesCompleted = 0,
  });

  final String id;
  final String? email;
  final String? fullName;
  final DateTime? trailStartedAt;

  @JsonKey(defaultValue: 1)
  final int playerLevel;

  @JsonKey(defaultValue: 0)
  final int totalXp;

  @JsonKey(defaultValue: 0)
  final int xpToNextLevel;

  @JsonKey(defaultValue: 0)
  final int xpInLevel;

  @JsonKey(defaultValue: 0)
  final int xpForNextLevel;

  @JsonKey(defaultValue: 0)
  final int currentStreak;

  @JsonKey(defaultValue: 0)
  final int bestStreak;

  @JsonKey(defaultValue: 0)
  final int streakShields;

  @JsonKey(defaultValue: 0)
  final int xpToday;

  @JsonKey(defaultValue: 0)
  final int xpWeek;

  @JsonKey(defaultValue: 0)
  final int daysInApp;

  @JsonKey(defaultValue: 0)
  final int submodulesCompleted;

  factory ProfileData.fromJson(Map<String, dynamic> json) =>
      _$ProfileDataFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileDataToJson(this);
}
