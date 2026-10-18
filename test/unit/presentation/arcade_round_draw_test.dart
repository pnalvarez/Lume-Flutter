import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/domain/models/game/knowledge_gallery_round.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';
import 'package:lume/layers/domain/usecases/get_knowledge_gallery_round.dart';
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

class _GetRandomGameRound implements IGetRandomGameRound {
  int calls = 0;

  @override
  Future<TrailGameDomain?> call({required List<String> enabledSlugs}) async {
    calls++;
    return _quiz;
  }
}

class _GetKnowledgeGalleryRound implements IGetKnowledgeGalleryRound {
  List<KnowledgeGalleryRound> rounds = const [];

  @override
  Future<List<KnowledgeGalleryRound>> call({
    int count = knowledgeGalleryRoundsPerMatch,
  }) async {
    return rounds;
  }
}

void main() {
  group('DrawArcadeRound', () {
    test(
      'falls through to a trail game when gallery is selected but empty',
      () async {
        final getRandom = _GetRandomGameRound();
        final getGallery = _GetKnowledgeGalleryRound();
        final draw = DrawArcadeRound(getRandom, getGallery);

        // Only the gallery slug → every roll selects Knowledge Gallery.
        final round = await draw(
          enabledSlugs: const [knowledgeGalleryGameSlug],
        );

        expect(round, isNotNull);
        expect(round!.game, _quiz);
        expect(round.gallery, isNull);
        expect(getRandom.calls, 1);
      },
    );
  });
}
