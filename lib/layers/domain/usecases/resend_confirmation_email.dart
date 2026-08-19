import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/repository/auth_repository.dart';

abstract interface class IResendConfirmationEmail {
  Future<void> call({required String email});
}

@Injectable(as: IResendConfirmationEmail)
class ResendConfirmationEmail implements IResendConfirmationEmail {
  ResendConfirmationEmail(this._repository);

  final IAuthRepository _repository;

  @override
  Future<void> call({required String email}) {
    return _repository.resendConfirmationEmail(email: email);
  }
}
