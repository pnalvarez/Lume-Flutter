import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/domain/models/category/category_domain.dart';
import 'package:lume/layers/domain/models/category/category_preferences_domain.dart';
import 'package:lume/layers/domain/usecases/get_categories_with_preferences.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/mocks.mocks.dart';

void main() {
  test('delegates to category preference repository', () async {
    final repository = MockICategoryPreferenceRepository();
    final sut = GetCategoriesWithPreferences(repository);
    const expected = CategoryPreferencesDomain(
      categories: [CategoryDomain(id: 1, name: 'History')],
      selectedIds: [1],
    );
    when(
      repository.getCategoriesWithPreferences(forceRefresh: false),
    ).thenAnswer((_) async => expected);

    final result = await sut.call();

    expect(result, expected);
    verify(repository.getCategoriesWithPreferences(forceRefresh: false)).called(1);
  });
}
