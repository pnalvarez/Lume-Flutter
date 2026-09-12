import 'package:injectable/injectable.dart';
import 'package:lume/core/network/api_client.dart';
import 'package:lume/core/storage/cache_keys.dart';
import 'package:lume/core/storage/storage_client.dart';
import 'package:lume/core/storage/storage_json.dart';
import 'package:lume/layers/data/json_map.dart';
import 'package:lume/layers/data/models/profile_data.dart';

abstract interface class IProfileDataSource {
  Future<ProfileData> fetchProfile({bool forceRefresh = false});

  Future<ProfileData> updatePersonalInfo({
    required String firstName,
    required String lastName,
    required int age,
  });
}

@Injectable(as: IProfileDataSource)
final class ProfileDataSource implements IProfileDataSource {
  ProfileDataSource(this._apiClient, this._storage);

  final IApiClient _apiClient;
  final IStorageClient _storage;

  @override
  Future<ProfileData> fetchProfile({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final cached = await _storage.readObject(
        CacheKeys.profile,
        ProfileData.fromJson,
      );
      if (cached != null) return cached;
    }

    final raw = await _apiClient.rpc<Map<String, dynamic>>('get_profile');
    final data = ProfileData.fromJson(asJsonMap(raw));
    await _storage.writeObject(
      CacheKeys.profile,
      data,
      (value) => value.toJson(),
    );
    return data;
  }

  @override
  Future<ProfileData> updatePersonalInfo({
    required String firstName,
    required String lastName,
    required int age,
  }) async {
    await _apiClient.rpc<Map<String, dynamic>>(
      'update_personal_info',
      params: {
        'p_first_name': firstName,
        'p_last_name': lastName,
        'p_age': age,
      },
    );
    // Refresh cached profile so gates and profile UI see the new values.
    return fetchProfile(forceRefresh: true);
  }
}
