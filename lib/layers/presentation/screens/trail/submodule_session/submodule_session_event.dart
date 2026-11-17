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

/// Preview: move to the next slide (Continue on a non-last slide).
final class SubmoduleSessionSlideAdvanced extends SubmoduleSessionEvent {
  const SubmoduleSessionSlideAdvanced();
}

/// Preview: jump to [index] (swipe). Out-of-range values are clamped.
final class SubmoduleSessionSlideSelected extends SubmoduleSessionEvent {
  const SubmoduleSessionSlideSelected(this.index);

  final int index;
}

/// Header back button / system back. On a later preview slide it steps to the
/// previous slide; otherwise it behaves like [SubmoduleSessionAbandoned].
final class SubmoduleSessionBackPressed extends SubmoduleSessionEvent {
  const SubmoduleSessionBackPressed();
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
