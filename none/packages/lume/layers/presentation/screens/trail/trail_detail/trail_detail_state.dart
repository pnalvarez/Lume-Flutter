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
  });

  final int id;
  final String title;
  final int gamesCount;
  final bool isCompleted;

  factory TrailDetailSubmoduleRowUi.fromDomain({
    required GameTrailSubmoduleDomain submodule,
    required Set<int> completedPairs,
  }) {
    return TrailDetailSubmoduleRowUi(
      id: submodule.id,
      title: submodule.title,
      gamesCount: submodule.games.length,
      isCompleted: TrailProgressCalculator.isSubmoduleCompleted(
        submodule: submodule,
        completedPairs: completedPairs,
      ),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is TrailDetailSubmoduleRowUi &&
      other.id == id &&
      other.title == title &&
      other.gamesCount == gamesCount &&
      other.isCompleted == isCompleted;

  @override
  int get hashCode => Object.hash(id, title, gamesCount, isCompleted);
}

@immutable
final class TrailDetailLevelUi {
  const TrailDetailLevelUi({
    required this.title,
    required this.submodules,
  });

  final String title;
  final List<TrailDetailSubmoduleRowUi> submodules;

  factory TrailDetailLevelUi.fromDomain({
    required GameTrailLevelDomain level,
    required Set<int> completedPairs,
  }) {
    return TrailDetailLevelUi(
      title: level.title,
      submodules: [
        for (final submodule in level.submodules)
          TrailDetailSubmoduleRowUi.fromDomain(
            submodule: submodule,
            completedPairs: completedPairs,
          ),
      ],
    );
  }

  @override
  bool operator ==(Object other) =>
      other is TrailDetailLevelUi &&
      other.title == title &&
      listEquals(other.submodules, submodules);

  @override
  int get hashCode => Object.hash(title, Object.hashAll(submodules));
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

  String get headerTitle {
    final trimmed = title.trim();
    if (trimmed.isEmpty) return emoji;
    return '$emoji $trimmed';
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
