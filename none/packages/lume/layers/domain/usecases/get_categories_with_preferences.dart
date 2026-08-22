import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/models/category/category_preferences_domain.dart';
import 'package:lume/layers/domain/repository/category_preference_repository.dart';

abstract interface class IGetCategoriesWithPreferences {
  Future<CategoryPreferencesDomain> call({bool forceRefresh = false});
}

@Injectable(as: IGetCategoriesWithPreferences)
class GetCategoriesWithPreferences implements IGetCategoriesWithPreferences {
  GetCategoriesWithPreferences(this._repository);

  final ICategoryPreferenceRepository _repository;

  @override
  Future<CategoryPreferencesDomain> call({bool forceRefresh = false}) {
    return _repository.getCategoriesWithPreferences(forceRefresh: forceRefresh);
  }
}
