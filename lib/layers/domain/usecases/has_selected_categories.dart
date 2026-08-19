import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/usecases/get_categories_with_preferences.dart';

abstract interface class IHasSelectedCategories {
  Future<bool> call({bool forceRefresh = false});
}

@Injectable(as: IHasSelectedCategories)
class HasSelectedCategories implements IHasSelectedCategories {
  HasSelectedCategories(this._getPreferences);

  final IGetCategoriesWithPreferences _getPreferences;

  @override
  Future<bool> call({bool forceRefresh = false}) async {
    final preferences = await _getPreferences(forceRefresh: forceRefresh);
    return preferences.selectedIds.isNotEmpty;
  }
}
