import 'package:lume/layers/domain/models/category/category_preferences_domain.dart';

abstract interface class ICategoryPreferenceRepository {
  Future<CategoryPreferencesDomain> getCategoriesWithPreferences({
    bool forceRefresh = false,
  });

  Future<CategoryPreferencesDomain> saveCategoryPreferences({
    required List<int> categoryIds,
  });
}
