import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/repository/push_device_repository.dart';

/// Registers token + timezone for the signed-in user when permission is
/// already granted. Returns whether the server row is up to date.
abstract interface class IRegisterPushDevice {
  Future<bool> call();
}

@Injectable(as: IRegisterPushDevice)
class RegisterPushDevice implements IRegisterPushDevice {
  RegisterPushDevice(this._repository);

  final IPushDeviceRepository _repository;

  @override
  Future<bool> call() => _repository.registerCurrentDevice();
}
