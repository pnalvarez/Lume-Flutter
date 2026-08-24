import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/models/game/hub_game_domain.dart';
import 'package:lume/layers/domain/repository/game_repository.dart';

abstract interface class IGetHubGames {
  Future<List<HubGameDomain>> call({bool forceRefresh = false});
}

@Injectable(as: IGetHubGames)
class GetHubGames implements IGetHubGames {
  GetHubGames(this._repository);

  final IGameRepository _repository;

  @override
  Future<List<HubGameDomain>> call({bool forceRefresh = false}) {
    return _repository.getHubGames(forceRefresh: forceRefresh);
  }
}
