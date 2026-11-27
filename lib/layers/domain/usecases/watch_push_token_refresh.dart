import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/repository/push_device_repository.dart';

abstract interface class IWatchPushTokenRefresh {
  Stream<void> call();
}

@Injectable(as: IWatchPushTokenRefresh)
class WatchPushTokenRefresh implements IWatchPushTokenRefresh {
  WatchPushTokenRefresh(this._repository);

  final IPushDeviceRepository _repository;

  @override
  Stream<void> call() => _repository.watchTokenRefresh();
}
