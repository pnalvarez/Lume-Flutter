import 'package:flutter/foundation.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game_values.dart';
import 'package:lume/layers/presentation/screens/games/shared/choice_option_visual.dart';
import 'package:lume_design_system/organisms/game/choice_group.dart';

@immutable
final class CompleteSentenceState {
  const CompleteSentenceState({
    this.game,
    this.selections = const {},
    this.answered = false,
    this.isCorrect = false,
    this.finished = false,
  });

  final CompleteSentenceGameDomain? game;
  final Map<int, String> selections;
  final bool answered;
  final bool isCorrect;
  final bool finished;

  List<SentenceBlankDomain> get sortedBlanks {
    final blanks = [...?game?.blanks];
    blanks.sort((a, b) => a.order.compareTo(b.order));
    return blanks;
  }

  bool get allBlanksSelected {
    final blanks = game?.blanks;
    if (blanks == null || blanks.isEmpty) return false;
    return blanks.every((blank) => selections.containsKey(blank.order));
  }

  ChoiceVisualState blankOptionState({
    required int blankOrder,
    required String option,
    required String correct,
  }) {
    return choiceOptionVisualState(
      answered: answered,
      selectedOptionId: selections[blankOrder],
      optionId: option,
      correctOptionId: correct,
    );
  }

  CompleteSentenceState copyWith({
    CompleteSentenceGameDomain? game,
    Map<int, String>? selections,
    bool? answered,
    bool? isCorrect,
    bool? finished,
  }) {
    return CompleteSentenceState(
      game: game ?? this.game,
      selections: selections ?? this.selections,
      answered: answered ?? this.answered,
      isCorrect: isCorrect ?? this.isCorrect,
      finished: finished ?? this.finished,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is CompleteSentenceState &&
      other.game == game &&
      mapEquals(other.selections, selections) &&
      other.answered == answered &&
      other.isCorrect == isCorrect &&
      other.finished == finished;

  @override
  int get hashCode => Object.hash(
    game,
    Object.hashAll(selections.entries.map((e) => Object.hash(e.key, e.value))),
    answered,
    isCorrect,
    finished,
  );
}
