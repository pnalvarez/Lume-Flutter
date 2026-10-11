import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/models/game/knowledge_gallery_round.dart';
import 'package:lume/layers/domain/repository/knowledge_gallery_repository.dart';

/// Records one Knowledge Gallery answer via `submit_visual_answer`.
///
/// Does not write trail pair progress.
abstract interface class ISubmitKnowledgeGalleryAnswer {
  Future<KnowledgeGalleryAnswerResult> call({
    required int questionId,
    required String answer,
  });
}

@Injectable(as: ISubmitKnowledgeGalleryAnswer)
class SubmitKnowledgeGalleryAnswer implements ISubmitKnowledgeGalleryAnswer {
  SubmitKnowledgeGalleryAnswer(this._repository);

  final IKnowledgeGalleryRepository _repository;

  @override
  Future<KnowledgeGalleryAnswerResult> call({
    required int questionId,
    required String answer,
  }) {
    return _repository.submitAnswer(questionId: questionId, answer: answer);
  }
}
