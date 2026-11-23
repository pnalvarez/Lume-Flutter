import 'package:injectable/injectable.dart';
import 'package:lume/layers/data/datasource/curiosity_data_source.dart';
import 'package:lume/layers/data/mappers/curiosity_mapper.dart';
import 'package:lume/layers/domain/models/curiosity/curiosity.dart';
import 'package:lume/layers/domain/repository/curiosity_repository.dart';

@Injectable(as: ICuriosityRepository)
final class CuriosityRepository implements ICuriosityRepository {
  CuriosityRepository(this._dataSource);

  final ICuriosityDataSource _dataSource;

  @override
  Future<Curiosity?> getDailyCuriosity(DateTime day) async {
    final data = await _dataSource.fetchDailyCuriosity(day);
    return data == null ? null : CuriosityMapper.toDomain(data);
  }

  @override
  Future<void> markCuriositySeen(String curiosityId) =>
      _dataSource.markSeen(curiosityId);
}
