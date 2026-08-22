import 'package:flutter/foundation.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';

@immutable
final class TimelineState {
  const TimelineState({
    this.game,
    this.selectedOptionId,
    this.answered = false,
    this.isCorrect = false,
    this.finished = false,
  });

  final TimelineGameDomain? game;
  final String? selectedOptionId;
  final bool answered;
  final bool isCorrect;
  final bool finished;

  TimelineState copyWith({
    TimelineGameDomain? game,
    String? selectedOptionId,
    bool? answered,
    bool? isCorrect,
    bool? finished,
  }) {
    return TimelineState(
      game: game ?? this.game,
      selectedOptionId: selectedOptionId ?? this.selectedOptionId,
      answered: answered ?? this.answered,
      isCorrect: isCorrect ?? this.isCorrect,
      finished: finished ?? this.finished,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is TimelineState &&
      other.game == game &&
      other.selectedOptionId == selectedOptionId &&
      other.answered == answered &&
      other.isCorrect == isCorrect &&
      other.finished == finished;

  @override
  int get hashCode =>
      Object.hash(game, selectedOptionId, answered, isCorrect, finished);
}
