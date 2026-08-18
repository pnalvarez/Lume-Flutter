import 'package:injectable/injectable.dart';
import 'package:lume/core/network/api_client.dart';
import 'package:lume/core/storage/cache_keys.dart';
import 'package:lume/core/storage/storage_client.dart';
import 'package:lume/core/storage/storage_json.dart';
import 'package:lume/layers/data/json_map.dart';
import 'package:lume/layers/data/models/category_data.dart';

abstract interface class ICategoryPreferenceDataSource {
  Future<CategoryPreferencesData> fetchCategoriesWithPreferences({
    bool forceRefresh = false,
  });

  Future<CategoryPreferencesData> saveCategoryPreferences({
    required List<int> categoryIds,
  });
}

@Injectable(as: ICategoryPreferenceDataSource)
final class CategoryPreferenceDataSource implements ICategoryPreferenceDataSource {
  CategoryPreferenceDataSource(this._apiClient, this._storage);

  final IApiClient _apiClient;
  final IStorageClient _storage;

  @override
  Future<CategoryPreferencesData> fetchCategoriesWithPreferences({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh) {
      final cached = await _storage.readObject(
        CacheKeys.categoryPreferences,
        CategoryPreferencesData.fromJson,
      );
      if (cached != null) return cached;
    }

    final raw = await _apiClient.rpc<Map<String, dynamic>>(
      'get_categories_with_preferences',
    );
    final data = CategoryPreferencesData.fromJson(asJsonMap(raw));
    await _storage.writeObject(
      CacheKeys.categoryPreferences,
      data,
      (value) => value.toJson(),
    );
    return data;
  }

  @override
  Future<CategoryPreferencesData> saveCategoryPreferences({
    required List<int> categoryIds,
  }) async {
    final raw = await _apiClient.rpc<Map<String, dynamic>>(
      'save_category_preferences',
      params: {'p_category_ids': categoryIds},
    );
    final data = CategoryPreferencesData.fromJson(asJsonMap(raw));
    await _storage.writeObject(
      CacheKeys.categoryPreferences,
      data,
      (value) => value.toJson(),
    );
    return data;
  }
}
