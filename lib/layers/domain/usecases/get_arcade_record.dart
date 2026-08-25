import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/models/arcade/arcade_domain.dart';
import 'package:lume/layers/domain/repository/arcade_repository.dart';

abstract interface class IGetArcadeRecord {
  Future<ArcadeRecordDomain> call();
}

@Injectable(as: IGetArcadeRecord)
class GetArcadeRecord implements IGetArcadeRecord {
  GetArcadeRecord(this._repository);

  final IArcadeRepository _repository;

  @override
  Future<ArcadeRecordDomain> call() => _repository.getRecord();
}
