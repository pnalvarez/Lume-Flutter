import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/domain/helpers/answer_match.dart';
import 'package:lume/layers/domain/helpers/trail_progress_calculator.dart';
import 'package:lume/layers/domain/models/game/game_trail_domain.dart';
import 'package:lume/layers/domain/models/trail/trail_progress_domain.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';

void main() {
  group('AnswerMatch', () {
    test('accepts accent and case variants', () {
      expect(AnswerMatch.isCorrect('escravos', 'Escravizados'), isTrue);
      expect(AnswerMatch.isCorrect('paris', 'Paris'), isTrue);
    });

    test('rejects unrelated answers', () {
      expect(AnswerMatch.isCorrect('banana', 'Paris'), isFalse);
    });
  });

  group('TrailProgressCalculator', () {
    final trail = GameTrailDomain(
      id: 1,
      title: 'História',
      sortOrder: 1,
      levels: [
        GameTrailLevelDomain(
          id: 10,
          title: 'Nível 1',
          sortOrder: 1,
          submodules: [
            GameTrailSubmoduleDomain(
              id: 100,
              title: 'Sub A',
              sortOrder: 1,
              games: const [
                LightningQuizGameDomain(
                  pairId: 1,
                  sortOrder: 1,
                  prompt: 'q',
                  options: ['a'],
                  correctIndex: 0,
                  explanation: '',
                ),
                LightningQuizGameDomain(
                  pairId: 2,
                  sortOrder: 2,
                  prompt: 'q2',
                  options: ['a'],
                  correctIndex: 0,
                  explanation: '',
                ),
              ],
            ),
            const GameTrailSubmoduleDomain(
              id: 101,
              title: 'Sub B',
              sortOrder: 2,
            ),
          ],
        ),
      ],
    );

    test('requires all pairs for submodule completion', () {
      final completed = TrailProgressCalculator.completedPairIds(const [
        PairProgressDomain(pairId: 1, completed: true),
      ]);
      expect(
        TrailProgressCalculator.isSubmoduleCompleted(
          submodule: trail.levels.first.submodules.first,
          completedPairs: completed,
        ),
        isFalse,
      );

      final all = TrailProgressCalculator.completedPairIds(const [
        PairProgressDomain(pairId: 1, completed: true),
        PairProgressDomain(pairId: 2, completed: true),
      ]);
      expect(
        TrailProgressCalculator.isSubmoduleCompleted(
          submodule: trail.levels.first.submodules.first,
          completedPairs: all,
        ),
        isTrue,
      );
    });

    test('counts trail percent from completed submodules', () {
      final pairs = TrailProgressCalculator.completedPairIds(const [
        PairProgressDomain(pairId: 1, completed: true),
        PairProgressDomain(pairId: 2, completed: true),
      ]);
      expect(
        TrailProgressCalculator.completedSubmoduleCount(
          trail: trail,
          completedPairs: pairs,
        ),
        1,
      );
      expect(
        TrailProgressCalculator.progressPercent(
          trail: trail,
          completedPairs: pairs,
        ),
        50,
      );
    });

    test('locks later submodules until the previous one is completed', () {
      expect(
        TrailProgressCalculator.lockedSubmoduleIds(
          trail: trail,
          completedPairs: const {},
        ),
        {101},
      );

      final firstDone = TrailProgressCalculator.completedPairIds(const [
        PairProgressDomain(pairId: 1, completed: true),
        PairProgressDomain(pairId: 2, completed: true),
      ]);
      expect(
        TrailProgressCalculator.lockedSubmoduleIds(
          trail: trail,
          completedPairs: firstDone,
        ),
        isEmpty,
      );
    });
  });
}
