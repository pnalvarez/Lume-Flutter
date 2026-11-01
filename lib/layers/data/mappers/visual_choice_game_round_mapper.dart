import 'package:lume/layers/data/models/visual_choice_game_round_data.dart';
import 'package:lume/layers/domain/models/game/visual_choice_game_round.dart';

abstract final class VisualChoiceGameRoundMapper {
  static VisualChoiceGameRound toDomain(VisualChoiceGameRoundData data) {
    return VisualChoiceGameRound(
      questionId: data.questionId,
      prompt: data.promptText,
      imageUrl: _imageUrl(data),
      questionType: data.questionType,
      options: _uniqueOptions(data.options),
      correctAnswer: data.correctAnswer,
      curiosity: data.curiosityFact,
      feedbackCorrect: data.feedbackCorrect,
      feedbackIncorrect: data.feedbackIncorrect,
    );
  }

  static VisualChoiceGameAnswerResult toAnswerDomain(
    VisualChoiceGameAnswerData data,
  ) {
    return VisualChoiceGameAnswerResult(
      correct: data.correct,
      correctAnswer: data.correctAnswer,
      feedback: data.feedback,
      curiosity: data.curiosity,
    );
  }

  /// Options must always be distinct: drop repeated labels (including a
  /// distractor equal to the correct answer), keeping the backend order.
  static List<String> _uniqueOptions(List<String> options) {
    final seen = <String>{};
    return [
      for (final option in options)
        if (seen.add(option)) option,
    ];
  }

  /// Prefer a question-specific override, then the artwork image.
  static String _imageUrl(VisualChoiceGameRoundData data) {
    final override = data.imageOverride?.trim();
    if (override != null && override.isNotEmpty) return override;
    return data.imageUrl.trim();
  }
}
