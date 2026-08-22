import 'package:injectable/injectable.dart';
import 'package:lume/layers/data/datasource/category_preference_data_source.dart';
import 'package:lume/layers/data/mappers/category_mapper.dart';
import 'package:lume/layers/domain/models/category/category_preferences_domain.dart';
import 'package:lume/layers/domain/repository/category_preference_repository.dart';

@Injectable(as: ICategoryPreferenceRepository)
final class CategoryPreferenceRepository
    implements ICategoryPreferenceRepository {
  CategoryPreferenceRepository(this._dataSource);

  final ICategoryPreferenceDataSource _dataSource;

  @override
  Future<CategoryPreferencesDomain> getCategoriesWithPreferences({
    bool forceRefresh = false,
  }) async {
    final data = await _dataSource.fetchCategoriesWithPreferences(
      forceRefresh: forceRefresh,
    );
    return CategoryMapper.toPreferencesDomain(data);
  }

  @override
  Future<CategoryPreferencesDomain> saveCategoryPreferences({
    required List<int> categoryIds,
  }) async {
    final data = await _dataSource.saveCategoryPreferences(
      categoryIds: categoryIds,
    );
    return CategoryMapper.toPreferencesDomain(data);
  }
}
