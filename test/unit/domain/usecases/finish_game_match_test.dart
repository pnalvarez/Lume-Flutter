import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/domain/models/game/finished_game_match_domain.dart';
import 'package:lume/layers/domain/usecases/finish_game_match.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/mocks.mocks.dart';

void main() {
  test('delegates to game repository', () async {
    final repository = MockIGameRepository();
    final sut = FinishGameMatch(repository);
    when(
      repository.finishGameMatch(
        matchId: 'match-1',
        score: 80,
        correctCount: 4,
        totalQuestions: 5,
        durationSeconds: 12,
        metadata: const {'zero_hint_streak': 3},
      ),
    ).thenAnswer((_) async => const FinishedGameMatchDomain(xpEarned: 9));

    final result = await sut.call(
      matchId: 'match-1',
      score: 80,
      correctCount: 4,
      totalQuestions: 5,
      durationSeconds: 12,
      metadata: const {'zero_hint_streak': 3},
    );

    expect(result.xpEarned, 9);
    verify(
      repository.finishGameMatch(
        matchId: 'match-1',
        score: 80,
        correctCount: 4,
        totalQuestions: 5,
        durationSeconds: 12,
        metadata: const {'zero_hint_streak': 3},
      ),
    ).called(1);
  });
}
