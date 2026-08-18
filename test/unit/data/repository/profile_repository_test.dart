import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/data/models/profile_data.dart';
import 'package:lume/layers/data/repository/profile_repository.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/mocks.mocks.dart';

void main() {
  late MockIProfileDataSource dataSource;
  late ProfileRepository sut;

  setUp(() {
    dataSource = MockIProfileDataSource();
    sut = ProfileRepository(dataSource);
  });

  test('getProfile maps ProfileData to ProfileDomain', () async {
    when(dataSource.fetchProfile(forceRefresh: false)).thenAnswer(
      (_) async => const ProfileData(
        id: 'user-1',
        email: 'ada@example.com',
        fullName: 'Ada',
      ),
    );

    final profile = await sut.getProfile();

    expect(profile.id, 'user-1');
    expect(profile.email, 'ada@example.com');
    expect(profile.fullName, 'Ada');
    verify(dataSource.fetchProfile(forceRefresh: false)).called(1);
  });
}
