import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/repository/push_device_repository.dart';

/// Removes this device's push token (logout). Run before the session ends.
abstract interface class IUnregisterPushDevice {
  Future<void> call();
}

@Injectable(as: IUnregisterPushDevice)
class UnregisterPushDevice implements IUnregisterPushDevice {
  UnregisterPushDevice(this._repository);

  final IPushDeviceRepository _repository;

  @override
  Future<void> call() => _repository.unregisterCurrentDevice();
}
