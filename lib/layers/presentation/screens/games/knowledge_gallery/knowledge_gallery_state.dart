import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:lume/layers/presentation/screens/games/shared/choice_option_visual.dart';
import 'package:lume_design_system/organisms/game/artwork_prompt_card.dart';
import 'package:lume_design_system/organisms/game/choice_group.dart';

/// One Knowledge Gallery round as the play surface should paint it.
@immutable
final class KnowledgeGalleryState {
  const KnowledgeGalleryState({
    required this.prompt,
    required this.imageUrl,
    required this.options,
    this.image,
    this.imagePhase,
    this.selectedOptionId,
    this.correctOptionId,
    this.answered = false,
    this.isCorrect = false,
    this.explanation,
  });

  final String prompt;
  final String imageUrl;

  /// Local stand-in used by Widgetbook. The play screen leaves this null.
  final ImageProvider? image;
  final ArtworkPromptImagePhase? imagePhase;

  /// Labels in display order. Do not sort.
  final List<String> options;

  /// Index in [options], as `'0'` … `'3'`.
  final String? selectedOptionId;
  final String? correctOptionId;
  final bool answered;
  final bool isCorrect;

  /// Feedback line shown after the answer, the same role as a trail explanation.
  final String? explanation;

  ChoiceVisualState visualStateFor(String optionId) {
    return choiceOptionVisualState(
      answered: answered,
      selectedOptionId: selectedOptionId,
      optionId: optionId,
      correctOptionId: correctOptionId ?? '',
    );
  }

  KnowledgeGalleryState copyWith({
    String? prompt,
    String? imageUrl,
    ImageProvider? image,
    ArtworkPromptImagePhase? imagePhase,
    List<String>? options,
    String? selectedOptionId,
    String? correctOptionId,
    bool? answered,
    bool? isCorrect,
    String? explanation,
  }) {
    return KnowledgeGalleryState(
      prompt: prompt ?? this.prompt,
      imageUrl: imageUrl ?? this.imageUrl,
      image: image ?? this.image,
      imagePhase: imagePhase ?? this.imagePhase,
      options: options ?? this.options,
      selectedOptionId: selectedOptionId ?? this.selectedOptionId,
      correctOptionId: correctOptionId ?? this.correctOptionId,
      answered: answered ?? this.answered,
      isCorrect: isCorrect ?? this.isCorrect,
      explanation: explanation ?? this.explanation,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is KnowledgeGalleryState &&
      other.prompt == prompt &&
      other.imageUrl == imageUrl &&
      other.image == image &&
      other.imagePhase == imagePhase &&
      listEquals(other.options, options) &&
      other.selectedOptionId == selectedOptionId &&
      other.correctOptionId == correctOptionId &&
      other.answered == answered &&
      other.isCorrect == isCorrect &&
      other.explanation == explanation;

  @override
  int get hashCode => Object.hash(
    prompt,
    imageUrl,
    image,
    imagePhase,
    Object.hashAll(options),
    selectedOptionId,
    correctOptionId,
    answered,
    isCorrect,
    explanation,
  );
}

/// Feedback copy for a revealed Knowledge Gallery answer.
///
/// Uses the correct line after a hit and the incorrect line after a miss.
String? knowledgeGalleryFeedback({
  required bool isCorrect,
  String? feedbackCorrect,
  String? feedbackIncorrect,
}) {
  final text = (isCorrect ? feedbackCorrect : feedbackIncorrect)?.trim();
  if (text == null || text.isEmpty) return null;
  return text;
}

/// Index of [answer] in [options], as `'0'`, `'1'`, and so on.
///
/// Null when [answer] is not listed.
String? knowledgeGalleryOptionId(List<String> options, String answer) {
  final index = options.indexOf(answer);
  if (index < 0) return null;
  return '$index';
}
