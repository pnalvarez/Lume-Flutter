import 'package:lume/layers/data/models/level_up_data.dart';
import 'package:lume/layers/domain/models/xp/level_up_domain.dart';

abstract final class LevelUpMapper {
  static LevelUpDomain toDomain(LevelUpData data) {
    return LevelUpDomain(
      level: data.level,
      xpOffset: data.xpLevelOffset,
      currentXp: data.totalXp,
      xpForNextLevel: data.xpNextLevelAt,
    );
  }
}
