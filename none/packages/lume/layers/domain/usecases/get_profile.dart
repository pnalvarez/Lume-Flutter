import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/models/profile/profile_domain.dart';
import 'package:lume/layers/domain/repository/profile_repository.dart';

abstract interface class IGetProfile {
  Future<ProfileDomain> call({bool forceRefresh = false});
}

@Injectable(as: IGetProfile)
class GetProfile implements IGetProfile {
  GetProfile(this._repository);

  final IProfileRepository _repository;

  @override
  Future<ProfileDomain> call({bool forceRefresh = false}) {
    return _repository.getProfile(forceRefresh: forceRefresh);
  }
}
