/// JSON payload returned by `finish_game_match`.
final class FinishedGameMatchData {
  const FinishedGameMatchData({this.xpEarned = 0});

  factory FinishedGameMatchData.fromJson(Map<String, dynamic> json) {
    return FinishedGameMatchData(
      xpEarned: (json['xp_earned'] as num?)?.toInt() ?? 0,
    );
  }

  final int xpEarned;
}
