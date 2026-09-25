import 'package:lume/layers/data/models/achievement_unlock_data.dart';
import 'package:lume/layers/domain/models/achievement/achievement_unlock_domain.dart';

abstract final class AchievementUnlockMapper {
  static AchievementUnlockDomain toDomain(AchievementUnlockData data) {
    return AchievementUnlockDomain(
      achievementId: data.achievementId,
      code: data.code,
      name: data.name,
      icon: data.icon,
    );
  }
}
