import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/models/auth/auth_session.dart';
import 'package:lume/layers/domain/repository/auth_repository.dart';

abstract interface class IObserveAuthState {
  Stream<AuthSession?> call();
}

@Injectable(as: IObserveAuthState)
class ObserveAuthState implements IObserveAuthState {
  ObserveAuthState(this._repository);

  final IAuthRepository _repository;

  @override
  Stream<AuthSession?> call() async* {
    yield _repository.currentSession;
    yield* _repository.observe();
  }
}
