import 'package:lume/layers/domain/repository/auth_repository.dart';

abstract interface class IClearPasswordRecovery {
  void call();
}

class ClearPasswordRecovery implements IClearPasswordRecovery {
  ClearPasswordRecovery(this._repository);

  final IAuthRepository _repository;

  @override
  void call() => _repository.clearPasswordRecovery();
}
