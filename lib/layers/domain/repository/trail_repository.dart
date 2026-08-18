import 'package:lume/layers/domain/models/game/game_trail_domain.dart';
import 'package:lume/layers/domain/models/trail/trail_catalog_domain.dart';
import 'package:lume/layers/domain/models/trail/trail_progress_domain.dart';

abstract interface class ITrailRepository {
  Future<TrailBootstrapDomain> getBootstrap({bool forceRefresh = false});

  Future<TrailProgressDomain> getProgress({bool forceRefresh = false});

  Future<List<GameTrailDomain>> getGameTrails({bool forceRefresh = false});

  Future<PairProgressDomain> savePairProgress({
    required int pairId,
    required int scorePct,
  });
}
