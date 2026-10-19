import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/domain/models/game/visual_choice_game_config.dart';
import 'package:lume/layers/domain/models/game/visual_choice_game_round.dart';
import 'package:lume/layers/domain/repository/visual_choice_game_repository.dart';
import 'package:lume/layers/domain/usecases/submit_visual_choice_game_answer.dart';

class _Repository implements IVisualChoiceGameRepository {
  int? questionId;
  String? answer;

  @override
  Future<List<VisualChoiceGameRound>> getRounds({
    required String gameSlug,
    int count = visualChoiceGameRoundsPerMatch,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<VisualChoiceGameAnswerResult> submitAnswer({
    required int questionId,
    required String answer,
  }) async {
    this.questionId = questionId;
    this.answer = answer;
    return const VisualChoiceGameAnswerResult(
      correct: false,
      correctAnswer: 'Da Vinci',
      feedback: 'Look at the brushwork.',
      curiosity: 'It hung in a hallway.',
    );
  }
}

void main() {
  test('delegates the answer to the repository', () async {
    final repository = _Repository();
    final sut = SubmitVisualChoiceGameAnswer(repository);

    final result = await sut(questionId: 7, answer: 'Monet');

    expect(result.correct, isFalse);
    expect(result.feedback, 'Look at the brushwork.');
    expect(repository.questionId, 7);
    expect(repository.answer, 'Monet');
  });
}
