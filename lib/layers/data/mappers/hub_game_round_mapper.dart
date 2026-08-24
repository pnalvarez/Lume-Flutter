import 'package:lume/layers/data/mappers/trail_game_mapper.dart';
import 'package:lume/layers/data/models/hub_game_round_data.dart';
import 'package:lume/layers/domain/models/game/hub_game_round_domain.dart';

abstract final class HubGameRoundMapper {
  static HubGameRoundDomain toDomain(HubGameRoundData data) {
    return HubGameRoundDomain(
      gameSlug: data.gameSlug,
      gameName: data.gameName,
      games: TrailGameMapper.parseAll(data.games),
    );
  }
}
