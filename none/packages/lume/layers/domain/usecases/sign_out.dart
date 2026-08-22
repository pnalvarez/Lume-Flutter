import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/repository/auth_repository.dart';

abstract interface class ISignOut {
  Future<void> call();
}

@Injectable(as: ISignOut)
class SignOut implements ISignOut {
  SignOut(this._repository);

  final IAuthRepository _repository;

  @override
  Future<void> call() => _repository.signOut();
}
