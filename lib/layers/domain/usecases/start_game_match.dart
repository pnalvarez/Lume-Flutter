import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/repository/game_repository.dart';

/// Opens a `game_matches` row for a hub catalog game.
abstract interface class IStartGameMatch {
  Future<String> call({required String gameSlug});
}

@Injectable(as: IStartGameMatch)
class StartGameMatch implements IStartGameMatch {
  StartGameMatch(this._repository);

  final IGameRepository _repository;

  @override
  Future<String> call({required String gameSlug}) {
    return _repository.startGameMatch(gameSlug: gameSlug);
  }
}
