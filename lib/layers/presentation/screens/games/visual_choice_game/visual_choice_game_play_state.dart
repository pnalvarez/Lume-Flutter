import 'package:flutter/foundation.dart';
import 'package:lume/layers/domain/models/game/visual_choice_game_round.dart';
import 'package:lume/layers/presentation/screens/games/visual_choice_game/visual_choice_game_state.dart';

/// Five-question hub session. The painted round is [view].
@immutable
final class VisualChoiceGamePlayState {
  const VisualChoiceGamePlayState({
    this.rounds = const [],
    this.matchId = '',
    this.index = 0,
    this.correctCount = 0,
    this.selectedOptionId,
    this.revealedCorrectAnswer,
    this.phase = VisualChoiceGamePhase.playing,
    this.goBack = false,
    this.sequenceCompleted = false,
    this.snackMessage,
  });

  final List<VisualChoiceGameRound> rounds;
  final String matchId;
  final int index;
  final int correctCount;
  final String? selectedOptionId;
  final String? revealedCorrectAnswer;
  final VisualChoiceGamePhase phase;
  final bool goBack;

  /// The five questions are finished and the score screen should stay up.
  final bool sequenceCompleted;
  final String? snackMessage;

  VisualChoiceGameRound? get current {
    if (index < 0 || index >= rounds.length) return null;
    return rounds[index];
  }

  /// Progress in [0.0, 1.0] for the questions already left behind.
  double get progress {
    if (rounds.isEmpty) return 0;
    return (index / rounds.length).clamp(0.0, 1.0);
  }

  bool get canSelect => phase.canSelect;

  bool get submitting => phase == VisualChoiceGamePhase.submitting;

  bool get answered => phase.answered;

  bool get isCorrect => phase.isCorrect;

  bool get hasProgress => answered || index > 0;

  VisualChoiceGameState? get view {
    final round = current;
    if (round == null) return null;
    String? correctOptionId;
    if (answered) {
      correctOptionId = visualChoiceGameOptionId(
        round.options,
        revealedCorrectAnswer ?? round.correctAnswer,
      );
      if (correctOptionId == null && isCorrect) {
        correctOptionId = selectedOptionId;
      }
    }
    return VisualChoiceGameState(
      prompt: round.prompt,
      imageUrl: round.imageUrl,
      options: round.options,
      selectedOptionId: selectedOptionId,
      correctOptionId: correctOptionId,
      phase: phase,
      explanation: answered
          ? visualChoiceGameFeedback(
              isCorrect: isCorrect,
              feedbackCorrect: round.feedbackCorrect,
              feedbackIncorrect: round.feedbackIncorrect,
            )
          : null,
    );
  }

  VisualChoiceGamePlayState copyWith({
    List<VisualChoiceGameRound>? rounds,
    String? matchId,
    int? index,
    int? correctCount,
    String? selectedOptionId,
    String? revealedCorrectAnswer,
    VisualChoiceGamePhase? phase,
    bool? goBack,
    bool? sequenceCompleted,
    String? snackMessage,
    bool clearAnswer = false,
    bool clearSnack = false,
  }) {
    return VisualChoiceGamePlayState(
      rounds: rounds ?? this.rounds,
      matchId: matchId ?? this.matchId,
      index: index ?? this.index,
      correctCount: correctCount ?? this.correctCount,
      selectedOptionId: clearAnswer
          ? null
          : selectedOptionId ?? this.selectedOptionId,
      revealedCorrectAnswer: clearAnswer
          ? null
          : revealedCorrectAnswer ?? this.revealedCorrectAnswer,
      phase: clearAnswer ? VisualChoiceGamePhase.playing : phase ?? this.phase,
      goBack: goBack ?? this.goBack,
      sequenceCompleted: sequenceCompleted ?? this.sequenceCompleted,
      snackMessage: clearSnack ? null : snackMessage ?? this.snackMessage,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is VisualChoiceGamePlayState &&
      listEquals(other.rounds, rounds) &&
      other.matchId == matchId &&
      other.index == index &&
      other.correctCount == correctCount &&
      other.selectedOptionId == selectedOptionId &&
      other.revealedCorrectAnswer == revealedCorrectAnswer &&
      other.phase == phase &&
      other.goBack == goBack &&
      other.sequenceCompleted == sequenceCompleted &&
      other.snackMessage == snackMessage;

  @override
  int get hashCode => Object.hash(
    Object.hashAll(rounds),
    matchId,
    index,
    correctCount,
    selectedOptionId,
    revealedCorrectAnswer,
    phase,
    goBack,
    sequenceCompleted,
    snackMessage,
  );
}
