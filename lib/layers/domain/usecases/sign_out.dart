import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/repository/auth_repository.dart';
import 'package:lume/layers/domain/repository/push_device_repository.dart';

abstract interface class ISignOut {
  Future<void> call();
}

@Injectable(as: ISignOut)
class SignOut implements ISignOut {
  SignOut(this._repository, this._pushDevices);

  final IAuthRepository _repository;
  final IPushDeviceRepository _pushDevices;

  @override
  Future<void> call() async {
    // Must run before the session ends (RLS needs the JWT). Never blocks logout.
    try {
      await _pushDevices.unregisterCurrentDevice();
    } on Object {
      // Best effort: a stale token is pruned server-side when FCM rejects it.
    }
    await _repository.signOut();
  }
}
