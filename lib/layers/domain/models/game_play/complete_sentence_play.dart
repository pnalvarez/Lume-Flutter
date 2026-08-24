final class CompleteSentencePlayState {
  const CompleteSentencePlayState({this.selections = const {}});

  final Map<int, String> selections;

  CompleteSentencePlayState copyWith({Map<int, String>? selections}) {
    return CompleteSentencePlayState(selections: selections ?? this.selections);
  }
}

final class CompleteSentencePlayOutcome {
  const CompleteSentencePlayOutcome({
    required this.state,
    this.answered = false,
    this.isCorrect = false,
  });

  final CompleteSentencePlayState state;
  final bool answered;
  final bool isCorrect;
}
