import 'package:flutter/foundation.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';
import 'package:lume/layers/presentation/screens/games/battle_of_curiosities/battle_of_curiosities_state.dart';
import 'package:lume/layers/presentation/screens/games/complete_sentence/complete_sentence_state.dart';
import 'package:lume/layers/presentation/screens/games/connections/connections_state.dart';
import 'package:lume/layers/presentation/screens/games/game_round.dart';
import 'package:lume/layers/presentation/screens/games/games_play_ui.dart';
import 'package:lume/layers/presentation/screens/games/lightning_quiz/lightning_quiz_state.dart';
import 'package:lume/layers/presentation/screens/games/mysterious_word/mysterious_word_state.dart';
import 'package:lume/layers/presentation/screens/games/timeline/timeline_state.dart';
import 'package:lume/layers/presentation/screens/games/true_or_myth/true_or_myth_state.dart';
import 'package:lume/layers/presentation/screens/games/who_am_i/who_am_i_state.dart';

enum GamesStatus { ready, saving, error }

@immutable
final class GamesState {
  const GamesState({
    this.status = GamesStatus.ready,
    this.rounds = const [],
    this.currentIndex = 0,
    this.completedCount = 0,
    this.correctCount = 0,
    this.answered = false,
    this.isCorrect = false,
    this.choice = const GamesChoiceUi(),
    this.whoAmI = const GamesWhoAmIUi(),
    this.completeSentence = const GamesCompleteSentenceUi(),
    this.connections = const GamesConnectionsUi(),
    this.mysteriousWord = const GamesMysteriousWordUi(),
    this.errorMessage,
    this.sequenceCompleted = false,
    this.goBack = false,
    this.pendingSaveScorePct,
  });

  final GamesStatus status;
  final List<GameRound> rounds;
  final int currentIndex;
  final int completedCount;
  final int correctCount;
  final bool answered;
  final bool isCorrect;
  final GamesChoiceUi choice;
  final GamesWhoAmIUi whoAmI;
  final GamesCompleteSentenceUi completeSentence;
  final GamesConnectionsUi connections;
  final GamesMysteriousWordUi mysteriousWord;
  final String? errorMessage;
  final bool sequenceCompleted;
  final bool goBack;

  /// When set, [GamesRetrySave] re-attempts persisting this score for the
  /// current round before advancing.
  final int? pendingSaveScorePct;

  GameRound? get currentRound {
    if (currentIndex < 0 || currentIndex >= rounds.length) return null;
    return rounds[currentIndex];
  }

  TrailGameDomain? get currentGame => currentRound?.game;

  bool get isLastRound =>
      rounds.isNotEmpty && currentIndex >= rounds.length - 1;

  /// Progress in [0.0, 1.0]; advances after each round is finished and saved.
  double get progressValue {
    if (rounds.isEmpty) return 0.0;
    if (sequenceCompleted) return 1.0;
    return (completedCount / rounds.length).clamp(0.0, 1.0);
  }

  LightningQuizState? get lightningQuizView {
    final game = currentGame;
    if (game is! LightningQuizGameDomain) return null;
    return LightningQuizState(
      game: game,
      selectedOptionId: choice.selectedOptionId,
      answered: answered,
      isCorrect: isCorrect,
    );
  }

  TimelineState? get timelineView {
    final game = currentGame;
    if (game is! TimelineGameDomain) return null;
    return TimelineState(
      game: game,
      selectedOptionId: choice.selectedOptionId,
      answered: answered,
      isCorrect: isCorrect,
    );
  }

  TrueOrMythState? get trueOrMythView {
    final game = currentGame;
    if (game is! TrueOrMythGameDomain) return null;
    return TrueOrMythState(
      game: game,
      selectedOptionId: choice.selectedOptionId,
      answered: answered,
      isCorrect: isCorrect,
    );
  }

  BattleOfCuriositiesState? get battleView {
    final game = currentGame;
    if (game is! BattleOfCuriositiesGameDomain) return null;
    return BattleOfCuriositiesState(
      game: game,
      selectedOptionId: choice.selectedOptionId,
      answered: answered,
      isCorrect: isCorrect,
    );
  }

  WhoAmIState? get whoAmIView {
    final game = currentGame;
    if (game is! WhoAmIGameDomain) return null;
    return WhoAmIState(
      game: game,
      answer: whoAmI.answer,
      hintsVisible: whoAmI.hintsVisible,
      answered: answered,
      isCorrect: isCorrect,
    );
  }

  CompleteSentenceState? get completeSentenceView {
    final game = currentGame;
    if (game is! CompleteSentenceGameDomain) return null;
    return CompleteSentenceState(
      game: game,
      selections: completeSentence.selections,
      answered: answered,
      isCorrect: isCorrect,
    );
  }

  ConnectionsState? get connectionsView {
    final game = currentGame;
    if (game is! ConnectionsGameDomain) return null;
    return ConnectionsState(
      game: game,
      selectedLeftId: connections.selectedLeftId,
      links: connections.links,
      linkOrder: connections.linkOrder,
      answered: answered,
      isCorrect: isCorrect,
    );
  }

  MysteriousWordState? get mysteriousWordView {
    final game = currentGame;
    if (game is! MysteriousWordGameDomain) return null;
    return MysteriousWordState(
      game: game,
      guessedLetters: mysteriousWord.guessedLetters,
      wrongCount: mysteriousWord.wrongCount,
      answered: answered,
      isCorrect: isCorrect,
    );
  }

  GamesState copyWith({
    GamesStatus? status,
    List<GameRound>? rounds,
    int? currentIndex,
    int? completedCount,
    int? correctCount,
    bool? answered,
    bool? isCorrect,
    GamesChoiceUi? choice,
    GamesWhoAmIUi? whoAmI,
    GamesCompleteSentenceUi? completeSentence,
    GamesConnectionsUi? connections,
    GamesMysteriousWordUi? mysteriousWord,
    String? errorMessage,
    bool clearError = false,
    bool? sequenceCompleted,
    bool? goBack,
    bool clearNavigationFlags = false,
    int? pendingSaveScorePct,
    bool clearPendingSave = false,
    bool resetPlayFields = false,
  }) {
    return GamesState(
      status: status ?? this.status,
      rounds: rounds ?? this.rounds,
      currentIndex: currentIndex ?? this.currentIndex,
      completedCount: completedCount ?? this.completedCount,
      correctCount: correctCount ?? this.correctCount,
      answered: resetPlayFields ? false : (answered ?? this.answered),
      isCorrect: resetPlayFields ? false : (isCorrect ?? this.isCorrect),
      choice: resetPlayFields
          ? const GamesChoiceUi()
          : (choice ?? this.choice),
      whoAmI: resetPlayFields
          ? const GamesWhoAmIUi()
          : (whoAmI ?? this.whoAmI),
      completeSentence: resetPlayFields
          ? const GamesCompleteSentenceUi()
          : (completeSentence ?? this.completeSentence),
      connections: resetPlayFields
          ? const GamesConnectionsUi()
          : (connections ?? this.connections),
      mysteriousWord: resetPlayFields
          ? const GamesMysteriousWordUi()
          : (mysteriousWord ?? this.mysteriousWord),
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      sequenceCompleted: clearNavigationFlags
          ? false
          : (sequenceCompleted ?? this.sequenceCompleted),
      goBack: clearNavigationFlags ? false : (goBack ?? this.goBack),
      pendingSaveScorePct: clearPendingSave
          ? null
          : pendingSaveScorePct ?? this.pendingSaveScorePct,
    );
  }

  /// Fresh play session from [rounds] (booleans reset without nullable traps).
  factory GamesState.initial({required List<GameRound> rounds}) {
    return GamesState(rounds: rounds);
  }

  @override
  bool operator ==(Object other) =>
      other is GamesState &&
      other.status == status &&
      listEquals(other.rounds, rounds) &&
      other.currentIndex == currentIndex &&
      other.completedCount == completedCount &&
      other.correctCount == correctCount &&
      other.answered == answered &&
      other.isCorrect == isCorrect &&
      other.choice == choice &&
      other.whoAmI == whoAmI &&
      other.completeSentence == completeSentence &&
      other.connections == connections &&
      other.mysteriousWord == mysteriousWord &&
      other.errorMessage == errorMessage &&
      other.sequenceCompleted == sequenceCompleted &&
      other.goBack == goBack &&
      other.pendingSaveScorePct == pendingSaveScorePct;

  @override
  int get hashCode => Object.hash(
    status,
    Object.hashAll(rounds),
    currentIndex,
    completedCount,
    correctCount,
    answered,
    isCorrect,
    choice,
    whoAmI,
    completeSentence,
    connections,
    mysteriousWord,
    errorMessage,
    sequenceCompleted,
    goBack,
    pendingSaveScorePct,
  );
}
