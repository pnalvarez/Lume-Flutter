import 'package:lume/layers/domain/models/profile/profile_domain.dart';

abstract interface class IProfileRepository {
  Future<ProfileDomain> getProfile({bool forceRefresh = false});
}
