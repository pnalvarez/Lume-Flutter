import 'package:lume/layers/domain/models/arcade/arcade_domain.dart';

abstract interface class IArcadeRepository {
  Future<ArcadeRecordDomain> getRecord();

  Future<ArcadeRoundResultDomain> saveRound({
    required int pairId,
    required int scorePct,
    required int roundNumber,
  });

  Future<ArcadeRecordResultDomain> saveRecord({required int rounds});
}
