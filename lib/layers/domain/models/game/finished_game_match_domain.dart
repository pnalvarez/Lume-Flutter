/// Outcome of closing a catalog match via `finish_game_match`.
class FinishedGameMatchDomain {
  const FinishedGameMatchDomain({this.xpEarned = 0});

  final int xpEarned;
}
