import 'package:flutter/foundation.dart';

@immutable
sealed class GamesHubEvent {
  const GamesHubEvent();
}

final class GamesHubStarted extends GamesHubEvent {
  const GamesHubStarted({this.forceRefresh = false});

  final bool forceRefresh;
}

final class GamesHubGamePressed extends GamesHubEvent {
  const GamesHubGamePressed(this.gameId);

  final String gameId;
}

final class GamesHubArcadePressed extends GamesHubEvent {
  const GamesHubArcadePressed();
}
