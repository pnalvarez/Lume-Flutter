final class WhoAmIPlayState {
  const WhoAmIPlayState({this.answer = '', this.hintsVisible = 1});

  final String answer;
  final int hintsVisible;

  WhoAmIPlayState copyWith({String? answer, int? hintsVisible}) {
    return WhoAmIPlayState(
      answer: answer ?? this.answer,
      hintsVisible: hintsVisible ?? this.hintsVisible,
    );
  }
}

final class WhoAmIPlayOutcome {
  const WhoAmIPlayOutcome({
    required this.state,
    this.answered = false,
    this.isCorrect = false,
  });

  final WhoAmIPlayState state;
  final bool answered;
  final bool isCorrect;
}
