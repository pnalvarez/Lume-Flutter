import 'package:injectable/injectable.dart';
import 'package:lume/layers/data/datasource/arcade_data_source.dart';
import 'package:lume/layers/data/mappers/arcade_mapper.dart';
import 'package:lume/layers/domain/models/arcade/arcade_domain.dart';
import 'package:lume/layers/domain/repository/arcade_repository.dart'
    show IArcadeRepository;

@Injectable(as: IArcadeRepository)
final class ArcadeRepository implements IArcadeRepository {
  ArcadeRepository(this._dataSource);

  final IArcadeDataSource _dataSource;

  @override
  Future<ArcadeRecordDomain> getRecord() async {
    final data = await _dataSource.fetchRecord();
    return ArcadeMapper.toRecordDomain(data);
  }

  @override
  Future<ArcadeRoundResultDomain> saveRound({
    required int pairId,
    required int scorePct,
    required int roundNumber,
  }) async {
    final data = await _dataSource.saveRound(
      pairId: pairId,
      scorePct: scorePct,
      roundNumber: roundNumber,
    );
    return ArcadeMapper.toRoundResultDomain(data);
  }

  @override
  Future<ArcadeRecordResultDomain> saveRecord({required int rounds}) async {
    final data = await _dataSource.saveRecord(rounds: rounds);
    return ArcadeMapper.toRecordResultDomain(data);
  }
}
