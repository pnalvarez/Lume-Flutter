import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/models/achievement/achievement_domain.dart';
import 'package:lume/layers/domain/repository/achievements_repository.dart';

abstract interface class IGetAchievements {
  Future<List<AchievementDomain>> call();
}

@Injectable(as: IGetAchievements)
class GetAchievements implements IGetAchievements {
  GetAchievements(this._repository);

  final IAchievementsRepository _repository;

  @override
  Future<List<AchievementDomain>> call() {
    return _repository.getAchievements();
  }
}
