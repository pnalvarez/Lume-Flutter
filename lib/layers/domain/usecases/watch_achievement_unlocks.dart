import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/models/achievement/achievement_unlock_domain.dart';
import 'package:lume/layers/domain/repository/achievement_unlock_repository.dart';

abstract interface class IWatchAchievementUnlocks {
  Stream<AchievementUnlockDomain> call();
}

@LazySingleton(as: IWatchAchievementUnlocks)
final class WatchAchievementUnlocks implements IWatchAchievementUnlocks {
  WatchAchievementUnlocks(this._repository);

  final IAchievementUnlockRepository _repository;

  @override
  Stream<AchievementUnlockDomain> call() => _repository.watch();
}
