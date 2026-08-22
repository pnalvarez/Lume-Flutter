import 'package:flutter/foundation.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';

@immutable
final class WhoAmIState {
  const WhoAmIState({
    this.game,
    this.answer = '',
    this.hintsVisible = 1,
    this.answered = false,
    this.isCorrect = false,
    this.finished = false,
  });

  final WhoAmIGameDomain? game;
  final String answer;
  final int hintsVisible;
  final bool answered;
  final bool isCorrect;
  final bool finished;

  List<String> get visibleHints {
    final hints = game?.hints;
    if (hints == null) return const [];
    return hints.take(hintsVisible).toList();
  }

  bool get canRevealMore {
    final hints = game?.hints;
    if (hints == null || answered) return false;
    return hintsVisible < hints.length;
  }

  bool get canSubmit => !answered && answer.trim().isNotEmpty;

  WhoAmIState copyWith({
    WhoAmIGameDomain? game,
    String? answer,
    int? hintsVisible,
    bool? answered,
    bool? isCorrect,
    bool? finished,
  }) {
    return WhoAmIState(
      game: game ?? this.game,
      answer: answer ?? this.answer,
      hintsVisible: hintsVisible ?? this.hintsVisible,
      answered: answered ?? this.answered,
      isCorrect: isCorrect ?? this.isCorrect,
      finished: finished ?? this.finished,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is WhoAmIState &&
      other.game == game &&
      other.answer == answer &&
      other.hintsVisible == hintsVisible &&
      other.answered == answered &&
      other.isCorrect == isCorrect &&
      other.finished == finished;

  @override
  int get hashCode =>
      Object.hash(game, answer, hintsVisible, answered, isCorrect, finished);
}
