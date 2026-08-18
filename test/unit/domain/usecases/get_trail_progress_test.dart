import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/domain/models/trail/trail_progress_domain.dart';
import 'package:lume/layers/domain/usecases/get_trail_progress.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/mocks.mocks.dart';

void main() {
  test('delegates to trail repository', () async {
    final repository = MockITrailRepository();
    final sut = GetTrailProgress(repository);
    const expected = TrailProgressDomain(
      pairProgress: [PairProgressDomain(pairId: 4, completed: true, scorePct: 80)],
    );
    when(repository.getProgress(forceRefresh: false)).thenAnswer((_) async => expected);

    final result = await sut.call();

    expect(result, expected);
    verify(repository.getProgress(forceRefresh: false)).called(1);
  });
}
