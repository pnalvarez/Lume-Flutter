import 'package:lume/core/network/api_client.dart';
import 'package:lume/layers/data/json_map.dart';
import 'package:lume/layers/data/models/profile_data.dart';

abstract interface class ProfileDataSource {
  Future<ProfileData> fetchProfile();
}

final class RemoteProfileDataSource implements ProfileDataSource {
  RemoteProfileDataSource(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<ProfileData> fetchProfile() async {
    final raw = await _apiClient.rpc<Map<String, dynamic>>('get_profile');
    return ProfileData.fromJson(asJsonMap(raw));
  }
}
