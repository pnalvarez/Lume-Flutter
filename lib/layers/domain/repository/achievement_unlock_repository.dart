import 'package:lume/layers/domain/models/achievement/achievement_unlock_domain.dart';

abstract interface class IAchievementUnlockRepository {
  Stream<AchievementUnlockDomain> watch();
}
