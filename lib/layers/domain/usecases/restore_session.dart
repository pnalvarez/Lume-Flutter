import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/models/auth/auth_session.dart';
import 'package:lume/layers/domain/repository/auth_repository.dart';

abstract interface class IRestoreSession {
  Future<AuthSession?> call();
}

@Injectable(as: IRestoreSession)
class RestoreSession implements IRestoreSession {
  RestoreSession(this._repository);

  final IAuthRepository _repository;

  @override
  Future<AuthSession?> call() => _repository.restore();
}
