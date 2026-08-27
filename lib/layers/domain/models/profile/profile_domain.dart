/// Signed-in user profile.
class ProfileDomain {
  const ProfileDomain({
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
  final int playerLevel;
  final int totalXp;
  final int xpToNextLevel;
  final int xpInLevel;
  final int xpForNextLevel;
  final int currentStreak;
  final int bestStreak;
  final int streakShields;
  final int xpToday;
  final int xpWeek;
  final int daysInApp;
  final int submodulesCompleted;
}
