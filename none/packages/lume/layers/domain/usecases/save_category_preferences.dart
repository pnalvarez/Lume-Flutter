import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/models/category/category_preferences_domain.dart';
import 'package:lume/layers/domain/repository/category_preference_repository.dart';

abstract interface class ISaveCategoryPreferences {
  Future<CategoryPreferencesDomain> call({required List<int> categoryIds});
}

@Injectable(as: ISaveCategoryPreferences)
class SaveCategoryPreferences implements ISaveCategoryPreferences {
  SaveCategoryPreferences(this._repository);

  final ICategoryPreferenceRepository _repository;

  @override
  Future<CategoryPreferencesDomain> call({required List<int> categoryIds}) {
    return _repository.saveCategoryPreferences(categoryIds: categoryIds);
  }
}
