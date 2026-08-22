import 'package:flutter/foundation.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';

enum SubmoduleSessionStatus { loading, ready, saving, error }

enum SubmoduleSessionStage { preview, playing, completed }

@immutable
final class SubmoduleSessionState {
  const SubmoduleSessionState({
    this.status = SubmoduleSessionStatus.loading,
    this.stage = SubmoduleSessionStage.preview,
    this.trailId = 0,
    this.submoduleId = 0,
    this.title = '',
    this.levelTitle,
    this.preview = '',
    this.imageUrl,
    this.games = const [],
    this.currentIndex = 0,
    this.correctCount = 0,
    this.pairScores = const {},
    this.errorMessage,
    this.goBackToTrail = false,
  });

  final SubmoduleSessionStatus status;
  final SubmoduleSessionStage stage;
  final int trailId;
  final int submoduleId;
  final String title;
  final String? levelTitle;
  final String preview;
  final String? imageUrl;
  final List<TrailGameDomain> games;
  final int currentIndex;
  final int correctCount;
  final Map<int, int> pairScores;
  final String? errorMessage;
  final bool goBackToTrail;

  TrailGameDomain? get currentGame {
    if (currentIndex < 0 || currentIndex >= games.length) return null;
    return games[currentIndex];
  }

  /// Progress in [0.0, 1.0] for the session chrome bar.
  /// Preview is 0; while playing, advances with the current game (1-based).
  double get progressValue {
    if (stage == SubmoduleSessionStage.completed) return 1.0;
    if (stage == SubmoduleSessionStage.preview || games.isEmpty) return 0.0;
    return ((currentIndex + 1) / games.length).clamp(0.0, 1.0);
  }

  /// True when all in-memory pair scores exist and the last flush failed.
  bool get canRetrySave =>
      status == SubmoduleSessionStatus.error &&
      stage == SubmoduleSessionStage.playing &&
      games.isNotEmpty &&
      pairScores.length == games.length;

  SubmoduleSessionState copyWith({
    SubmoduleSessionStatus? status,
    SubmoduleSessionStage? stage,
    int? trailId,
    int? submoduleId,
    String? title,
    String? levelTitle,
    String? preview,
    String? imageUrl,
    List<TrailGameDomain>? games,
    int? currentIndex,
    int? correctCount,
    Map<int, int>? pairScores,
    String? errorMessage,
    bool? goBackToTrail,
    bool clearError = false,
    bool clearLevelTitle = false,
    bool clearImageUrl = false,
    bool clearPairScores = false,
  }) {
    return SubmoduleSessionState(
      status: status ?? this.status,
      stage: stage ?? this.stage,
      trailId: trailId ?? this.trailId,
      submoduleId: submoduleId ?? this.submoduleId,
      title: title ?? this.title,
      levelTitle: clearLevelTitle ? null : levelTitle ?? this.levelTitle,
      preview: preview ?? this.preview,
      imageUrl: clearImageUrl ? null : imageUrl ?? this.imageUrl,
      games: games ?? this.games,
      currentIndex: currentIndex ?? this.currentIndex,
      correctCount: correctCount ?? this.correctCount,
      pairScores: clearPairScores ? const {} : pairScores ?? this.pairScores,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      goBackToTrail: goBackToTrail ?? this.goBackToTrail,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is SubmoduleSessionState &&
      other.status == status &&
      other.stage == stage &&
      other.trailId == trailId &&
      other.submoduleId == submoduleId &&
      other.title == title &&
      other.levelTitle == levelTitle &&
      other.preview == preview &&
      other.imageUrl == imageUrl &&
      listEquals(other.games, games) &&
      other.currentIndex == currentIndex &&
      other.correctCount == correctCount &&
      mapEquals(other.pairScores, pairScores) &&
      other.errorMessage == errorMessage &&
      other.goBackToTrail == goBackToTrail;

  @override
  int get hashCode => Object.hash(
    status,
    stage,
    trailId,
    submoduleId,
    title,
    levelTitle,
    preview,
    imageUrl,
    Object.hashAll(games),
    currentIndex,
    correctCount,
    Object.hashAll(pairScores.entries),
    errorMessage,
    goBackToTrail,
  );
}
