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

final class SubmoduleSessionPreviewContinue extends SubmoduleSessionEvent {
  const SubmoduleSessionPreviewContinue();
}

final class SubmoduleSessionGameFinished extends SubmoduleSessionEvent {
  const SubmoduleSessionGameFinished(this.correct);

  final bool correct;
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
