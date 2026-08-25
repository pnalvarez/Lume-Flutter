import 'package:lume/layers/data/models/arcade_data.dart';
import 'package:lume/layers/domain/models/arcade/arcade_domain.dart';

abstract final class ArcadeMapper {
  static ArcadeRecordDomain toRecordDomain(ArcadeRecordData data) {
    return ArcadeRecordDomain(bestRounds: data.bestRounds);
  }

  static ArcadeRoundResultDomain toRoundResultDomain(
    ArcadeRoundResultData data,
  ) {
    return ArcadeRoundResultDomain(
      xpAwarded: data.xpAwarded,
      isRecordRound: data.isRecordRound,
    );
  }

  static ArcadeRecordResultDomain toRecordResultDomain(
    ArcadeRecordResultData data,
  ) {
    return ArcadeRecordResultDomain(
      bestRounds: data.bestRounds,
      previousBestRounds: data.previousBestRounds,
      isNewRecord: data.isNewRecord,
    );
  }
}
