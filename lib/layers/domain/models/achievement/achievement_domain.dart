/// One achievement from the catalog, with the signed-in user's progress.
class AchievementDomain {
  const AchievementDomain({
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
  final int progress;
  final DateTime? completedAt;
  final DateTime? rewardClaimedAt;

  bool get isCompleted => completedAt != null;
}
