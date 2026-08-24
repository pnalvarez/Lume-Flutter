abstract final class MysteriousWordRules {
  const MysteriousWordRules._();

  static const maxWrong = 6;
}

final class MysteriousWordPlayState {
  const MysteriousWordPlayState({
    this.guessedLetters = const {},
    this.wrongCount = 0,
  });

  final Set<String> guessedLetters;
  final int wrongCount;

  MysteriousWordPlayState copyWith({
    Set<String>? guessedLetters,
    int? wrongCount,
  }) {
    return MysteriousWordPlayState(
      guessedLetters: guessedLetters ?? this.guessedLetters,
      wrongCount: wrongCount ?? this.wrongCount,
    );
  }
}

final class MysteriousWordPlayOutcome {
  const MysteriousWordPlayOutcome({
    required this.state,
    this.answered = false,
    this.isCorrect = false,
  });

  final MysteriousWordPlayState state;
  final bool answered;
  final bool isCorrect;
}
