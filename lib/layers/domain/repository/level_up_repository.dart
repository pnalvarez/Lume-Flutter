import 'package:lume/layers/domain/models/xp/level_up_domain.dart';

abstract interface class ILevelUpRepository {
  Stream<LevelUpDomain> watch();
}
