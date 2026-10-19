import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/domain/models/game/visual_choice_game_config.dart';
import 'package:lume/layers/domain/models/game/visual_choice_game_round.dart';
import 'package:lume/layers/domain/repository/visual_choice_game_repository.dart';
import 'package:lume/layers/domain/usecases/get_visual_choice_game_round.dart';

class _Repository implements IVisualChoiceGameRepository {
  _Repository(this.rounds);

  final List<VisualChoiceGameRound> rounds;
  var getCalls = 0;

  int? count;
  String? gameSlug;

  @override
  Future<List<VisualChoiceGameRound>> getRounds({
    required String gameSlug,
    int count = visualChoiceGameRoundsPerMatch,
  }) async {
    getCalls++;
    this.gameSlug = gameSlug;
    this.count = count;
    return rounds;
  }

  @override
  Future<VisualChoiceGameAnswerResult> submitAnswer({
    required int questionId,
    required String answer,
  }) {
    throw UnimplementedError();
  }
}

void main() {
  test('returns the repository rounds for the given slug', () async {
    const round = VisualChoiceGameRound(
      questionId: 7,
      prompt: 'Who painted this?',
      imageUrl: 'https://cdn.example/art.jpg',
      questionType: 'identify_artist',
      options: ['Van Gogh', 'Da Vinci', 'Picasso', 'Monet'],
      correctAnswer: 'Da Vinci',
    );
    final repository = _Repository(const [round]);
    final sut = GetVisualChoiceGameRound(repository);

    final result = await sut(gameSlug: VisualChoiceGameSlugs.knowledgeGallery);

    expect(result, [round]);
    expect(repository.getCalls, 1);
    expect(repository.gameSlug, VisualChoiceGameSlugs.knowledgeGallery);
    expect(repository.count, visualChoiceGameRoundsPerMatch);
  });

  test('forwards a smaller count and another visual slug', () async {
    final repository = _Repository(const []);
    final sut = GetVisualChoiceGameRound(repository);

    await sut(gameSlug: VisualChoiceGameSlugs.facesOfHistory, count: 1);

    expect(repository.gameSlug, VisualChoiceGameSlugs.facesOfHistory);
    expect(repository.count, 1);
  });
}
