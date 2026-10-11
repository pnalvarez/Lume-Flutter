import 'package:lume/layers/data/models/knowledge_gallery_round_data.dart';
import 'package:lume/layers/domain/models/game/knowledge_gallery_round.dart';

abstract final class KnowledgeGalleryRoundMapper {
  static KnowledgeGalleryRound toDomain(KnowledgeGalleryRoundData data) {
    return KnowledgeGalleryRound(
      questionId: data.questionId,
      prompt: data.promptText,
      imageUrl: _imageUrl(data),
      questionType: data.questionType,
      options: List<String>.of(data.options),
      correctAnswer: data.correctAnswer,
      curiosity: data.curiosityFact,
      feedbackCorrect: data.feedbackCorrect,
      feedbackIncorrect: data.feedbackIncorrect,
    );
  }

  static KnowledgeGalleryAnswerResult toAnswerDomain(
    KnowledgeGalleryAnswerData data,
  ) {
    return KnowledgeGalleryAnswerResult(
      correct: data.correct,
      correctAnswer: data.correctAnswer,
      feedback: data.feedback,
      curiosity: data.curiosity,
    );
  }

  /// Prefer a question-specific override, then the artwork image.
  static String _imageUrl(KnowledgeGalleryRoundData data) {
    final override = data.imageOverride?.trim();
    if (override != null && override.isNotEmpty) return override;
    return data.imageUrl.trim();
  }
}
