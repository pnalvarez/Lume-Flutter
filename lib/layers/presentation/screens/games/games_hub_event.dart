import 'package:flutter/foundation.dart';
import 'package:lume/layers/presentation/screens/games/game_round.dart';

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

final class GamesHubRoundCompleted extends GamesHubEvent {
  const GamesHubRoundCompleted(this.result);

  final GamesSequenceResult result;
}

final class GamesHubRoundCompleteDismissed extends GamesHubEvent {
  const GamesHubRoundCompleteDismissed();
}

final class GamesHubGameRoundErrorDismissed extends GamesHubEvent {
  const GamesHubGameRoundErrorDismissed();
}
