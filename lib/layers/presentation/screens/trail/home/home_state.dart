import 'package:flutter/foundation.dart';
import 'package:lume/layers/domain/helpers/trail_progress_calculator.dart';
import 'package:lume/layers/domain/models/game/game_trail_domain.dart';

enum HomeStatus { loading, ready, error }

@immutable
final class HomeTrailCardUi {
  const HomeTrailCardUi({
    required this.trailId,
    required this.title,
    required this.emoji,
    required this.completedSubmodules,
    required this.totalSubmodules,
    required this.progressPercent,
  });

  final int trailId;
  final String title;
  final String emoji;
  final int completedSubmodules;
  final int totalSubmodules;
  final int progressPercent;

  factory HomeTrailCardUi.fromDomain({
    required GameTrailDomain trail,
    required Map<int, int> pairScores,
    required ITrailProgressCalculator progressCalculator,
  }) {
    final total = progressCalculator.totalSubmoduleCount(trail);
    final done = progressCalculator.completedSubmoduleCount(
      trail: trail,
      pairScores: pairScores,
    );
    return HomeTrailCardUi(
      trailId: trail.id,
      title: trail.title,
      emoji: (trail.emoji?.trim().isNotEmpty ?? false)
          ? trail.emoji!.trim()
          : '🎮',
      completedSubmodules: done,
      totalSubmodules: total,
      progressPercent: progressCalculator.progressPercent(
        trail: trail,
        pairScores: pairScores,
      ),
    );
  }
}

@immutable
final class HomeState {
  const HomeState({
    this.status = HomeStatus.loading,
    this.greetingName = '',
    this.trails = const [],
    this.errorMessage,
    this.selectedTrailId,
  });

  final HomeStatus status;
  final String greetingName;
  final List<HomeTrailCardUi> trails;
  final String? errorMessage;
  final int? selectedTrailId;

  HomeState copyWith({
    HomeStatus? status,
    String? greetingName,
    List<HomeTrailCardUi>? trails,
    String? errorMessage,
    int? selectedTrailId,
    bool clearError = false,
    bool clearSelectedTrail = false,
  }) {
    return HomeState(
      status: status ?? this.status,
      greetingName: greetingName ?? this.greetingName,
      trails: trails ?? this.trails,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      selectedTrailId: clearSelectedTrail
          ? null
          : selectedTrailId ?? this.selectedTrailId,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is HomeState &&
      other.status == status &&
      other.greetingName == greetingName &&
      listEquals(other.trails, trails) &&
      other.errorMessage == errorMessage &&
      other.selectedTrailId == selectedTrailId;

  @override
  int get hashCode => Object.hash(
    status,
    greetingName,
    Object.hashAll(trails),
    errorMessage,
    selectedTrailId,
  );
}
