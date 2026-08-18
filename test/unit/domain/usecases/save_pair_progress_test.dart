import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/domain/models/trail/trail_progress_domain.dart';
import 'package:lume/layers/domain/usecases/save_pair_progress.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/mocks.mocks.dart';

void main() {
  test('delegates to trail repository', () async {
    final repository = MockITrailRepository();
    final sut = SavePairProgress(repository);
    const expected = PairProgressDomain(
      pairId: 4,
      completed: true,
      scorePct: 80,
      previewSeen: true,
    );
    when(
      repository.savePairProgress(pairId: 4, scorePct: 80),
    ).thenAnswer((_) async => expected);

    final result = await sut.call(pairId: 4, scorePct: 80);

    expect(result, expected);
    verify(repository.savePairProgress(pairId: 4, scorePct: 80)).called(1);
  });
}
