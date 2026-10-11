import 'package:lume/layers/data/json_map.dart';

/// One row from `get_visual_game_items`.
final class KnowledgeGalleryRoundData {
  const KnowledgeGalleryRoundData({
    required this.questionId,
    required this.promptText,
    required this.imageUrl,
    required this.imageOverride,
    required this.questionType,
    required this.options,
    required this.correctAnswer,
    required this.curiosityFact,
    required this.feedbackCorrect,
    required this.feedbackIncorrect,
  });

  factory KnowledgeGalleryRoundData.fromJson(Map<String, dynamic> json) {
    return KnowledgeGalleryRoundData(
      questionId: _requireInt(json, 'question_id'),
      promptText: _requireString(json, 'prompt_text'),
      imageUrl: _optionalString(json['image_url']) ?? '',
      imageOverride: _optionalString(json['image_override']),
      questionType: _requireString(json, 'question_type'),
      options: _optionLabels(json['options']),
      correctAnswer: _requireString(json, 'correct_answer'),
      curiosityFact: _optionalString(json['curiosity_fact']),
      feedbackCorrect: _optionalString(json['feedback_correct']),
      feedbackIncorrect: _optionalString(json['feedback_incorrect']),
    );
  }

  final int questionId;
  final String promptText;
  final String imageUrl;
  final String? imageOverride;
  final String questionType;

  /// Labels in payload order. The client must not sort this list.
  final List<String> options;
  final String correctAnswer;
  final String? curiosityFact;
  final String? feedbackCorrect;
  final String? feedbackIncorrect;
}

/// JSON body returned by `submit_visual_answer`.
final class KnowledgeGalleryAnswerData {
  const KnowledgeGalleryAnswerData({
    required this.correct,
    required this.correctAnswer,
    required this.feedback,
    required this.curiosity,
  });

  factory KnowledgeGalleryAnswerData.fromJson(Map<String, dynamic> json) {
    final error = json['error'];
    if (error != null) {
      throw FormatException('submit_visual_answer failed: $error');
    }
    final correct = json['correct'];
    if (correct is! bool) {
      throw FormatException('submit_visual_answer missing correct');
    }
    return KnowledgeGalleryAnswerData(
      correct: correct,
      correctAnswer: _optionalString(json['correct_answer']) ?? '',
      feedback: _optionalString(json['feedback']),
      curiosity: _optionalString(json['curiosity']),
    );
  }

  final bool correct;
  final String correctAnswer;
  final String? feedback;
  final String? curiosity;
}

List<String> _optionLabels(Object? raw) {
  if (raw is! List) {
    throw FormatException('Expected options array, got ${raw.runtimeType}');
  }
  return [for (final item in raw) _requireString(asJsonMap(item), 'text')];
}

int _requireInt(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is num) return value.toInt();
  throw FormatException('Expected number at $key');
}

String _requireString(Map<String, dynamic> json, String key) {
  final value = _optionalString(json[key]);
  if (value == null || value.isEmpty) {
    throw FormatException('Expected non-empty string at $key');
  }
  return value;
}

String? _optionalString(Object? value) {
  if (value == null) return null;
  if (value is String) return value;
  throw FormatException('Expected string, got ${value.runtimeType}');
}
