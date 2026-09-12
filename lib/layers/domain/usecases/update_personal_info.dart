import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/models/profile/profile_domain.dart';
import 'package:lume/layers/domain/repository/profile_repository.dart';

abstract interface class IUpdatePersonalInfo {
  Future<ProfileDomain> call({
    required String firstName,
    required String lastName,
    required int age,
  });
}

@Injectable(as: IUpdatePersonalInfo)
class UpdatePersonalInfo implements IUpdatePersonalInfo {
  UpdatePersonalInfo(this._repository);

  final IProfileRepository _repository;

  @override
  Future<ProfileDomain> call({
    required String firstName,
    required String lastName,
    required int age,
  }) {
    return _repository.updatePersonalInfo(
      firstName: firstName,
      lastName: lastName,
      age: age,
    );
  }
}
