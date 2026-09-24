class AchievementUnlockData {
  const AchievementUnlockData({
    required this.achievementId,
    required this.code,
    required this.name,
    this.icon,
  });

  final String achievementId;
  final String code;
  final String name;
  final String? icon;

  factory AchievementUnlockData.fromJson(Map<String, dynamic> json) {
    return AchievementUnlockData(
      achievementId: json['achievement_id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String?,
    );
  }
}
