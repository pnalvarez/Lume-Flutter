import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/domain/models/category/category_domain.dart';
import 'package:lume/layers/domain/models/category/category_preferences_domain.dart';
import 'package:lume/layers/domain/usecases/has_selected_categories.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/mocks.mocks.dart';

void main() {
  test('is true when selectedIds is not empty', () async {
    final getPreferences = MockIGetCategoriesWithPreferences();
    final sut = HasSelectedCategories(getPreferences);
    when(getPreferences.call()).thenAnswer(
      (_) async => const CategoryPreferencesDomain(
        categories: [CategoryDomain(id: 1, name: 'History')],
        selectedIds: [1],
      ),
    );

    expect(await sut.call(), isTrue);
  });

  test('is false when no categories are selected', () async {
    final getPreferences = MockIGetCategoriesWithPreferences();
    final sut = HasSelectedCategories(getPreferences);
    when(
      getPreferences.call(),
    ).thenAnswer((_) async => const CategoryPreferencesDomain());

    expect(await sut.call(), isFalse);
  });
}
