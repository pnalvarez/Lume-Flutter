import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/data/models/category_data.dart';
import 'package:lume/layers/data/repository/category_preference_repository.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/mocks.mocks.dart';

void main() {
  late MockICategoryPreferenceDataSource dataSource;
  late CategoryPreferenceRepository sut;

  setUp(() {
    dataSource = MockICategoryPreferenceDataSource();
    sut = CategoryPreferenceRepository(dataSource);
  });

  test('getCategoriesWithPreferences maps to CategoryPreferencesDomain', () async {
    when(
      dataSource.fetchCategoriesWithPreferences(forceRefresh: false),
    ).thenAnswer(
      (_) async => CategoryPreferencesData.fromJson({
        'categories': [
          {'id': 1, 'name': 'History'},
        ],
        'selected_ids': [1],
      }),
    );

    final domain = await sut.getCategoriesWithPreferences();

    expect(domain.categories.single.name, 'History');
    expect(domain.selectedIds, [1]);
  });
}
