import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/domain/models/profile/profile_domain.dart';
import 'package:lume/layers/domain/usecases/get_profile.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/mocks.mocks.dart';

void main() {
  test('delegates to profile repository', () async {
    final repository = MockIProfileRepository();
    final sut = GetProfile(repository);
    const expected = ProfileDomain(
      id: 'user-1',
      email: 'ada@example.com',
      fullName: 'Ada',
    );
    when(
      repository.getProfile(forceRefresh: false),
    ).thenAnswer((_) async => expected);

    final result = await sut.call();

    expect(result, expected);
    verify(repository.getProfile(forceRefresh: false)).called(1);
  });

  test('forwards forceRefresh to profile repository', () async {
    final repository = MockIProfileRepository();
    final sut = GetProfile(repository);
    const expected = ProfileDomain(id: 'user-1');
    when(
      repository.getProfile(forceRefresh: true),
    ).thenAnswer((_) async => expected);

    final result = await sut.call(forceRefresh: true);

    expect(result, expected);
    verify(repository.getProfile(forceRefresh: true)).called(1);
  });
}
