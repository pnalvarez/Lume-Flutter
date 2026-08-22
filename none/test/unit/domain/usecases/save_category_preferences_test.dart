import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/domain/models/category/category_domain.dart';
import 'package:lume/layers/domain/models/category/category_preferences_domain.dart';
import 'package:lume/layers/domain/usecases/save_category_preferences.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/mocks.mocks.dart';

void main() {
  test('delegates to category preference repository', () async {
    final repository = MockICategoryPreferenceRepository();
    final sut = SaveCategoryPreferences(repository);
    const expected = CategoryPreferencesDomain(
      categories: [CategoryDomain(id: 2, name: 'Science')],
      selectedIds: [2],
    );
    when(
      repository.saveCategoryPreferences(categoryIds: [2]),
    ).thenAnswer((_) async => expected);

    final result = await sut.call(categoryIds: [2]);

    expect(result, expected);
    verify(repository.saveCategoryPreferences(categoryIds: [2])).called(1);
  });
}
