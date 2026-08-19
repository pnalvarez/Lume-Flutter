import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/models/auth/auth_session.dart';
import 'package:lume/layers/domain/repository/auth_repository.dart';

abstract interface class ISignInWithEmail {
  Future<AuthSession> call({required String email, required String password});
}

@Injectable(as: ISignInWithEmail)
class SignInWithEmail implements ISignInWithEmail {
  SignInWithEmail(this._repository);

  final IAuthRepository _repository;

  @override
  Future<AuthSession> call({
    required String email,
    required String password,
  }) {
    return _repository.signIn(email: email, password: password);
  }
}
