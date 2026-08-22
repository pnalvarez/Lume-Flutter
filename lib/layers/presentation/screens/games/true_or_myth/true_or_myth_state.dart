import 'package:flutter/foundation.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';
import 'package:lume/layers/presentation/screens/games/shared/choice_option_visual.dart';
import 'package:lume_design_system/organisms/game/choice_group.dart';

@immutable
final class TrueOrMythState {
  const TrueOrMythState({
    this.game,
    this.selectedOptionId,
    this.answered = false,
    this.isCorrect = false,
    this.finished = false,
  });

  final TrueOrMythGameDomain? game;
  final String? selectedOptionId;
  final bool answered;
  final bool isCorrect;
  final bool finished;

  ChoiceVisualState visualStateFor(String optionId) {
    final current = game;
    if (current == null) return ChoiceVisualState.disabled;
    return choiceOptionVisualState(
      answered: answered,
      selectedOptionId: selectedOptionId,
      optionId: optionId,
      correctOptionId: current.verdict.wireValue,
    );
  }

  TrueOrMythState copyWith({
    TrueOrMythGameDomain? game,
    String? selectedOptionId,
    bool? answered,
    bool? isCorrect,
    bool? finished,
  }) {
    return TrueOrMythState(
      game: game ?? this.game,
      selectedOptionId: selectedOptionId ?? this.selectedOptionId,
      answered: answered ?? this.answered,
      isCorrect: isCorrect ?? this.isCorrect,
      finished: finished ?? this.finished,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is TrueOrMythState &&
      other.game == game &&
      other.selectedOptionId == selectedOptionId &&
      other.answered == answered &&
      other.isCorrect == isCorrect &&
      other.finished == finished;

  @override
  int get hashCode =>
      Object.hash(game, selectedOptionId, answered, isCorrect, finished);
}
