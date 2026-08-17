import 'package:lume/core/network/api_client.dart';
import 'package:lume/layers/data/json_map.dart';
import 'package:lume/layers/data/models/category_data.dart';

abstract interface class CategoryPreferenceDataSource {
  Future<CategoryPreferencesData> fetchCategoriesWithPreferences();

  Future<CategoryPreferencesData> saveCategoryPreferences({
    required List<int> categoryIds,
  });
}

final class RemoteCategoryPreferenceDataSource
    implements CategoryPreferenceDataSource {
  RemoteCategoryPreferenceDataSource(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<CategoryPreferencesData> fetchCategoriesWithPreferences() async {
    final raw = await _apiClient.rpc<Map<String, dynamic>>(
      'get_categories_with_preferences',
    );
    return CategoryPreferencesData.fromJson(asJsonMap(raw));
  }

  @override
  Future<CategoryPreferencesData> saveCategoryPreferences({
    required List<int> categoryIds,
  }) async {
    final raw = await _apiClient.rpc<Map<String, dynamic>>(
      'save_category_preferences',
      params: {'p_category_ids': categoryIds},
    );
    return CategoryPreferencesData.fromJson(asJsonMap(raw));
  }
}
