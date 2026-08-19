import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/repository/auth_repository.dart';

abstract interface class IRequestPasswordRecovery {
  Future<void> call({required String email});
}

@Injectable(as: IRequestPasswordRecovery)
class RequestPasswordRecovery implements IRequestPasswordRecovery {
  RequestPasswordRecovery(this._repository);

  final IAuthRepository _repository;

  @override
  Future<void> call({required String email}) {
    return _repository.requestPasswordRecovery(email: email);
  }
}
