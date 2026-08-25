import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lume/common/strings/trail_strings.dart';
import 'package:lume/layers/domain/models/game_play/complete_sentence_play.dart';
import 'package:lume/layers/domain/models/game_play/connections_play.dart';
import 'package:lume/layers/domain/models/game_play/mysterious_word_play.dart';
import 'package:lume/layers/domain/models/game_play/who_am_i_play.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';
import 'package:lume/layers/domain/usecases/games/play_battle_of_curiosities.dart';
import 'package:lume/layers/domain/usecases/games/play_complete_sentence.dart';
import 'package:lume/layers/domain/usecases/games/play_connections.dart';
import 'package:lume/layers/domain/usecases/games/play_lightning_quiz.dart';
import 'package:lume/layers/domain/usecases/games/play_mysterious_word.dart';
import 'package:lume/layers/domain/usecases/games/play_timeline.dart';
import 'package:lume/layers/domain/usecases/games/play_true_or_myth.dart';
import 'package:lume/layers/domain/usecases/games/play_who_am_i.dart';
import 'package:lume/layers/domain/usecases/save_pair_progress.dart';
import 'package:lume/layers/presentation/screens/games/game_round.dart';
import 'package:lume/layers/presentation/screens/games/games_event.dart';
import 'package:lume/layers/presentation/screens/games/games_play_ui.dart';
import 'package:lume/layers/presentation/screens/games/games_state.dart';

@injectable
final class GamesBloc extends Bloc<GamesEvent, GamesState> {
  GamesBloc(
    this._playLightningQuiz,
    this._playTimeline,
    this._playTrueOrMyth,
    this._playBattleOfCuriosities,
    this._playWhoAmI,
    this._playCompleteSentence,
    this._playConnections,
    this._playMysteriousWord,
    this._savePairProgress,
  ) : super(const GamesState()) {
    on<GamesStarted>(_onStarted);
    on<GamesChoiceSelected>(_onChoiceSelected);
    on<GamesWhoAmIAnswerChanged>(_onWhoAmIAnswerChanged);
    on<GamesWhoAmIRevealHint>(_onWhoAmIRevealHint);
    on<GamesWhoAmISubmit>(_onWhoAmISubmit);
    on<GamesCompleteSentenceBlankSelected>(_onBlankSelected);
    on<GamesCompleteSentenceSubmit>(_onCompleteSentenceSubmit);
    on<GamesConnectionsLeftSelected>(_onConnectionsLeftSelected);
    on<GamesConnectionsRightSelected>(_onConnectionsRightSelected);
    on<GamesConnectionsUndoLast>(_onConnectionsUndoLast);
    on<GamesConnectionsSubmit>(_onConnectionsSubmit);
    on<GamesMysteriousWordLetterPressed>(_onMysteriousWordLetterPressed);
    on<GamesNextPressed>(_onNextPressed);
    on<GamesRetrySave>(_onRetrySave);
    on<GamesAbandoned>(_onAbandoned);
    on<GamesNavigationHandled>(_onNavigationHandled);
    on<GamesXpSnackBarShown>(_onXpSnackBarShown);
  }

  final IPlayLightningQuiz _playLightningQuiz;
  final IPlayTimeline _playTimeline;
  final IPlayTrueOrMyth _playTrueOrMyth;
  final IPlayBattleOfCuriosities _playBattleOfCuriosities;
  final IPlayWhoAmI _playWhoAmI;
  final IPlayCompleteSentence _playCompleteSentence;
  final IPlayConnections _playConnections;
  final IPlayMysteriousWord _playMysteriousWord;
  final ISavePairProgress _savePairProgress;

  GamesPlayMode _mode = GamesPlayMode.trail;
  GamesRoundSave? _onSaveRound;

  void _onStarted(GamesStarted event, Emitter<GamesState> emit) {
    _mode = event.mode;
    _onSaveRound = event.onSaveRound;
    emit(GamesState.initial(rounds: event.rounds));
  }

  void _onChoiceSelected(GamesChoiceSelected event, Emitter<GamesState> emit) {
    if (state.answered) return;

    final outcome = switch (state.currentGame) {
      LightningQuizGameDomain game => _playLightningQuiz.selectOption(
        game: game,
        optionId: event.optionId,
      ),
      TimelineGameDomain game => _playTimeline.selectOption(
        game: game,
        optionId: event.optionId,
      ),
      TrueOrMythGameDomain game => _playTrueOrMyth.selectOption(
        game: game,
        optionId: event.optionId,
      ),
      BattleOfCuriositiesGameDomain game =>
        _playBattleOfCuriosities.selectOption(
          game: game,
          optionId: event.optionId,
        ),
      _ => null,
    };

    if (outcome == null) return;

    emit(
      state.copyWith(
        choice: state.choice.copyWith(
          selectedOptionId: outcome.selectedOptionId,
        ),
        answered: true,
        isCorrect: outcome.isCorrect,
      ),
    );
  }

  void _onWhoAmIAnswerChanged(
    GamesWhoAmIAnswerChanged event,
    Emitter<GamesState> emit,
  ) {
    if (state.answered) return;
    final outcome = _playWhoAmI.updateAnswer(
      current: _whoAmIPlayState,
      answer: event.answer,
    );
    emit(state.copyWith(whoAmI: _whoAmIUi(outcome.state)));
  }

  void _onWhoAmIRevealHint(
    GamesWhoAmIRevealHint event,
    Emitter<GamesState> emit,
  ) {
    final game = state.currentGame;
    if (game is! WhoAmIGameDomain || state.answered) return;
    final outcome = _playWhoAmI.revealHint(
      current: _whoAmIPlayState,
      game: game,
    );
    if (outcome == null) return;
    emit(state.copyWith(whoAmI: _whoAmIUi(outcome.state)));
  }

  void _onWhoAmISubmit(GamesWhoAmISubmit event, Emitter<GamesState> emit) {
    final game = state.currentGame;
    if (game is! WhoAmIGameDomain || state.answered) return;
    final outcome = _playWhoAmI.submit(current: _whoAmIPlayState, game: game);
    if (outcome == null) return;
    emit(
      state.copyWith(
        whoAmI: _whoAmIUi(outcome.state),
        answered: outcome.answered,
        isCorrect: outcome.isCorrect,
      ),
    );
  }

  void _onBlankSelected(
    GamesCompleteSentenceBlankSelected event,
    Emitter<GamesState> emit,
  ) {
    if (state.currentGame is! CompleteSentenceGameDomain || state.answered) {
      return;
    }
    final outcome = _playCompleteSentence.selectBlank(
      current: _completeSentencePlayState,
      blankOrder: event.blankOrder,
      option: event.option,
    );
    emit(state.copyWith(completeSentence: _completeSentenceUi(outcome.state)));
  }

  void _onCompleteSentenceSubmit(
    GamesCompleteSentenceSubmit event,
    Emitter<GamesState> emit,
  ) {
    final game = state.currentGame;
    if (game is! CompleteSentenceGameDomain || state.answered) return;
    final outcome = _playCompleteSentence.submit(
      current: _completeSentencePlayState,
      game: game,
    );
    if (outcome == null) return;
    emit(
      state.copyWith(
        completeSentence: _completeSentenceUi(outcome.state),
        answered: outcome.answered,
        isCorrect: outcome.isCorrect,
      ),
    );
  }

  void _onConnectionsLeftSelected(
    GamesConnectionsLeftSelected event,
    Emitter<GamesState> emit,
  ) {
    if (state.currentGame is! ConnectionsGameDomain || state.answered) return;
    final outcome = _playConnections.selectLeft(
      current: _connectionsPlayState,
      leftId: event.leftId,
    );
    emit(state.copyWith(connections: _connectionsUi(outcome.state)));
  }

  void _onConnectionsRightSelected(
    GamesConnectionsRightSelected event,
    Emitter<GamesState> emit,
  ) {
    if (state.currentGame is! ConnectionsGameDomain || state.answered) return;
    final outcome = _playConnections.selectRight(
      current: _connectionsPlayState,
      rightId: event.rightId,
    );
    if (outcome == null) return;
    emit(state.copyWith(connections: _connectionsUi(outcome.state)));
  }

  void _onConnectionsUndoLast(
    GamesConnectionsUndoLast event,
    Emitter<GamesState> emit,
  ) {
    if (state.answered) return;
    final outcome = _playConnections.undoLast(current: _connectionsPlayState);
    if (outcome == null) return;
    emit(state.copyWith(connections: _connectionsUi(outcome.state)));
  }

  void _onConnectionsSubmit(
    GamesConnectionsSubmit event,
    Emitter<GamesState> emit,
  ) {
    final game = state.currentGame;
    if (game is! ConnectionsGameDomain || state.answered) return;
    final outcome = _playConnections.submit(
      current: _connectionsPlayState,
      game: game,
    );
    if (outcome == null) return;
    emit(
      state.copyWith(
        connections: _connectionsUi(outcome.state),
        answered: outcome.answered,
        isCorrect: outcome.isCorrect,
      ),
    );
  }

  void _onMysteriousWordLetterPressed(
    GamesMysteriousWordLetterPressed event,
    Emitter<GamesState> emit,
  ) {
    final game = state.currentGame;
    if (game is! MysteriousWordGameDomain || state.answered) return;
    final outcome = _playMysteriousWord.pressLetter(
      current: _mysteriousWordPlayState,
      game: game,
      letter: event.letter,
    );
    if (outcome == null) return;
    emit(
      state.copyWith(
        mysteriousWord: _mysteriousWordUi(outcome.state),
        answered: outcome.answered,
        isCorrect: outcome.isCorrect,
      ),
    );
  }

  Future<void> _onNextPressed(
    GamesNextPressed event,
    Emitter<GamesState> emit,
  ) async {
    if (!state.answered || state.status == GamesStatus.saving) return;
    final scorePct = state.isCorrect ? 100 : 0;
    await _persistAndAdvance(emit, scorePct: scorePct);
  }

  Future<void> _onRetrySave(
    GamesRetrySave event,
    Emitter<GamesState> emit,
  ) async {
    final scorePct = state.pendingSaveScorePct;
    if (scorePct == null) return;
    await _persistAndAdvance(emit, scorePct: scorePct);
  }

  Future<void> _persistAndAdvance(
    Emitter<GamesState> emit, {
    required int scorePct,
  }) async {
    final round = state.currentRound;
    if (round == null) return;

    emit(
      state.copyWith(
        status: GamesStatus.saving,
        pendingSaveScorePct: scorePct,
        clearError: true,
      ),
    );

    late final int xpAwarded;
    try {
      xpAwarded = await _persistRound(roundId: round.id, scorePct: scorePct);
    } on Object {
      emit(
        state.copyWith(
          status: GamesStatus.error,
          errorMessage: trailSessionSaveError,
          pendingSaveScorePct: scorePct,
        ),
      );
      return;
    }

    final nextCorrect = state.correctCount + (scorePct == 100 ? 1 : 0);
    final nextCompleted = state.completedCount + 1;

    if (state.isLastRound) {
      emit(
        state.copyWith(
          status: GamesStatus.ready,
          correctCount: nextCorrect,
          completedCount: nextCompleted,
          clearPendingSave: true,
          clearError: true,
          sequenceCompleted: true,
          xpAwardedToShow: xpAwarded > 0 ? xpAwarded : null,
          clearXpAwardedToShow: xpAwarded <= 0,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: GamesStatus.ready,
        currentIndex: state.currentIndex + 1,
        correctCount: nextCorrect,
        completedCount: nextCompleted,
        resetPlayFields: true,
        clearPendingSave: true,
        clearError: true,
        xpAwardedToShow: xpAwarded > 0 ? xpAwarded : null,
        clearXpAwardedToShow: xpAwarded <= 0,
      ),
    );
  }

  Future<int> _persistRound({
    required String roundId,
    required int scorePct,
  }) async {
    if (_mode == GamesPlayMode.hub) {
      final progress = await _savePairProgress(
        pairId: int.parse(roundId),
        scorePct: scorePct,
      );
      return progress.xpAwarded;
    }

    final save = _onSaveRound;
    if (save == null) return 0;
    return save(roundId: roundId, scorePct: scorePct);
  }

  void _onAbandoned(GamesAbandoned event, Emitter<GamesState> emit) {
    emit(state.copyWith(goBack: true));
  }

  void _onNavigationHandled(
    GamesNavigationHandled event,
    Emitter<GamesState> emit,
  ) {
    emit(state.copyWith(clearNavigationFlags: true));
  }

  void _onXpSnackBarShown(
    GamesXpSnackBarShown event,
    Emitter<GamesState> emit,
  ) {
    emit(state.copyWith(clearXpAwardedToShow: true));
  }

  WhoAmIPlayState get _whoAmIPlayState => WhoAmIPlayState(
    answer: state.whoAmI.answer,
    hintsVisible: state.whoAmI.hintsVisible,
  );

  GamesWhoAmIUi _whoAmIUi(WhoAmIPlayState playState) => GamesWhoAmIUi(
    answer: playState.answer,
    hintsVisible: playState.hintsVisible,
  );

  CompleteSentencePlayState get _completeSentencePlayState =>
      CompleteSentencePlayState(selections: state.completeSentence.selections);

  GamesCompleteSentenceUi _completeSentenceUi(
    CompleteSentencePlayState playState,
  ) => GamesCompleteSentenceUi(selections: playState.selections);

  ConnectionsPlayState get _connectionsPlayState => ConnectionsPlayState(
    selectedLeftId: state.connections.selectedLeftId,
    links: state.connections.links,
    linkOrder: state.connections.linkOrder,
  );

  GamesConnectionsUi _connectionsUi(ConnectionsPlayState playState) =>
      GamesConnectionsUi(
        selectedLeftId: playState.selectedLeftId,
        links: playState.links,
        linkOrder: playState.linkOrder,
      );

  MysteriousWordPlayState get _mysteriousWordPlayState =>
      MysteriousWordPlayState(
        guessedLetters: state.mysteriousWord.guessedLetters,
        wrongCount: state.mysteriousWord.wrongCount,
      );

  GamesMysteriousWordUi _mysteriousWordUi(MysteriousWordPlayState playState) =>
      GamesMysteriousWordUi(
        guessedLetters: playState.guessedLetters,
        wrongCount: playState.wrongCount,
      );
}
