/// One visual question. [options] stay in `get_visual_game_items` order.
///
/// `period` is stored on the artwork and is not part of a match.
class VisualChoiceGameRound {
  const VisualChoiceGameRound({
    required this.questionId,
    required this.prompt,
    required this.imageUrl,
    required this.questionType,
    required this.options,
    required this.correctAnswer,
    this.curiosity,
    this.feedbackCorrect,
    this.feedbackIncorrect,
  });

  /// `visual_questions.id`, sent back to `submit_visual_answer`.
  final int questionId;
  final String prompt;
  final String imageUrl;
  final String questionType;
  final List<String> options;
  final String correctAnswer;
  final String? curiosity;
  final String? feedbackCorrect;
  final String? feedbackIncorrect;
}

/// Server result of one submitted visual-choice answer.
class VisualChoiceGameAnswerResult {
  const VisualChoiceGameAnswerResult({
    required this.correct,
    required this.correctAnswer,
    this.feedback,
    this.curiosity,
  });

  final bool correct;
  final String correctAnswer;
  final String? feedback;
  final String? curiosity;
}
