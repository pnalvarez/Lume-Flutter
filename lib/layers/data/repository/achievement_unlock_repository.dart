import 'package:injectable/injectable.dart';
import 'package:lume/layers/data/datasource/achievement_unlock_data_source.dart';
import 'package:lume/layers/data/mappers/achievement_unlock_mapper.dart';
import 'package:lume/layers/domain/models/achievement/achievement_unlock_domain.dart';
import 'package:lume/layers/domain/repository/achievement_unlock_repository.dart';

@LazySingleton(as: IAchievementUnlockRepository)
final class AchievementUnlockRepository
    implements IAchievementUnlockRepository {
  AchievementUnlockRepository(this._dataSource);

  final IAchievementUnlockDataSource _dataSource;

  @override
  Stream<AchievementUnlockDomain> watch() {
    return _dataSource.watch().map(AchievementUnlockMapper.toDomain);
  }
}
