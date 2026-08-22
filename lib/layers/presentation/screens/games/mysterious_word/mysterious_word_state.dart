import 'package:flutter/foundation.dart';
import 'package:lume/layers/domain/helpers/answer_match.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';

enum MysteriousLetterVisual { idle, correct, missed }

@immutable
final class MysteriousWordState {
  const MysteriousWordState({
    this.game,
    this.guessedLetters = const {},
    this.wrongCount = 0,
    this.answered = false,
    this.isCorrect = false,
    this.finished = false,
  });

  static const maxWrong = 6;
  static const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  final MysteriousWordGameDomain? game;
  final Set<String> guessedLetters;
  final int wrongCount;
  final bool answered;
  final bool isCorrect;
  final bool finished;

  /// Uppercase A–Z letters only, accents stripped.
  String get normalizedWord {
    final raw = game?.word ?? '';
    return AnswerMatch.normalizeText(
      raw,
    ).toUpperCase().replaceAll(RegExp('[^A-Z]'), '');
  }

  String get maskedWord {
    final word = normalizedWord;
    if (word.isEmpty) return '';
    return word
        .split('')
        .map((ch) => guessedLetters.contains(ch) ? ch : '_')
        .join(' ');
  }

  int get livesLeft => maxWrong - wrongCount;

  bool get lettersEnabled => !answered;

  MysteriousLetterVisual letterVisual(String letter) {
    if (!guessedLetters.contains(letter)) return MysteriousLetterVisual.idle;
    if (normalizedWord.contains(letter)) return MysteriousLetterVisual.correct;
    return MysteriousLetterVisual.missed;
  }

  MysteriousWordState copyWith({
    MysteriousWordGameDomain? game,
    Set<String>? guessedLetters,
    int? wrongCount,
    bool? answered,
    bool? isCorrect,
    bool? finished,
  }) {
    return MysteriousWordState(
      game: game ?? this.game,
      guessedLetters: guessedLetters ?? this.guessedLetters,
      wrongCount: wrongCount ?? this.wrongCount,
      answered: answered ?? this.answered,
      isCorrect: isCorrect ?? this.isCorrect,
      finished: finished ?? this.finished,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is MysteriousWordState &&
      other.game == game &&
      setEquals(other.guessedLetters, guessedLetters) &&
      other.wrongCount == wrongCount &&
      other.answered == answered &&
      other.isCorrect == isCorrect &&
      other.finished == finished;

  @override
  int get hashCode => Object.hash(
    game,
    Object.hashAll(guessedLetters),
    wrongCount,
    answered,
    isCorrect,
    finished,
  );
}
