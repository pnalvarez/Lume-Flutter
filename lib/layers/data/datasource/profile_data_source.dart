import 'package:injectable/injectable.dart';
import 'package:lume/core/auth/auth_service.dart';
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
  ProfileDataSource(this._apiClient, this._storage, this._auth);

  final IApiClient _apiClient;
  final IStorageClient _storage;
  final IAuthService _auth;

  @override
  Future<ProfileData> fetchProfile({bool forceRefresh = false}) async {
    ProfileData? data;
    if (!forceRefresh) {
      data = await _storage.readObject(CacheKeys.profile, ProfileData.fromJson);
    }

    if (data == null) {
      final raw = await _apiClient.rpc<Map<String, dynamic>>('get_profile');
      data = ProfileData.fromJson(asJsonMap(raw));
    }

    // `get_profile` often omits `created_at` even though `profiles.created_at`
    // exists. Fall back to the signed-in auth account creation timestamp so
    // Profile “Membro desde …” is not stuck on an em dash.
    data = _withAccountCreatedAtFallback(data);

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

  ProfileData _withAccountCreatedAtFallback(ProfileData data) {
    if (data.createdAt != null) return data;
    final fromAuth = _auth.currentSession?.createdAt;
    if (fromAuth == null) return data;
    return data.copyWith(createdAt: fromAuth);
  }
}
