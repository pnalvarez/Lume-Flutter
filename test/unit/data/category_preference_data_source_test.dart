import 'package:flutter_test/flutter_test.dart';
import 'package:lume/core/storage/in_memory_storage_client.dart';
import 'package:lume/layers/data/datasource/category_preference_data_source.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/mocks.mocks.dart';

void main() {
  late MockIApiClient apiClient;
  late InMemoryStorageClient storage;
  late CategoryPreferenceDataSource sut;

  setUp(() {
    apiClient = MockIApiClient();
    storage = InMemoryStorageClient();
    sut = CategoryPreferenceDataSource(apiClient, storage);
  });

  test('fetchCategoriesWithPreferences parses English category JSON', () async {
    when(
      apiClient.rpc<Map<String, dynamic>>(
        'get_categories_with_preferences',
        params: anyNamed('params'),
        headers: anyNamed('headers'),
      ),
    ).thenAnswer(
      (_) async => {
        'categories': [
          {'id': 1, 'name': 'History'},
        ],
        'selected_ids': [1],
      },
    );

    final data = await sut.fetchCategoriesWithPreferences();

    expect(data.selectedIds, [1]);
    expect(data.categories.first.name, 'History');
    verify(
      apiClient.rpc<Map<String, dynamic>>('get_categories_with_preferences'),
    ).called(1);
  });

  test('saveCategoryPreferences posts p_category_ids', () async {
    when(
      apiClient.rpc<Map<String, dynamic>>(
        'save_category_preferences',
        params: anyNamed('params'),
        headers: anyNamed('headers'),
      ),
    ).thenAnswer(
      (_) async => {
        'selected_ids': [2, 3],
      },
    );

    final data = await sut.saveCategoryPreferences(categoryIds: const [2, 3]);

    expect(data.selectedIds, [2, 3]);
    verify(
      apiClient.rpc<Map<String, dynamic>>(
        'save_category_preferences',
        params: {
          'p_category_ids': [2, 3],
        },
      ),
    ).called(1);
  });
}
