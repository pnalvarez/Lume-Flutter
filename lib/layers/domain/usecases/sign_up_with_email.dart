import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/models/auth/auth_sign_up_result.dart';
import 'package:lume/layers/domain/repository/auth_repository.dart';

abstract interface class ISignUpWithEmail {
  Future<AuthSignUpResult> call({
    required String email,
    required String password,
  });
}

@Injectable(as: ISignUpWithEmail)
class SignUpWithEmail implements ISignUpWithEmail {
  SignUpWithEmail(this._repository);

  final IAuthRepository _repository;

  @override
  Future<AuthSignUpResult> call({
    required String email,
    required String password,
  }) {
    return _repository.signUp(email: email, password: password);
  }
}
