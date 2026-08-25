/// Most games the user has ever scored in a single arcade run.
class ArcadeRecordDomain {
  const ArcadeRecordDomain({this.bestRounds = 0});

  final int bestRounds;

  @override
  bool operator ==(Object other) =>
      other is ArcadeRecordDomain && other.bestRounds == bestRounds;

  @override
  int get hashCode => bestRounds.hashCode;
}

/// Outcome of persisting one finished arcade round.
class ArcadeRoundResultDomain {
  const ArcadeRoundResultDomain({
    this.xpAwarded = 0,
    this.isRecordRound = false,
  });

  final int xpAwarded;

  /// True when this score went past the previous personal best, which is worth
  /// more XP than an ordinary round.
  final bool isRecordRound;

  @override
  bool operator ==(Object other) =>
      other is ArcadeRoundResultDomain &&
      other.xpAwarded == xpAwarded &&
      other.isRecordRound == isRecordRound;

  @override
  int get hashCode => Object.hash(xpAwarded, isRecordRound);
}

/// Outcome of closing an arcade session.
class ArcadeRecordResultDomain {
  const ArcadeRecordResultDomain({
    this.bestRounds = 0,
    this.previousBestRounds = 0,
    this.isNewRecord = false,
  });

  final int bestRounds;
  final int previousBestRounds;
  final bool isNewRecord;

  @override
  bool operator ==(Object other) =>
      other is ArcadeRecordResultDomain &&
      other.bestRounds == bestRounds &&
      other.previousBestRounds == previousBestRounds &&
      other.isNewRecord == isNewRecord;

  @override
  int get hashCode => Object.hash(bestRounds, previousBestRounds, isNewRecord);
}
