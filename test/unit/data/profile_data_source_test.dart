import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/data/datasource/profile_data_source.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/mocks.mocks.dart';

void main() {
  late MockApiClient apiClient;
  late RemoteProfileDataSource sut;

  setUp(() {
    apiClient = MockApiClient();
    sut = RemoteProfileDataSource(apiClient);
  });

  test('fetchProfile parses get_profile into ProfileData', () async {
    when(
      apiClient.rpc<Map<String, dynamic>>(
        'get_profile',
        params: anyNamed('params'),
        headers: anyNamed('headers'),
      ),
    ).thenAnswer((_) async => {
          'id': 'user-1',
          'full_name': 'Ada',
        });

    final data = await sut.fetchProfile();

    expect(data.id, 'user-1');
    expect(data.fullName, 'Ada');
    verify(apiClient.rpc<Map<String, dynamic>>('get_profile')).called(1);
  });
}
