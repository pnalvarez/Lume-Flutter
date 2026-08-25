import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/models/arcade/arcade_domain.dart';
import 'package:lume/layers/domain/repository/arcade_repository.dart';

abstract interface class ISaveArcadeRound {
  Future<ArcadeRoundResultDomain> call({
    required int pairId,
    required int scorePct,
    required int roundNumber,
  });
}

@Injectable(as: ISaveArcadeRound)
class SaveArcadeRound implements ISaveArcadeRound {
  SaveArcadeRound(this._repository);

  final IArcadeRepository _repository;

  @override
  Future<ArcadeRoundResultDomain> call({
    required int pairId,
    required int scorePct,
    required int roundNumber,
  }) {
    return _repository.saveRound(
      pairId: pairId,
      scorePct: scorePct,
      roundNumber: roundNumber,
    );
  }
}
