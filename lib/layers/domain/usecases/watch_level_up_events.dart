import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/models/xp/level_up_domain.dart';
import 'package:lume/layers/domain/repository/level_up_repository.dart';

abstract interface class IWatchLevelUpEvents {
  Stream<LevelUpDomain> call();
}

@LazySingleton(as: IWatchLevelUpEvents)
class WatchLevelUpEvents implements IWatchLevelUpEvents {
  WatchLevelUpEvents(this._repository);

  final ILevelUpRepository _repository;

  @override
  Stream<LevelUpDomain> call() => _repository.watch();
}
