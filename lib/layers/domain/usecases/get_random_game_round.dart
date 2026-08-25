import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';
import 'package:lume/layers/domain/repository/game_repository.dart';

/// One random playable game for arcade mode. The backend does the picking;
/// `null` means it had no playable content to offer.
abstract interface class IGetRandomGameRound {
  Future<TrailGameDomain?> call();
}

@Injectable(as: IGetRandomGameRound)
class GetRandomGameRound implements IGetRandomGameRound {
  GetRandomGameRound(this._repository);

  final IGameRepository _repository;

  @override
  Future<TrailGameDomain?> call() async {
    final round = await _repository.getRandomGameRound();
    return round.games.isEmpty ? null : round.games.first;
  }
}
