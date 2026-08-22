import 'package:injectable/injectable.dart';
import 'package:lume/layers/data/datasource/trail_data_source.dart';
import 'package:lume/layers/data/mappers/trail_mapper.dart';
import 'package:lume/layers/domain/models/game/game_trail_domain.dart';
import 'package:lume/layers/domain/models/trail/trail_catalog_domain.dart';
import 'package:lume/layers/domain/models/trail/trail_progress_domain.dart';
import 'package:lume/layers/domain/repository/trail_repository.dart'
    show ITrailRepository;

@Injectable(as: ITrailRepository)
final class TrailRepository implements ITrailRepository {
  TrailRepository(this._dataSource);

  final ITrailDataSource _dataSource;

  @override
  Future<TrailBootstrapDomain> getBootstrap({bool forceRefresh = false}) async {
    final data = await _dataSource.fetchBootstrap(forceRefresh: forceRefresh);
    return TrailMapper.toBootstrapDomain(data);
  }

  @override
  Future<TrailProgressDomain> getProgress({bool forceRefresh = false}) async {
    final data = await _dataSource.fetchProgress(forceRefresh: forceRefresh);
    return TrailMapper.toProgressDomain(data);
  }

  @override
  Future<List<GameTrailDomain>> getGameTrails({
    bool forceRefresh = false,
  }) async {
    final data = await _dataSource.fetchGameTrails(forceRefresh: forceRefresh);
    return TrailMapper.toGameTrailDomains(data);
  }

  @override
  Future<PairProgressDomain> savePairProgress({
    required int pairId,
    required int scorePct,
  }) async {
    final data = await _dataSource.savePairProgress(
      pairId: pairId,
      scorePct: scorePct,
    );
    return TrailMapper.toPairProgressDomain(data);
  }
}
