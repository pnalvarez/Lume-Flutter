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

    test('requires every pair attempted before completion', () {
      final scores = TrailProgressCalculator.pairScoresById(const [
        PairProgressDomain(pairId: 1, scorePct: 100),
      ]);
      expect(
        TrailProgressCalculator.isSubmoduleCompleted(
          submodule: trail.levels.first.submodules.first,
          pairScores: scores,
        ),
        isFalse,
      );
    });

    test('completes when average score is at least 60%', () {
      // 1 correct + 1 miss = 50% → not enough
      final half = TrailProgressCalculator.pairScoresById(const [
        PairProgressDomain(pairId: 1, scorePct: 100),
        PairProgressDomain(pairId: 2, scorePct: 0),
      ]);
      expect(
        TrailProgressCalculator.isSubmoduleCompleted(
          submodule: trail.levels.first.submodules.first,
          pairScores: half,
        ),
        isFalse,
      );

      // Both correct = 100%
      final all = TrailProgressCalculator.pairScoresById(const [
        PairProgressDomain(pairId: 1, scorePct: 100),
        PairProgressDomain(pairId: 2, scorePct: 100),
      ]);
      expect(
        TrailProgressCalculator.isSubmoduleCompleted(
          submodule: trail.levels.first.submodules.first,
          pairScores: all,
        ),
        isTrue,
      );
    });

    test('completes with mixed scores when average reaches 60%', () {
      final fourGameSub = GameTrailSubmoduleDomain(
        id: 200,
        title: 'Sub C',
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
            prompt: 'q',
            options: ['a'],
            correctIndex: 0,
            explanation: '',
          ),
          LightningQuizGameDomain(
            pairId: 3,
            sortOrder: 3,
            prompt: 'q',
            options: ['a'],
            correctIndex: 0,
            explanation: '',
          ),
          LightningQuizGameDomain(
            pairId: 4,
            sortOrder: 4,
            prompt: 'q',
            options: ['a'],
            correctIndex: 0,
            explanation: '',
          ),
        ],
      );

      // 3/4 correct = 75% ≥ 60%
      final scores = TrailProgressCalculator.pairScoresById(const [
        PairProgressDomain(pairId: 1, scorePct: 100),
        PairProgressDomain(pairId: 2, scorePct: 100),
        PairProgressDomain(pairId: 3, scorePct: 100),
        PairProgressDomain(pairId: 4, scorePct: 0),
      ]);
      expect(
        TrailProgressCalculator.isSubmoduleCompleted(
          submodule: fourGameSub,
          pairScores: scores,
        ),
        isTrue,
      );
    });

    test('counts trail percent from completed submodules', () {
      final scores = TrailProgressCalculator.pairScoresById(const [
        PairProgressDomain(pairId: 1, scorePct: 100),
        PairProgressDomain(pairId: 2, scorePct: 100),
      ]);
      expect(
        TrailProgressCalculator.completedSubmoduleCount(
          trail: trail,
          pairScores: scores,
        ),
        1,
      );
      expect(
        TrailProgressCalculator.progressPercent(
          trail: trail,
          pairScores: scores,
        ),
        50,
      );
    });

    test('minCorrectCount matches 60% ceiling for binary scores', () {
      expect(TrailProgressCalculator.minCorrectCount(4), 3);
      expect(TrailProgressCalculator.minCorrectCount(2), 2);
      expect(TrailProgressCalculator.minCorrectCount(5), 3);
      expect(
        TrailProgressCalculator.meetsPassAverage(correctCount: 3, total: 4),
        isTrue,
      );
      expect(
        TrailProgressCalculator.meetsPassAverage(correctCount: 2, total: 4),
        isFalse,
      );
    });

    test('marks fully attempted below 60% as failed', () {
      final submodule = trail.levels.first.submodules.first;
      final failed = TrailProgressCalculator.pairScoresById(const [
        PairProgressDomain(pairId: 1, scorePct: 100),
        PairProgressDomain(pairId: 2, scorePct: 0),
      ]);
      expect(
        TrailProgressCalculator.isSubmoduleFullyAttempted(
          submodule: submodule,
          pairScores: failed,
        ),
        isTrue,
      );
      expect(
        TrailProgressCalculator.isSubmoduleFailed(
          submodule: submodule,
          pairScores: failed,
        ),
        isTrue,
      );
      expect(
        TrailProgressCalculator.isSubmoduleFailed(
          submodule: submodule,
          pairScores: TrailProgressCalculator.pairScoresById(const [
            PairProgressDomain(pairId: 1, scorePct: 100),
          ]),
        ),
        isFalse,
      );
    });

    test('locks later submodules until the previous one is completed', () {
      expect(
        TrailProgressCalculator.lockedSubmoduleIds(
          trail: trail,
          pairScores: const {},
        ),
        {101},
      );

      final firstDone = TrailProgressCalculator.pairScoresById(const [
        PairProgressDomain(pairId: 1, scorePct: 100),
        PairProgressDomain(pairId: 2, scorePct: 100),
      ]);
      expect(
        TrailProgressCalculator.lockedSubmoduleIds(
          trail: trail,
          pairScores: firstDone,
        ),
        isEmpty,
      );
    });
  });
}
