import 'package:flutter/foundation.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';

enum SubmoduleSessionStatus { loading, ready, saving, error }

enum SubmoduleSessionStage { preview, completed }

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
    this.correctCount = 0,
    this.pairScores = const {},
    this.xpAwarded = 0,
    this.completeUnlockMessage = '',
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
  final int correctCount;
  final Map<int, int> pairScores;
  final int xpAwarded;

  /// Guidance under the score on the complete step (set by the bloc).
  final String completeUnlockMessage;
  final String? errorMessage;
  final bool goBackToTrail;

  /// Preview stays at 0; complete is 1. Mid-sequence progress lives on GamesPage.
  double get progressValue {
    if (stage == SubmoduleSessionStage.completed) return 1.0;
    return 0.0;
  }

  bool get canRetrySave =>
      status == SubmoduleSessionStatus.error &&
      pairScores.isNotEmpty &&
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
    int? correctCount,
    Map<int, int>? pairScores,
    int? xpAwarded,
    String? completeUnlockMessage,
    String? errorMessage,
    bool? goBackToTrail,
    bool clearError = false,
    bool clearLevelTitle = false,
    bool clearImageUrl = false,
    bool clearPairScores = false,
    bool clearXpAwarded = false,
    bool clearCompleteUnlockMessage = false,
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
      correctCount: correctCount ?? this.correctCount,
      pairScores: clearPairScores ? const {} : pairScores ?? this.pairScores,
      xpAwarded: clearXpAwarded ? 0 : xpAwarded ?? this.xpAwarded,
      completeUnlockMessage: clearCompleteUnlockMessage
          ? ''
          : completeUnlockMessage ?? this.completeUnlockMessage,
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
      other.correctCount == correctCount &&
      mapEquals(other.pairScores, pairScores) &&
      other.xpAwarded == xpAwarded &&
      other.completeUnlockMessage == completeUnlockMessage &&
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
    correctCount,
    Object.hashAll(pairScores.entries),
    xpAwarded,
    completeUnlockMessage,
    errorMessage,
    goBackToTrail,
  );
}
