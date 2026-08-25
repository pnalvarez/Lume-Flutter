import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/models/arcade/arcade_domain.dart';
import 'package:lume/layers/domain/repository/arcade_repository.dart';

abstract interface class ISaveArcadeRecord {
  Future<ArcadeRecordResultDomain> call({required int rounds});
}

@Injectable(as: ISaveArcadeRecord)
class SaveArcadeRecord implements ISaveArcadeRecord {
  SaveArcadeRecord(this._repository);

  final IArcadeRepository _repository;

  @override
  Future<ArcadeRecordResultDomain> call({required int rounds}) {
    return _repository.saveRecord(rounds: rounds);
  }
}
