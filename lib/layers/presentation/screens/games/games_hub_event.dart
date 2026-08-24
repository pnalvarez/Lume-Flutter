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
  const GamesHubGamePressed(this.gameSlug);

  final String gameSlug;
}

final class GamesHubArcadePressed extends GamesHubEvent {
  const GamesHubArcadePressed();
}

final class GamesHubNavigationHandled extends GamesHubEvent {
  const GamesHubNavigationHandled();
}

final class GamesHubGameRoundErrorDismissed extends GamesHubEvent {
  const GamesHubGameRoundErrorDismissed();
}
