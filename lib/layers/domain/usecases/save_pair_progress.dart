import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/models/trail/trail_progress_domain.dart';
import 'package:lume/layers/domain/repository/trail_repository.dart';

abstract interface class ISavePairProgress {
  Future<PairProgressDomain> call({
    required int pairId,
    required int scorePct,
  });
}

@Injectable(as: ISavePairProgress)
class SavePairProgress implements ISavePairProgress {
  SavePairProgress(this._repository);

  final ITrailRepository _repository;

  @override
  Future<PairProgressDomain> call({
    required int pairId,
    required int scorePct,
  }) {
    return _repository.savePairProgress(pairId: pairId, scorePct: scorePct);
  }
}
