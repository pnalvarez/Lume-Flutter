class LevelUpData {
  const LevelUpData({
    required this.level,
    required this.totalXp,
    required this.xpLevelOffset,
    required this.xpNextLevelAt,
  });

  final int level;
  final int totalXp;
  final int xpLevelOffset;
  final int xpNextLevelAt;

  factory LevelUpData.fromJson(Map<String, dynamic> json) {
    return LevelUpData(
      level: (json['level'] as num).toInt(),
      totalXp: (json['total_xp'] as num?)?.toInt() ?? 0,
      xpLevelOffset: (json['xp_level_offset'] as num?)?.toInt() ?? 0,
      xpNextLevelAt: (json['xp_next_level_at'] as num?)?.toInt() ?? 0,
    );
  }
}
