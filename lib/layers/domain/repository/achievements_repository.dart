import 'package:lume/layers/domain/models/achievement/achievement_domain.dart';

abstract interface class IAchievementsRepository {
  Future<List<AchievementDomain>> getAchievements();
}
