import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/repository/push_device_repository.dart';

/// Shows the OS notification prompt; `true` when granted. The pre-permission
/// dialog UI that calls this ships in #241.
abstract interface class IRequestPushPermission {
  Future<bool> call();
}

@Injectable(as: IRequestPushPermission)
class RequestPushPermission implements IRequestPushPermission {
  RequestPushPermission(this._repository);

  final IPushDeviceRepository _repository;

  @override
  Future<bool> call() => _repository.requestPermission();
}
