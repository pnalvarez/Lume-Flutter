import 'package:flutter/foundation.dart';

@immutable
sealed class TrailDetailEvent {
  const TrailDetailEvent();
}

final class TrailDetailStarted extends TrailDetailEvent {
  const TrailDetailStarted({
    required this.trailId,
    this.forceRefresh = false,
  });

  final int trailId;
  final bool forceRefresh;
}

final class TrailDetailSubmodulePressed extends TrailDetailEvent {
  const TrailDetailSubmodulePressed(this.submoduleId);

  final int submoduleId;
}

final class TrailDetailBackPressed extends TrailDetailEvent {
  const TrailDetailBackPressed();
}

final class TrailDetailNavigationHandled extends TrailDetailEvent {
  const TrailDetailNavigationHandled();
}
