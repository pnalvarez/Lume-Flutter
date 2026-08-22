import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/repository/auth_repository.dart';

abstract interface class IUpdatePassword {
  Future<void> call({required String password});
}

@Injectable(as: IUpdatePassword)
class UpdatePassword implements IUpdatePassword {
  UpdatePassword(this._repository);

  final IAuthRepository _repository;

  @override
  Future<void> call({required String password}) {
    return _repository.updatePassword(password: password);
  }
}
