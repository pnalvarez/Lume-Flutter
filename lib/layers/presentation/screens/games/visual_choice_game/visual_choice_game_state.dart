import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:lume/layers/presentation/screens/games/shared/choice_option_visual.dart';
import 'package:lume_design_system/organisms/game/artwork_prompt_card.dart';
import 'package:lume_design_system/organisms/game/choice_group.dart';

/// What the visual-choice round is showing.
enum VisualChoiceGamePhase {
  playing,
  submitting,
  correct,
  incorrect;

  bool get canSelect => this == VisualChoiceGamePhase.playing;

  bool get answered =>
      this == VisualChoiceGamePhase.correct ||
      this == VisualChoiceGamePhase.incorrect;

  bool get isCorrect => this == VisualChoiceGamePhase.correct;

  /// Maps the sequence flags onto one phase. A write in flight wins, so a
  /// round cannot be answered and submitting at the same time.
  static VisualChoiceGamePhase resolve({
    required bool submitting,
    required bool answered,
    required bool isCorrect,
  }) {
    if (submitting) return VisualChoiceGamePhase.submitting;
    if (!answered) return VisualChoiceGamePhase.playing;
    return isCorrect
        ? VisualChoiceGamePhase.correct
        : VisualChoiceGamePhase.incorrect;
  }
}

/// One visual-choice round as the play surface should paint it.
@immutable
final class VisualChoiceGameState {
  const VisualChoiceGameState({
    required this.prompt,
    required this.imageUrl,
    required this.options,
    this.image,
    this.imagePhase,
    this.selectedOptionId,
    this.correctOptionId,
    this.phase = VisualChoiceGamePhase.playing,
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
  final VisualChoiceGamePhase phase;

  /// Feedback line shown after the answer, the same role as a trail explanation.
  final String? explanation;

  /// A choice can be tapped. False while the write is in flight or the round
  /// is already answered, so the feedback dialog stays closed until the
  /// server responds.
  bool get canSelect => phase.canSelect;

  bool get submitting => phase == VisualChoiceGamePhase.submitting;

  bool get answered => phase.answered;

  bool get isCorrect => phase.isCorrect;

  ChoiceVisualState visualStateFor(String optionId) {
    if (submitting) {
      return selectedOptionId == optionId
          ? ChoiceVisualState.loading
          : ChoiceVisualState.disabled;
    }
    return choiceOptionVisualState(
      answered: answered,
      selectedOptionId: selectedOptionId,
      optionId: optionId,
      correctOptionId: correctOptionId ?? '',
    );
  }

  VisualChoiceGameState copyWith({
    String? prompt,
    String? imageUrl,
    ImageProvider? image,
    ArtworkPromptImagePhase? imagePhase,
    List<String>? options,
    String? selectedOptionId,
    String? correctOptionId,
    VisualChoiceGamePhase? phase,
    String? explanation,
  }) {
    return VisualChoiceGameState(
      prompt: prompt ?? this.prompt,
      imageUrl: imageUrl ?? this.imageUrl,
      image: image ?? this.image,
      imagePhase: imagePhase ?? this.imagePhase,
      options: options ?? this.options,
      selectedOptionId: selectedOptionId ?? this.selectedOptionId,
      correctOptionId: correctOptionId ?? this.correctOptionId,
      phase: phase ?? this.phase,
      explanation: explanation ?? this.explanation,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is VisualChoiceGameState &&
      other.prompt == prompt &&
      other.imageUrl == imageUrl &&
      other.image == image &&
      other.imagePhase == imagePhase &&
      listEquals(other.options, options) &&
      other.selectedOptionId == selectedOptionId &&
      other.correctOptionId == correctOptionId &&
      other.phase == phase &&
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
    phase,
    explanation,
  );
}

/// Feedback copy for a revealed visual-choice answer.
///
/// Uses the correct line after a hit and the incorrect line after a miss.
String? visualChoiceGameFeedback({
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
String? visualChoiceGameOptionId(List<String> options, String answer) {
  final index = options.indexOf(answer);
  if (index < 0) return null;
  return '$index';
}
