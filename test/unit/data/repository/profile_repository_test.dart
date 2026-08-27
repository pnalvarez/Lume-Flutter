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
        playerLevel: 3,
        totalXp: 341,
        currentStreak: 2,
        bestStreak: 5,
        xpToday: 10,
        xpWeek: 341,
        daysInApp: 12,
        submodulesCompleted: 4,
      ),
    );

    final profile = await sut.getProfile();

    expect(profile.id, 'user-1');
    expect(profile.email, 'ada@example.com');
    expect(profile.fullName, 'Ada');
    expect(profile.playerLevel, 3);
    expect(profile.totalXp, 341);
    expect(profile.currentStreak, 2);
    expect(profile.bestStreak, 5);
    expect(profile.xpToday, 10);
    expect(profile.xpWeek, 341);
    expect(profile.daysInApp, 12);
    expect(profile.submodulesCompleted, 4);
    verify(dataSource.fetchProfile(forceRefresh: false)).called(1);
  });
}
