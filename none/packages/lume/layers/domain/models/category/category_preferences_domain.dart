import 'package:lume/layers/domain/models/category/category_domain.dart';

/// Category catalog with the user's current selections.
class CategoryPreferencesDomain {
  const CategoryPreferencesDomain({
    this.categories = const [],
    this.selectedIds = const [],
  });

  final List<CategoryDomain> categories;
  final List<int> selectedIds;
}
