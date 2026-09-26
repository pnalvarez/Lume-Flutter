import 'package:injectable/injectable.dart';
import 'package:lume/layers/data/datasource/achievements_data_source.dart';
import 'package:lume/layers/data/mappers/achievement_mapper.dart';
import 'package:lume/layers/domain/models/achievement/achievement_domain.dart';
import 'package:lume/layers/domain/repository/achievements_repository.dart';

@Injectable(as: IAchievementsRepository)
final class AchievementsRepository implements IAchievementsRepository {
  AchievementsRepository(this._dataSource);

  final IAchievementsDataSource _dataSource;

  @override
  Future<List<AchievementDomain>> getAchievements() async {
    final data = await _dataSource.fetchAchievements();
    return [for (final item in data) AchievementMapper.toDomain(item)];
  }
}
