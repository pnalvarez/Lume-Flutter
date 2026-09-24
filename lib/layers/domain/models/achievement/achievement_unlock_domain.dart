/// Snapshot of an achievement the player just unlocked.
class AchievementUnlockDomain {
  const AchievementUnlockDomain({
    required this.achievementId,
    required this.code,
    required this.name,
    this.icon,
  });

  final String achievementId;
  final String code;
  final String name;
  final String? icon;

  @override
  bool operator ==(Object other) =>
      other is AchievementUnlockDomain &&
      other.achievementId == achievementId &&
      other.code == code &&
      other.name == name &&
      other.icon == icon;

  @override
  int get hashCode => Object.hash(achievementId, code, name, icon);
}
