import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/repository/push_device_repository.dart';

abstract interface class IWatchPushNotificationTaps {
  Stream<void> call();
}

@Injectable(as: IWatchPushNotificationTaps)
class WatchPushNotificationTaps implements IWatchPushNotificationTaps {
  WatchPushNotificationTaps(this._repository);

  final IPushDeviceRepository _repository;

  @override
  Stream<void> call() => _repository.watchNotificationTaps();
}
