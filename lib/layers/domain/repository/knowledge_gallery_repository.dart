import 'package:lume/layers/domain/models/game/knowledge_gallery_round.dart';

/// Knowledge Gallery rounds and answers.
///
/// Rounds come from `get_visual_game_items`. Answers go to
/// `submit_visual_answer`. Match open and close stay on the hub use cases
/// with [knowledgeGalleryGameSlug].
abstract interface class IKnowledgeGalleryRepository {
  Future<List<KnowledgeGalleryRound>> getRounds();

  Future<KnowledgeGalleryAnswerResult> submitAnswer({
    required int questionId,
    required String answer,
  });
}
