import 'package:flutter/foundation.dart';
import 'package:lume/layers/domain/models/game/hub_game_domain.dart';
import 'package:lume/layers/presentation/screens/games/game_round.dart';
import 'package:lume/layers/presentation/screens/games/games_hub_card_ui.dart';

@immutable
final class GamesHubState {
  const GamesHubState({
    this.isInitialLoading = true,
    this.isLoadingGame = false,
    this.games = const [],
    this.initialErrorMessage,
    this.gameRoundErrorMessage,
    this.openPlayRounds,
  });

  /// Catalog skeleton while hub games load.
  final bool isInitialLoading;

  /// Translucent overlay while a hub round is fetched.
  final bool isLoadingGame;

  final List<GamesHubCardUi> games;
  final String? initialErrorMessage;
  final String? gameRoundErrorMessage;

  /// Set after a successful round fetch; cleared when navigation is handled.
  final List<GameRound>? openPlayRounds;

  List<GamesHubCardUi> get generalGames => [
    for (final game in games)
      if (game.hubSection == HubSection.general) game,
  ];

  List<GamesHubCardUi> get visualGames => [
    for (final game in games)
      if (game.hubSection == HubSection.visual) game,
  ];

  GamesHubState copyWith({
    bool? isInitialLoading,
    bool? isLoadingGame,
    List<GamesHubCardUi>? games,
    String? initialErrorMessage,
    String? gameRoundErrorMessage,
    List<GameRound>? openPlayRounds,
    bool clearInitialError = false,
    bool clearGameRoundError = false,
    bool clearOpenPlayRounds = false,
  }) {
    return GamesHubState(
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isLoadingGame: isLoadingGame ?? this.isLoadingGame,
      games: games ?? this.games,
      initialErrorMessage: clearInitialError
          ? null
          : initialErrorMessage ?? this.initialErrorMessage,
      gameRoundErrorMessage: clearGameRoundError
          ? null
          : gameRoundErrorMessage ?? this.gameRoundErrorMessage,
      openPlayRounds: clearOpenPlayRounds
          ? null
          : openPlayRounds ?? this.openPlayRounds,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is GamesHubState &&
      other.isInitialLoading == isInitialLoading &&
      other.isLoadingGame == isLoadingGame &&
      listEquals(other.games, games) &&
      other.initialErrorMessage == initialErrorMessage &&
      other.gameRoundErrorMessage == gameRoundErrorMessage &&
      listEquals(other.openPlayRounds, openPlayRounds);

  @override
  int get hashCode => Object.hash(
    isInitialLoading,
    isLoadingGame,
    Object.hashAll(games),
    initialErrorMessage,
    gameRoundErrorMessage,
    openPlayRounds == null ? null : Object.hashAll(openPlayRounds!),
  );
}
