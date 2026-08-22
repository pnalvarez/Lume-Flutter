class LevelProgressDomain {
  const LevelProgressDomain({
    required this.levelId,
    this.completed = false,
    this.completedAt,
  });

  final int levelId;
  final bool completed;
  final DateTime? completedAt;
}

class PairProgressDomain {
  const PairProgressDomain({
    required this.pairId,
    this.previewSeen = false,
    this.scorePct = 0,
    this.completed = false,
    this.updatedAt,
  });

  final int pairId;
  final bool previewSeen;
  final int scorePct;
  final bool completed;
  final DateTime? updatedAt;
}

class TrailProgressDomain {
  const TrailProgressDomain({
    this.levelProgress = const [],
    this.pairProgress = const [],
  });

  final List<LevelProgressDomain> levelProgress;
  final List<PairProgressDomain> pairProgress;
}
