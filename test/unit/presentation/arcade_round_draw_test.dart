import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/domain/models/game/visual_choice_game_config.dart';
import 'package:lume/layers/domain/models/game/visual_choice_game_round.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';
import 'package:lume/layers/domain/usecases/get_visual_choice_game_round.dart';
import 'package:lume/layers/domain/usecases/get_random_game_round.dart';
import 'package:lume/layers/presentation/screens/games/arcade_round_draw.dart';

const _quiz = LightningQuizGameDomain(
  pairId: 11,
  sortOrder: 2,
  prompt: 'Q2',
  options: ['a', 'b'],
  correctIndex: 1,
  explanation: 'e2',
);

const _visualRound = VisualChoiceGameRound(
  questionId: 9,
  prompt: 'Quem é esta pessoa?',
  imageUrl: 'https://cdn.example/portrait.jpg',
  questionType: 'identify_person',
  options: ['A', 'B'],
  correctAnswer: 'A',
);

class _GetRandomGameRound implements IGetRandomGameRound {
  int calls = 0;
  final enabledSlugs = <List<String>>[];

  @override
  Future<TrailGameDomain?> call({required List<String> enabledSlugs}) async {
    calls++;
    this.enabledSlugs.add(enabledSlugs);
    return _quiz;
  }
}

class _GetVisualChoiceGameRound implements IGetVisualChoiceGameRound {
  List<VisualChoiceGameRound> rounds = const [];
  final slugs = <String>[];
  final counts = <int>[];

  @override
  Future<List<VisualChoiceGameRound>> call({
    required String gameSlug,
    int count = visualChoiceGameRoundsPerMatch,
  }) async {
    slugs.add(gameSlug);
    counts.add(count);
    return rounds;
  }
}

void main() {
  group('DrawArcadeRound', () {
    test(
      'falls through to a trail game when visual is selected but empty',
      () async {
        final getRandom = _GetRandomGameRound();
        final getVisual = _GetVisualChoiceGameRound();
        final draw = DrawArcadeRound(getRandom, getVisual);

        // Only the Galeria slug → every roll selects the visual game.
        final round = await draw(
          enabledSlugs: const [VisualChoiceGameSlugs.facesOfHistory],
        );

        expect(round, isNotNull);
        expect(round!.game, _quiz);
        expect(round.visual, isNull);
        expect(getRandom.calls, 1);
        expect(getRandom.enabledSlugs, [<String>[]]);
      },
    );

    test('draws a visual round carrying its config for rostos slug', () async {
      final getRandom = _GetRandomGameRound();
      final getVisual = _GetVisualChoiceGameRound()
        ..rounds = const [_visualRound];
      final draw = DrawArcadeRound(getRandom, getVisual);

      final round = await draw(
        enabledSlugs: const [VisualChoiceGameSlugs.facesOfHistory],
      );

      expect(round, isNotNull);
      expect(round!.visual, _visualRound);
      expect(
        round.visualConfig?.gameSlug,
        VisualChoiceGameSlugs.facesOfHistory,
      );
      expect(round.visualGameSlug, VisualChoiceGameSlugs.facesOfHistory);
      expect(getVisual.slugs, [VisualChoiceGameSlugs.facesOfHistory]);
      expect(getVisual.counts, [1]);
      expect(getRandom.calls, 0);
    });
  });
}
