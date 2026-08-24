import 'package:flutter/foundation.dart';

@immutable
sealed class SubmoduleSessionEvent {
  const SubmoduleSessionEvent();
}

final class SubmoduleSessionStarted extends SubmoduleSessionEvent {
  const SubmoduleSessionStarted({
    required this.trailId,
    required this.submoduleId,
    this.forceRefresh = false,
  });

  final int trailId;
  final int submoduleId;
  final bool forceRefresh;
}

/// Buffers a round score from [GamesPage] via the save callback (no network yet).
final class SubmoduleSessionRoundScored extends SubmoduleSessionEvent {
  const SubmoduleSessionRoundScored({
    required this.pairId,
    required this.scorePct,
  });

  final int pairId;
  final int scorePct;
}

/// Flushes buffered pair scores after the games sequence finishes.
final class SubmoduleSessionGamesCompleted extends SubmoduleSessionEvent {
  const SubmoduleSessionGamesCompleted({required this.correctCount});

  final int correctCount;
}

/// User left the games sequence without finishing — discard buffered scores.
final class SubmoduleSessionGamesCancelled extends SubmoduleSessionEvent {
  const SubmoduleSessionGamesCancelled();
}

final class SubmoduleSessionRetrySave extends SubmoduleSessionEvent {
  const SubmoduleSessionRetrySave();
}

final class SubmoduleSessionAbandoned extends SubmoduleSessionEvent {
  const SubmoduleSessionAbandoned();
}

final class SubmoduleSessionBackToTrailPressed extends SubmoduleSessionEvent {
  const SubmoduleSessionBackToTrailPressed();
}

final class SubmoduleSessionNavigationHandled extends SubmoduleSessionEvent {
  const SubmoduleSessionNavigationHandled();
}
