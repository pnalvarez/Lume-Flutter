import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/models/game/submodule_games_domain.dart';
import 'package:lume/layers/domain/repository/game_repository.dart';

abstract interface class IGetSubmoduleGames {
  Future<SubmoduleGamesDomain> call({
    required int submoduleId,
    bool forceRefresh = false,
  });
}

@Injectable(as: IGetSubmoduleGames)
class GetSubmoduleGames implements IGetSubmoduleGames {
  GetSubmoduleGames(this._repository);

  final IGameRepository _repository;

  @override
  Future<SubmoduleGamesDomain> call({
    required int submoduleId,
    bool forceRefresh = false,
  }) {
    return _repository.getSubmoduleGames(
      submoduleId: submoduleId,
      forceRefresh: forceRefresh,
    );
  }
}
