import 'package:lume/layers/data/models/category_data.dart';
import 'package:lume/layers/domain/models/category/category_domain.dart';
import 'package:lume/layers/domain/models/category/category_preferences_domain.dart';

abstract final class CategoryMapper {
  const CategoryMapper._();

  static CategoryDomain toDomain(CategoryData data) {
    return CategoryDomain(id: data.id, name: data.name);
  }

  static CategoryPreferencesDomain toPreferencesDomain(
    CategoryPreferencesData data,
  ) {
    return CategoryPreferencesDomain(
      categories: [for (final category in data.categories) toDomain(category)],
      selectedIds: List<int>.from(data.selectedIds),
    );
  }
}
