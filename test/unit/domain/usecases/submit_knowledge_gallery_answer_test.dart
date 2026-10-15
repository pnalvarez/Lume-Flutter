import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/domain/models/game/knowledge_gallery_round.dart';
import 'package:lume/layers/domain/repository/knowledge_gallery_repository.dart';
import 'package:lume/layers/domain/usecases/submit_knowledge_gallery_answer.dart';

class _Repository implements IKnowledgeGalleryRepository {
  int? questionId;
  String? answer;

  @override
  Future<List<KnowledgeGalleryRound>> getRounds({
    int count = knowledgeGalleryRoundsPerMatch,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<KnowledgeGalleryAnswerResult> submitAnswer({
    required int questionId,
    required String answer,
  }) async {
    this.questionId = questionId;
    this.answer = answer;
    return const KnowledgeGalleryAnswerResult(
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
    final sut = SubmitKnowledgeGalleryAnswer(repository);

    final result = await sut(questionId: 7, answer: 'Monet');

    expect(result.correct, isFalse);
    expect(result.feedback, 'Look at the brushwork.');
    expect(repository.questionId, 7);
    expect(repository.answer, 'Monet');
  });
}
