import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/domain/models/game/knowledge_gallery_round.dart';
import 'package:lume/layers/domain/repository/knowledge_gallery_repository.dart';
import 'package:lume/layers/domain/usecases/get_knowledge_gallery_round.dart';

class _Repository implements IKnowledgeGalleryRepository {
  _Repository(this.rounds);

  final List<KnowledgeGalleryRound> rounds;
  var getCalls = 0;

  @override
  Future<List<KnowledgeGalleryRound>> getRounds() async {
    getCalls++;
    return rounds;
  }

  @override
  Future<KnowledgeGalleryAnswerResult> submitAnswer({
    required int questionId,
    required String answer,
  }) {
    throw UnimplementedError();
  }
}

void main() {
  test('returns the repository rounds', () async {
    const round = KnowledgeGalleryRound(
      questionId: 7,
      prompt: 'Who painted this?',
      imageUrl: 'https://cdn.example/art.jpg',
      questionType: 'identify_artist',
      options: ['Van Gogh', 'Da Vinci', 'Picasso', 'Monet'],
      correctAnswer: 'Da Vinci',
    );
    final repository = _Repository(const [round]);
    final sut = GetKnowledgeGalleryRound(repository);

    final result = await sut();

    expect(result, [round]);
    expect(repository.getCalls, 1);
  });
}
