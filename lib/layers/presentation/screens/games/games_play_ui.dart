import 'package:flutter/foundation.dart';

/// Choice-based games: lightning quiz, timeline, true/myth, battle.
@immutable
final class GamesChoiceUi {
  const GamesChoiceUi({this.selectedOptionId});

  final String? selectedOptionId;

  GamesChoiceUi copyWith({
    String? selectedOptionId,
    bool clearSelectedOptionId = false,
  }) {
    return GamesChoiceUi(
      selectedOptionId: clearSelectedOptionId
          ? null
          : (selectedOptionId ?? this.selectedOptionId),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is GamesChoiceUi && other.selectedOptionId == selectedOptionId;

  @override
  int get hashCode => selectedOptionId.hashCode;
}

@immutable
final class GamesWhoAmIUi {
  const GamesWhoAmIUi({this.answer = '', this.hintsVisible = 1});

  final String answer;
  final int hintsVisible;

  GamesWhoAmIUi copyWith({String? answer, int? hintsVisible}) {
    return GamesWhoAmIUi(
      answer: answer ?? this.answer,
      hintsVisible: hintsVisible ?? this.hintsVisible,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is GamesWhoAmIUi &&
      other.answer == answer &&
      other.hintsVisible == hintsVisible;

  @override
  int get hashCode => Object.hash(answer, hintsVisible);
}

@immutable
final class GamesCompleteSentenceUi {
  const GamesCompleteSentenceUi({this.selections = const {}});

  final Map<int, String> selections;

  GamesCompleteSentenceUi copyWith({Map<int, String>? selections}) {
    return GamesCompleteSentenceUi(selections: selections ?? this.selections);
  }

  @override
  bool operator ==(Object other) =>
      other is GamesCompleteSentenceUi &&
      mapEquals(other.selections, selections);

  @override
  int get hashCode => Object.hashAll(
    selections.entries.map((e) => Object.hash(e.key, e.value)),
  );
}

@immutable
final class GamesConnectionsUi {
  const GamesConnectionsUi({
    this.selectedLeftId,
    this.links = const {},
    this.linkOrder = const [],
  });

  final String? selectedLeftId;
  final Map<String, String> links;
  final List<String> linkOrder;

  GamesConnectionsUi copyWith({
    String? selectedLeftId,
    bool clearSelectedLeft = false,
    Map<String, String>? links,
    List<String>? linkOrder,
  }) {
    return GamesConnectionsUi(
      selectedLeftId: clearSelectedLeft
          ? null
          : (selectedLeftId ?? this.selectedLeftId),
      links: links ?? this.links,
      linkOrder: linkOrder ?? this.linkOrder,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is GamesConnectionsUi &&
      other.selectedLeftId == selectedLeftId &&
      mapEquals(other.links, links) &&
      listEquals(other.linkOrder, linkOrder);

  @override
  int get hashCode => Object.hash(
    selectedLeftId,
    Object.hashAll(links.entries.map((e) => Object.hash(e.key, e.value))),
    Object.hashAll(linkOrder),
  );
}

@immutable
final class GamesMysteriousWordUi {
  const GamesMysteriousWordUi({
    this.guessedLetters = const {},
    this.wrongCount = 0,
  });

  final Set<String> guessedLetters;
  final int wrongCount;

  GamesMysteriousWordUi copyWith({
    Set<String>? guessedLetters,
    int? wrongCount,
  }) {
    return GamesMysteriousWordUi(
      guessedLetters: guessedLetters ?? this.guessedLetters,
      wrongCount: wrongCount ?? this.wrongCount,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is GamesMysteriousWordUi &&
      setEquals(other.guessedLetters, guessedLetters) &&
      other.wrongCount == wrongCount;

  @override
  int get hashCode => Object.hash(Object.hashAll(guessedLetters), wrongCount);
}
