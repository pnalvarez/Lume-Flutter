import 'package:flutter/foundation.dart';
import 'package:lume/layers/domain/models/game/hub_game_domain.dart';
import 'package:lume/layers/presentation/screens/games/games_hub_card_ui.dart';

enum GamesHubStatus { loading, ready, error }

@immutable
final class GamesHubState {
  const GamesHubState({
    this.status = GamesHubStatus.loading,
    this.games = const [],
    this.errorMessage,
  });

  final GamesHubStatus status;
  final List<GamesHubCardUi> games;
  final String? errorMessage;

  List<GamesHubCardUi> get generalGames => [
    for (final game in games)
      if (game.hubSection == HubSection.general) game,
  ];

  List<GamesHubCardUi> get visualGames => [
    for (final game in games)
      if (game.hubSection == HubSection.visual) game,
  ];

  GamesHubState copyWith({
    GamesHubStatus? status,
    List<GamesHubCardUi>? games,
    String? errorMessage,
    bool clearError = false,
  }) {
    return GamesHubState(
      status: status ?? this.status,
      games: games ?? this.games,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is GamesHubState &&
      other.status == status &&
      listEquals(other.games, games) &&
      other.errorMessage == errorMessage;

  @override
  int get hashCode => Object.hash(status, Object.hashAll(games), errorMessage);
}
