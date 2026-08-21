import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/domain/models/trail/trail_catalog_domain.dart';
import 'package:lume/layers/domain/usecases/get_trail_bootstrap.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/mocks.mocks.dart';

void main() {
  test('delegates to trail repository', () async {
    final repository = MockITrailRepository();
    final sut = GetTrailBootstrap(repository);
    final expected = TrailBootstrapDomain(
      trailStartedAt: DateTime.utc(2026, 8, 17),
      modules: const [
        ModuleDomain(
          id: 1,
          sortOrder: 1,
          title: 'History',
          emoji: '📜',
          color: '#111',
        ),
      ],
    );
    when(
      repository.getBootstrap(forceRefresh: false),
    ).thenAnswer((_) async => expected);

    final result = await sut.call();

    expect(result, expected);
    verify(repository.getBootstrap(forceRefresh: false)).called(1);
  });
}
