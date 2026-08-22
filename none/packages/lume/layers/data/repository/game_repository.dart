import 'package:injectable/injectable.dart';
import 'package:lume/layers/data/datasource/game_data_source.dart';
import 'package:lume/layers/data/mappers/trail_mapper.dart';
import 'package:lume/layers/domain/models/game/submodule_games_domain.dart';
import 'package:lume/layers/domain/repository/game_repository.dart';

@Injectable(as: IGameRepository)
final class GameRepository implements IGameRepository {
  GameRepository(this._dataSource);

  final IGameDataSource _dataSource;

  @override
  Future<SubmoduleGamesDomain> getSubmoduleGames({
    required int submoduleId,
    bool forceRefresh = false,
  }) async {
    final data = await _dataSource.fetchSubmoduleGames(
      submoduleId: submoduleId,
      forceRefresh: forceRefresh,
    );
    return TrailMapper.toSubmoduleGamesDomain(data);
  }
}
