import 'package:injectable/injectable.dart';
import 'package:lume/layers/data/datasource/profile_data_source.dart';
import 'package:lume/layers/data/mappers/profile_mapper.dart';
import 'package:lume/layers/domain/models/profile/profile_domain.dart';
import 'package:lume/layers/domain/repository/profile_repository.dart';

@Injectable(as: IProfileRepository)
final class ProfileRepository implements IProfileRepository {
  ProfileRepository(this._dataSource);

  final IProfileDataSource _dataSource;

  @override
  Future<ProfileDomain> getProfile({bool forceRefresh = false}) async {
    final data = await _dataSource.fetchProfile(forceRefresh: forceRefresh);
    return ProfileMapper.toDomain(data);
  }
}
