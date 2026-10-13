import 'package:flutter/foundation.dart';
import 'package:lume/layers/domain/models/game/knowledge_gallery_round.dart';
import 'package:lume/layers/presentation/screens/games/knowledge_gallery/knowledge_gallery_state.dart';

/// Five-question hub session. The painted round is [view].
@immutable
final class KnowledgeGalleryPlayState {
  const KnowledgeGalleryPlayState({
    this.rounds = const [],
    this.matchId = '',
    this.index = 0,
    this.correctCount = 0,
    this.selectedOptionId,
    this.revealedCorrectAnswer,
    this.answered = false,
    this.isCorrect = false,
    this.submitting = false,
    this.goBack = false,
    this.sequenceCompleted = false,
    this.snackMessage,
  });

  final List<KnowledgeGalleryRound> rounds;
  final String matchId;
  final int index;
  final int correctCount;
  final String? selectedOptionId;
  final String? revealedCorrectAnswer;
  final bool answered;
  final bool isCorrect;
  final bool submitting;
  final bool goBack;

  /// The five questions are finished and the score screen should stay up.
  final bool sequenceCompleted;
  final String? snackMessage;

  KnowledgeGalleryRound? get current {
    if (index < 0 || index >= rounds.length) return null;
    return rounds[index];
  }

  /// Progress in [0.0, 1.0] for the questions already left behind.
  double get progress {
    if (rounds.isEmpty) return 0;
    return (index / rounds.length).clamp(0.0, 1.0);
  }

  bool get hasProgress => answered || index > 0;

  KnowledgeGalleryState? get view {
    final round = current;
    if (round == null) return null;
    String? correctOptionId;
    if (answered) {
      correctOptionId = knowledgeGalleryOptionId(
        round.options,
        revealedCorrectAnswer ?? round.correctAnswer,
      );
      if (correctOptionId == null && isCorrect) {
        correctOptionId = selectedOptionId;
      }
    }
    return KnowledgeGalleryState(
      prompt: round.prompt,
      imageUrl: round.imageUrl,
      options: round.options,
      selectedOptionId: selectedOptionId,
      correctOptionId: correctOptionId,
      answered: answered,
      isCorrect: isCorrect,
      explanation: answered
          ? knowledgeGalleryFeedback(
              isCorrect: isCorrect,
              feedbackCorrect: round.feedbackCorrect,
              feedbackIncorrect: round.feedbackIncorrect,
            )
          : null,
    );
  }

  KnowledgeGalleryPlayState copyWith({
    List<KnowledgeGalleryRound>? rounds,
    String? matchId,
    int? index,
    int? correctCount,
    String? selectedOptionId,
    String? revealedCorrectAnswer,
    bool? answered,
    bool? isCorrect,
    bool? submitting,
    bool? goBack,
    bool? sequenceCompleted,
    String? snackMessage,
    bool clearAnswer = false,
    bool clearSnack = false,
  }) {
    return KnowledgeGalleryPlayState(
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
      answered: clearAnswer ? false : answered ?? this.answered,
      isCorrect: clearAnswer ? false : isCorrect ?? this.isCorrect,
      submitting: submitting ?? this.submitting,
      goBack: goBack ?? this.goBack,
      sequenceCompleted: sequenceCompleted ?? this.sequenceCompleted,
      snackMessage: clearSnack ? null : snackMessage ?? this.snackMessage,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is KnowledgeGalleryPlayState &&
      listEquals(other.rounds, rounds) &&
      other.matchId == matchId &&
      other.index == index &&
      other.correctCount == correctCount &&
      other.selectedOptionId == selectedOptionId &&
      other.revealedCorrectAnswer == revealedCorrectAnswer &&
      other.answered == answered &&
      other.isCorrect == isCorrect &&
      other.submitting == submitting &&
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
    answered,
    isCorrect,
    submitting,
    goBack,
    sequenceCompleted,
    snackMessage,
  );
}
