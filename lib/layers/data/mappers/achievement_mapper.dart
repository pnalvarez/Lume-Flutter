import 'package:lume/layers/data/models/achievement_data.dart';
import 'package:lume/layers/domain/models/achievement/achievement_domain.dart';
import 'package:lume/layers/domain/models/achievement/achievement_icon.dart';

abstract final class AchievementMapper {
  const AchievementMapper._();

  static AchievementDomain toDomain(AchievementData data) {
    return AchievementDomain(
      id: data.id,
      code: data.code,
      name: data.name,
      description: data.description,
      icon: AchievementIcon.fromWire(data.icon),
      conditionType: data.conditionType,
      conditionTarget: data.conditionTarget,
      rewardType: data.rewardType,
      rewardAmount: data.rewardAmount,
      progress: data.progress,
      completedAt: data.completedAt,
      rewardClaimedAt: data.rewardClaimedAt,
    );
  }
}
