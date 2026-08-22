import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/models/game/game_trail_domain.dart';
import 'package:lume/layers/domain/repository/trail_repository.dart';

abstract interface class IGetGameTrails {
  Future<List<GameTrailDomain>> call({bool forceRefresh = false});
}

@Injectable(as: IGetGameTrails)
class GetGameTrails implements IGetGameTrails {
  GetGameTrails(this._repository);

  final ITrailRepository _repository;

  @override
  Future<List<GameTrailDomain>> call({bool forceRefresh = false}) {
    return _repository.getGameTrails(forceRefresh: forceRefresh);
  }
}
