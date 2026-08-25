import 'package:lume/layers/domain/models/game/game_trail_domain.dart';
import 'package:lume/layers/domain/models/trail/trail_progress_domain.dart';

/// Derives trail / submodule completion from pair progress rows.
///
/// A submodule unlocks the next one when every game has been attempted and the
/// average [PairProgressDomain.scorePct] is at least [passAveragePercent].
abstract final class TrailProgressCalculator {
  const TrailProgressCalculator._();

  static const int passAveragePercent = 60;

  /// Minimum correct answers (binary 100/0) to reach [passAveragePercent].
  static int minCorrectCount(int totalGames) {
    if (totalGames <= 0) return 0;
    return ((totalGames * passAveragePercent) / 100).ceil();
  }

  static bool meetsPassAverage({
    required int correctCount,
    required int total,
  }) {
    if (total <= 0) return false;
    return (correctCount / total) * 100 >= passAveragePercent;
  }

  /// Best known score per pair (missing pairs are omitted).
  static Map<int, int> pairScoresById(List<PairProgressDomain> pairProgress) {
    return {for (final row in pairProgress) row.pairId: row.scorePct};
  }

  static bool isSubmoduleCompleted({
    required GameTrailSubmoduleDomain submodule,
    required Map<int, int> pairScores,
  }) {
    if (submodule.games.isEmpty) return false;
    var sum = 0;
    for (final game in submodule.games) {
      final score = pairScores[game.pairId];
      if (score == null) return false;
      sum += score;
    }
    return (sum / submodule.games.length) >= passAveragePercent;
  }

  /// Every game has a saved score (session finished), regardless of pass.
  static bool isSubmoduleFullyAttempted({
    required GameTrailSubmoduleDomain submodule,
    required Map<int, int> pairScores,
  }) {
    if (submodule.games.isEmpty) return false;
    return submodule.games.every((game) => pairScores.containsKey(game.pairId));
  }

  /// Finished below the pass threshold — must replay to unlock the next.
  static bool isSubmoduleFailed({
    required GameTrailSubmoduleDomain submodule,
    required Map<int, int> pairScores,
  }) {
    return isSubmoduleFullyAttempted(
          submodule: submodule,
          pairScores: pairScores,
        ) &&
        !isSubmoduleCompleted(submodule: submodule, pairScores: pairScores);
  }

  static int completedSubmoduleCount({
    required GameTrailDomain trail,
    required Map<int, int> pairScores,
  }) {
    var count = 0;
    for (final level in trail.levels) {
      for (final submodule in level.submodules) {
        if (isSubmoduleCompleted(
          submodule: submodule,
          pairScores: pairScores,
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
    required Map<int, int> pairScores,
  }) {
    final total = totalSubmoduleCount(trail);
    if (total == 0) return 0;
    final done = completedSubmoduleCount(trail: trail, pairScores: pairScores);
    return ((done / total) * 100).round();
  }

  /// Submodules after the first incomplete one (in trail order) stay locked.
  /// Submodules with no games do not block later ones.
  static Set<int> lockedSubmoduleIds({
    required GameTrailDomain trail,
    required Map<int, int> pairScores,
  }) {
    final locked = <int>{};
    var unlockNext = true;
    for (final level in trail.levels) {
      for (final submodule in level.submodules) {
        if (!unlockNext) locked.add(submodule.id);
        unlockNext =
            submodule.games.isEmpty ||
            isSubmoduleCompleted(submodule: submodule, pairScores: pairScores);
      }
    }
    return locked;
  }
}
