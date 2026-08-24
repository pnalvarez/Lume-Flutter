import 'package:lume/layers/domain/models/trail_game/trail_game.dart';

/// Random hub play session for one catalog game slug.
class HubGameRoundDomain {
  const HubGameRoundDomain({
    required this.gameSlug,
    required this.gameName,
    required this.games,
  });

  final String gameSlug;
  final String gameName;
  final List<TrailGameDomain> games;
}
