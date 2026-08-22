import 'package:lume/layers/domain/models/game/game_trail_domain.dart';
import 'package:lume/layers/domain/models/trail/trail_progress_domain.dart';

/// Derives trail / submodule completion from pair progress rows.
abstract final class TrailProgressCalculator {
  const TrailProgressCalculator._();

  static Set<int> completedPairIds(List<PairProgressDomain> pairProgress) {
    return {
      for (final row in pairProgress)
        if (row.completed) row.pairId,
    };
  }

  static bool isSubmoduleCompleted({
    required GameTrailSubmoduleDomain submodule,
    required Set<int> completedPairs,
  }) {
    if (submodule.games.isEmpty) return false;
    return submodule.games.every((game) => completedPairs.contains(game.pairId));
  }

  static int completedSubmoduleCount({
    required GameTrailDomain trail,
    required Set<int> completedPairs,
  }) {
    var count = 0;
    for (final level in trail.levels) {
      for (final submodule in level.submodules) {
        if (isSubmoduleCompleted(
          submodule: submodule,
          completedPairs: completedPairs,
        )) {
          count++;
        }
      }
    }
    return count;
  }

  static int totalSubmoduleCount(GameTrailDomain trail) {
    var count = 0;
    for (final level in trail.levels) {
      count += level.submodules.length;
    }
    return count;
  }

  static int progressPercent({
    required GameTrailDomain trail,
    required Set<int> completedPairs,
  }) {
    final total = totalSubmoduleCount(trail);
    if (total == 0) return 0;
    final done = completedSubmoduleCount(
      trail: trail,
      completedPairs: completedPairs,
    );
    return ((done / total) * 100).round();
  }
}
