import 'package:flutter/foundation.dart';

@immutable
sealed class HomeEvent {
  const HomeEvent();
}

final class HomeStarted extends HomeEvent {
  const HomeStarted({this.forceRefresh = false});

  final bool forceRefresh;
}

final class HomeTrailPressed extends HomeEvent {
  const HomeTrailPressed(this.trailId);

  final int trailId;
}

final class HomeNavigationHandled extends HomeEvent {
  const HomeNavigationHandled();
}
