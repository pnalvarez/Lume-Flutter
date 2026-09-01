import 'package:injectable/injectable.dart';
import 'package:lume/layers/data/datasource/level_up_data_source.dart';
import 'package:lume/layers/data/mappers/level_up_mapper.dart';
import 'package:lume/layers/domain/models/xp/level_up_domain.dart';
import 'package:lume/layers/domain/repository/level_up_repository.dart';

@LazySingleton(as: ILevelUpRepository)
final class LevelUpRepository implements ILevelUpRepository {
  LevelUpRepository(this._dataSource);

  final ILevelUpDataSource _dataSource;

  @override
  Stream<LevelUpDomain> watch() {
    return _dataSource.watch().map(LevelUpMapper.toDomain);
  }
}
