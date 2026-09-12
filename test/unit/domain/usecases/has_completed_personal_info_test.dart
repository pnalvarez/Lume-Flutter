import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/domain/models/profile/profile_domain.dart';
import 'package:lume/layers/domain/usecases/get_profile.dart';
import 'package:lume/layers/domain/usecases/has_completed_personal_info.dart';

class _GetProfile implements IGetProfile {
  _GetProfile(this.profile);

  final ProfileDomain profile;
  var forceRefreshCalls = 0;

  @override
  Future<ProfileDomain> call({bool forceRefresh = false}) async {
    if (forceRefresh) forceRefreshCalls += 1;
    return profile;
  }
}

void main() {
  test('returns true when full name and age are present', () async {
    final sut = HasCompletedPersonalInfo(
      _GetProfile(const ProfileDomain(id: '1', fullName: 'Ada Lovelace', age: 28)),
    );

    expect(await sut(forceRefresh: true), isTrue);
  });

  test('returns false when name is missing', () async {
    final sut = HasCompletedPersonalInfo(
      _GetProfile(const ProfileDomain(id: '1', age: 28)),
    );

    expect(await sut(), isFalse);
  });

  test('returns false when age is missing', () async {
    final sut = HasCompletedPersonalInfo(
      _GetProfile(const ProfileDomain(id: '1', fullName: 'Ada Lovelace')),
    );

    expect(await sut(), isFalse);
  });
}
