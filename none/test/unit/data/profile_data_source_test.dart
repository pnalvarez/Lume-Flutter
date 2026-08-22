import 'package:flutter_test/flutter_test.dart';
import 'package:lume/core/storage/in_memory_storage_client.dart';
import 'package:lume/layers/data/datasource/profile_data_source.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/mocks.mocks.dart';

void main() {
  late MockIApiClient apiClient;
  late InMemoryStorageClient storage;
  late ProfileDataSource sut;

  setUp(() {
    apiClient = MockIApiClient();
    storage = InMemoryStorageClient();
    sut = ProfileDataSource(apiClient, storage);
  });

  test('fetchProfile parses get_profile into ProfileData', () async {
    when(
      apiClient.rpc<Map<String, dynamic>>(
        'get_profile',
        params: anyNamed('params'),
        headers: anyNamed('headers'),
      ),
    ).thenAnswer((_) async => {'id': 'user-1', 'full_name': 'Ada'});

    final data = await sut.fetchProfile();

    expect(data.id, 'user-1');
    expect(data.fullName, 'Ada');
    verify(apiClient.rpc<Map<String, dynamic>>('get_profile')).called(1);
  });

  test(
    'fetchProfile returns cached profile without calling RPC again',
    () async {
      when(
        apiClient.rpc<Map<String, dynamic>>(
          'get_profile',
          params: anyNamed('params'),
          headers: anyNamed('headers'),
        ),
      ).thenAnswer((_) async => {'id': 'user-1', 'full_name': 'Ada'});

      await sut.fetchProfile();
      final cached = await sut.fetchProfile();

      expect(cached.fullName, 'Ada');
      verify(apiClient.rpc<Map<String, dynamic>>('get_profile')).called(1);
    },
  );
}
