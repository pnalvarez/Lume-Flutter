import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/common/strings/auth_strings.dart';
import 'package:lume/core/errors/api_exception.dart';
import 'package:lume/layers/domain/models/category/category_domain.dart';
import 'package:lume/layers/domain/models/category/category_preferences_domain.dart';
import 'package:lume/layers/domain/usecases/get_categories_with_preferences.dart';
import 'package:lume/layers/domain/usecases/save_category_preferences.dart';
import 'package:lume/layers/presentation/screens/select_category/select_category_bloc.dart';
import 'package:lume/layers/presentation/screens/select_category/select_category_event.dart';
import 'package:lume/layers/presentation/screens/select_category/select_category_state.dart';

class _GetCategories implements IGetCategoriesWithPreferences {
  CategoryPreferencesDomain result = const CategoryPreferencesDomain(
    categories: [
      CategoryDomain(id: 1, name: 'History'),
      CategoryDomain(id: 2, name: 'Art'),
    ],
  );
  Object? error;

  @override
  Future<CategoryPreferencesDomain> call({bool forceRefresh = false}) async {
    if (error != null) throw error!;
    return result;
  }
}

class _SaveCategories implements ISaveCategoryPreferences {
  List<int>? lastIds;
  Object? error;

  @override
  Future<CategoryPreferencesDomain> call({
    required List<int> categoryIds,
  }) async {
    if (error != null) throw error!;
    lastIds = categoryIds;
    return CategoryPreferencesDomain(
      categories: const [
        CategoryDomain(id: 1, name: 'History'),
        CategoryDomain(id: 2, name: 'Art'),
      ],
      selectedIds: categoryIds,
    );
  }
}

SelectCategoryBloc _bloc(_GetCategories get, _SaveCategories save) {
  return SelectCategoryBloc(get, save);
}

void main() {
  blocTest<SelectCategoryBloc, SelectCategoryState>(
    'loads categories on start',
    build: () => _bloc(_GetCategories(), _SaveCategories()),
    act: (bloc) => bloc.add(const SelectCategoryStarted()),
    expect: () => [
      isA<SelectCategoryState>().having(
        (s) => s.status,
        'status',
        SelectCategoryStatus.loading,
      ),
      isA<SelectCategoryState>()
          .having((s) => s.status, 'status', SelectCategoryStatus.ready)
          .having((s) => s.categories.length, 'count', 2),
    ],
  );

  blocTest<SelectCategoryBloc, SelectCategoryState>(
    'toggles selection and saves to home',
    build: () => _bloc(_GetCategories(), _SaveCategories()),
    act: (bloc) async {
      bloc.add(const SelectCategoryStarted());
      await bloc.stream.firstWhere(
        (s) => s.status == SelectCategoryStatus.ready,
      );
      bloc
        ..add(const SelectCategoryToggled(1))
        ..add(const SelectCategorySubmitted());
    },
    skip: 2,
    expect: () => [
      isA<SelectCategoryState>().having(
        (s) => s.selectedIds,
        'selected',
        {1},
      ),
      isA<SelectCategoryState>().having((s) => s.isSaving, 'saving', true),
      isA<SelectCategoryState>().having(
        (s) => s.destination,
        'destination',
        SelectCategoryDestination.home,
      ),
    ],
  );

  blocTest<SelectCategoryBloc, SelectCategoryState>(
    'expired session on save goes to login',
    build: () => _bloc(
      _GetCategories(),
      _SaveCategories()
        ..error = const ApiHttpException(statusCode: 401, message: 'unauthorized'),
    ),
    act: (bloc) async {
      bloc.add(const SelectCategoryStarted());
      await bloc.stream.firstWhere(
        (s) => s.status == SelectCategoryStatus.ready,
      );
      bloc
        ..add(const SelectCategoryToggled(1))
        ..add(const SelectCategorySubmitted());
    },
    skip: 3,
    expect: () => [
      isA<SelectCategoryState>().having((s) => s.isSaving, 'saving', true),
      isA<SelectCategoryState>()
          .having(
            (s) => s.destination,
            'destination',
            SelectCategoryDestination.login,
          )
          .having((s) => s.notice, 'notice', selectCategorySessionExpired),
    ],
  );
}
