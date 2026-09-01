/// Snapshot of the player's level after an XP award that crossed a threshold.
class LevelUpDomain {
  const LevelUpDomain({
    required this.level,
    required this.xpOffset,
    required this.currentXp,
    required this.xpForNextLevel,
  });

  /// Newly reached player level.
  final int level;

  /// Cumulative XP at which [level] starts.
  final int xpOffset;

  /// Total XP after the award.
  final int currentXp;

  /// Cumulative XP required to reach the next level.
  final int xpForNextLevel;

  /// Progress within the new level: `(currentXp - xpOffset) / (xpForNextLevel - xpOffset)`.
  double get progress {
    final span = xpForNextLevel - xpOffset;
    if (span <= 0) return 1.0;
    return ((currentXp - xpOffset) / span).clamp(0.0, 1.0);
  }

  @override
  bool operator ==(Object other) =>
      other is LevelUpDomain &&
      other.level == level &&
      other.xpOffset == xpOffset &&
      other.currentXp == currentXp &&
      other.xpForNextLevel == xpForNextLevel;

  @override
  int get hashCode => Object.hash(level, xpOffset, currentXp, xpForNextLevel);
}
