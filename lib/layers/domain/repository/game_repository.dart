import 'package:lume/layers/domain/models/game/hub_game_domain.dart';
import 'package:lume/layers/domain/models/game/submodule_games_domain.dart';

abstract interface class IGameRepository {
  Future<SubmoduleGamesDomain> getSubmoduleGames({
    required int submoduleId,
    bool forceRefresh = false,
  });

  Future<List<HubGameDomain>> getHubGames({bool forceRefresh = false});
}
