import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/models/game/hub_game_round_domain.dart';
import 'package:lume/layers/domain/repository/game_repository.dart';

abstract interface class IGetGameRound {
  Future<HubGameRoundDomain> call({required String gameSlug, int limit = 5});
}

@Injectable(as: IGetGameRound)
class GetGameRound implements IGetGameRound {
  GetGameRound(this._repository);

  final IGameRepository _repository;

  @override
  Future<HubGameRoundDomain> call({required String gameSlug, int limit = 5}) {
    return _repository.getGameRound(gameSlug: gameSlug, limit: limit);
  }
}
