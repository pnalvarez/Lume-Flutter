import 'package:flutter/foundation.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';

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
    Object.hashAll(
      selections.entries.map((e) => Object.hash(e.key, e.value)),
    ),
    answered,
    isCorrect,
    finished,
  );
}
