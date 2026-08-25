import 'package:flutter/foundation.dart';
import 'package:lume/common/strings/trail_strings.dart';
import 'package:lume/layers/domain/helpers/trail_progress_calculator.dart';
import 'package:lume/layers/domain/models/game/game_trail_domain.dart';

enum TrailDetailStatus { loading, ready, error }

@immutable
final class TrailDetailSubmoduleRowUi {
  const TrailDetailSubmoduleRowUi({
    required this.id,
    required this.title,
    required this.gamesCount,
    required this.isCompleted,
    this.isLocked = false,
    this.needsRetry = false,
    this.unlockHint,
  });

  final int id;
  final String title;
  final int gamesCount;
  final bool isCompleted;
  final bool isLocked;

  /// Finished below 60% — replay required to unlock the next submodule.
  final bool needsRetry;

  /// Shown on the first locked submodule (needs ≥60% on the previous one),
  /// or on a failed submodule (retry guidance).
  final String? unlockHint;

  factory TrailDetailSubmoduleRowUi.fromDomain({
    required GameTrailSubmoduleDomain submodule,
    required Map<int, int> pairScores,
    required bool isLocked,
    required ITrailProgressCalculator progressCalculator,
    String? unlockHint,
  }) {
    final needsRetry =
        !isLocked &&
        progressCalculator.isSubmoduleFailed(
          submodule: submodule,
          pairScores: pairScores,
        );
    final retryHint = needsRetry && submodule.games.isNotEmpty
        ? trailDetailRetryHint(
            minCorrect: progressCalculator.minCorrectCount(
              submodule.games.length,
            ),
            total: submodule.games.length,
          )
        : null;

    return TrailDetailSubmoduleRowUi(
      id: submodule.id,
      title: submodule.title,
      gamesCount: submodule.games.length,
      isCompleted: progressCalculator.isSubmoduleCompleted(
        submodule: submodule,
        pairScores: pairScores,
      ),
      isLocked: isLocked,
      needsRetry: needsRetry,
      unlockHint: unlockHint ?? retryHint,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is TrailDetailSubmoduleRowUi &&
      other.id == id &&
      other.title == title &&
      other.gamesCount == gamesCount &&
      other.isCompleted == isCompleted &&
      other.isLocked == isLocked &&
      other.needsRetry == needsRetry &&
      other.unlockHint == unlockHint;

  @override
  int get hashCode => Object.hash(
    id,
    title,
    gamesCount,
    isCompleted,
    isLocked,
    needsRetry,
    unlockHint,
  );
}

@immutable
final class TrailDetailLevelUi {
  const TrailDetailLevelUi({
    required this.title,
    required this.submodules,
    this.isLocked = false,
  });

  final String title;
  final List<TrailDetailSubmoduleRowUi> submodules;

  /// True when the previous level is unfinished (first submodule locked).
  final bool isLocked;

  @override
  bool operator ==(Object other) =>
      other is TrailDetailLevelUi &&
      other.title == title &&
      other.isLocked == isLocked &&
      listEquals(other.submodules, submodules);

  @override
  int get hashCode => Object.hash(title, isLocked, Object.hashAll(submodules));
}

@immutable
final class TrailDetailState {
  const TrailDetailState({
    this.status = TrailDetailStatus.loading,
    this.trailId = 0,
    this.title = '',
    this.emoji = trailHomeEmojiFallback,
    this.levels = const [],
    this.errorMessage,
    this.selectedSubmoduleId,
    this.goBack = false,
  });

  final TrailDetailStatus status;
  final int trailId;
  final String title;
  final String emoji;
  final List<TrailDetailLevelUi> levels;
  final String? errorMessage;
  final int? selectedSubmoduleId;
  final bool goBack;

  /// Builds level rows and attaches an unlock hint on the first locked cell.
  static List<TrailDetailLevelUi> levelsFromTrail({
    required GameTrailDomain trail,
    required Map<int, int> pairScores,
    required Set<int> lockedSubmoduleIds,
    required ITrailProgressCalculator progressCalculator,
  }) {
    GameTrailSubmoduleDomain? previous;
    var frontierHintAssigned = false;
    final levels = <TrailDetailLevelUi>[];

    for (final level in trail.levels) {
      final rows = <TrailDetailSubmoduleRowUi>[];
      for (final submodule in level.submodules) {
        final locked = lockedSubmoduleIds.contains(submodule.id);
        String? unlockHint;
        if (locked && !frontierHintAssigned) {
          frontierHintAssigned = true;
          if (previous != null && previous.games.isNotEmpty) {
            final total = previous.games.length;
            unlockHint = trailDetailUnlockHint(
              minCorrect: progressCalculator.minCorrectCount(total),
              total: total,
            );
          }
        }

        rows.add(
          TrailDetailSubmoduleRowUi.fromDomain(
            submodule: submodule,
            pairScores: pairScores,
            isLocked: locked,
            progressCalculator: progressCalculator,
            unlockHint: unlockHint,
          ),
        );
        previous = submodule;
      }

      levels.add(
        TrailDetailLevelUi(
          title: level.title,
          submodules: rows,
          isLocked: rows.isNotEmpty && rows.first.isLocked,
        ),
      );
    }

    return levels;
  }

  String get headerTitle {
    final trimmed = title.trim();
    if (trimmed.isEmpty) return emoji;
    return '$emoji $trimmed';
  }

  bool isSubmoduleLocked(int submoduleId) {
    for (final level in levels) {
      for (final submodule in level.submodules) {
        if (submodule.id == submoduleId) return submodule.isLocked;
      }
    }
    return true;
  }

  TrailDetailState copyWith({
    TrailDetailStatus? status,
    int? trailId,
    String? title,
    String? emoji,
    List<TrailDetailLevelUi>? levels,
    String? errorMessage,
    int? selectedSubmoduleId,
    bool? goBack,
    bool clearError = false,
    bool clearSelectedSubmodule = false,
  }) {
    return TrailDetailState(
      status: status ?? this.status,
      trailId: trailId ?? this.trailId,
      title: title ?? this.title,
      emoji: emoji ?? this.emoji,
      levels: levels ?? this.levels,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      selectedSubmoduleId: clearSelectedSubmodule
          ? null
          : selectedSubmoduleId ?? this.selectedSubmoduleId,
      goBack: goBack ?? this.goBack,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is TrailDetailState &&
      other.status == status &&
      other.trailId == trailId &&
      other.title == title &&
      other.emoji == emoji &&
      listEquals(other.levels, levels) &&
      other.errorMessage == errorMessage &&
      other.selectedSubmoduleId == selectedSubmoduleId &&
      other.goBack == goBack;

  @override
  int get hashCode => Object.hash(
    status,
    trailId,
    title,
    emoji,
    Object.hashAll(levels),
    errorMessage,
    selectedSubmoduleId,
    goBack,
  );
}
