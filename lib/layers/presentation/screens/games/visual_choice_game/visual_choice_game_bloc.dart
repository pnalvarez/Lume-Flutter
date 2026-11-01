import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lume/common/strings/trail_strings.dart';
import 'package:lume/core/analytics/analytics.dart';
import 'package:lume/core/analytics/visual_choice_game_analytics.dart';
import 'package:lume/layers/domain/usecases/visual_choice_game_match.dart';
import 'package:lume/layers/domain/usecases/submit_visual_choice_game_answer.dart';
import 'package:lume/layers/presentation/screens/games/visual_choice_game/visual_choice_game_event.dart';
import 'package:lume/layers/presentation/screens/games/visual_choice_game/visual_choice_game_play_state.dart';
import 'package:lume/layers/presentation/screens/games/visual_choice_game/visual_choice_game_state.dart';

@injectable
final class VisualChoiceGameBloc
    extends Bloc<VisualChoiceGameEvent, VisualChoiceGamePlayState> {
  VisualChoiceGameBloc(this._submitAnswer, this._match, IAnalytics analytics)
    : _visualAnalytics = VisualChoiceGameAnalytics(analytics),
      super(const VisualChoiceGamePlayState()) {
    on<VisualChoiceGameStarted>(_onStarted);
    on<VisualChoiceGameOptionSelected>(_onOptionSelected);
    on<VisualChoiceGameNextPressed>(_onNextPressed);
    on<VisualChoiceGameAbandoned>(_onAbandoned);
    on<VisualChoiceGameImageFailed>(_onImageFailed);
    on<VisualChoiceGameNavigationHandled>(_onNavigationHandled);
    on<VisualChoiceGameSnackShown>(_onSnackShown);
  }

  final ISubmitVisualChoiceGameAnswer _submitAnswer;
  final IVisualChoiceGameMatch _match;
  final VisualChoiceGameAnalytics _visualAnalytics;

  var _closed = false;
  var _closing = false;

  /// A failed close must not leave the round stuck in [VisualChoiceGamePhase.submitting].
  VisualChoiceGamePhase get _phaseAfterSubmit =>
      state.submitting ? VisualChoiceGamePhase.playing : state.phase;

  void _onStarted(
    VisualChoiceGameStarted event,
    Emitter<VisualChoiceGamePlayState> emit,
  ) {
    if (event.rounds.isEmpty) {
      emit(state.copyWith(goBack: true));
      return;
    }
    _visualAnalytics
      ..useConfig(event.config)
      ..reset()
      ..roundStarted(roundsTotal: event.rounds.length, isArcade: false);
    emit(
      VisualChoiceGamePlayState(rounds: event.rounds, matchId: event.matchId),
    );
  }

  Future<void> _onOptionSelected(
    VisualChoiceGameOptionSelected event,
    Emitter<VisualChoiceGamePlayState> emit,
  ) async {
    if (!state.canSelect) return;
    final round = state.current;
    final roundIndex = state.index;
    final index = int.tryParse(event.optionId);
    if (round == null ||
        index == null ||
        index < 0 ||
        index >= round.options.length) {
      return;
    }

    final answer = round.options[index];
    // Stay unanswered until submit_visual_answer returns. An early answered
    // flag opens the root feedback dialog, and a failed write only clears
    // this selection — it does not pop that route.
    emit(
      state.copyWith(
        phase: VisualChoiceGamePhase.submitting,
        selectedOptionId: event.optionId,
        clearSnack: true,
      ),
    );
    try {
      final result = await _submitAnswer(
        questionId: round.questionId,
        answer: answer,
      );
      _visualAnalytics.questionAnswered(
        questionType: round.questionType,
        isCorrect: result.correct,
        roundIndex: roundIndex,
        isArcade: false,
      );
      emit(
        state.copyWith(
          phase: result.correct
              ? VisualChoiceGamePhase.correct
              : VisualChoiceGamePhase.incorrect,
          revealedCorrectAnswer: result.correctAnswer,
          correctCount: state.correctCount + (result.correct ? 1 : 0),
        ),
      );
    } on Object {
      emit(
        state.copyWith(clearAnswer: true, snackMessage: trailSessionSaveError),
      );
    }
  }

  Future<void> _onNextPressed(
    VisualChoiceGameNextPressed event,
    Emitter<VisualChoiceGamePlayState> emit,
  ) async {
    if (!state.answered) return;
    if (state.index >= state.rounds.length - 1) {
      await _closeMatch(emit, sequenceCompleted: true);
      return;
    }
    emit(state.copyWith(index: state.index + 1, clearAnswer: true));
  }

  Future<void> _onAbandoned(
    VisualChoiceGameAbandoned event,
    Emitter<VisualChoiceGamePlayState> emit,
  ) async {
    if (state.submitting || _closing) return;
    _visualAnalytics.sessionAbandoned(
      roundIndex: state.index,
      roundsTotal: state.rounds.length,
      isArcade: false,
    );
    if (state.hasProgress && state.matchId.isNotEmpty && !_closed) {
      await _closeMatch(emit, goBack: true);
      return;
    }
    emit(state.copyWith(goBack: true));
  }

  void _onImageFailed(
    VisualChoiceGameImageFailed event,
    Emitter<VisualChoiceGamePlayState> emit,
  ) {
    _visualAnalytics.imageFailed(roundIndex: state.index, isArcade: false);
  }

  void _onNavigationHandled(
    VisualChoiceGameNavigationHandled event,
    Emitter<VisualChoiceGamePlayState> emit,
  ) {
    emit(state.copyWith(goBack: false));
  }

  void _onSnackShown(
    VisualChoiceGameSnackShown event,
    Emitter<VisualChoiceGamePlayState> emit,
  ) {
    emit(state.copyWith(clearSnack: true));
  }

  Future<void> _closeMatch(
    Emitter<VisualChoiceGamePlayState> emit, {
    bool goBack = false,
    bool sequenceCompleted = false,
  }) async {
    if (_closed) {
      emit(
        state.copyWith(goBack: goBack, sequenceCompleted: sequenceCompleted),
      );
      return;
    }
    if (_closing) return;
    _closing = true;
    try {
      final total = state.rounds.length;
      final correctCount = state.correctCount;
      await _match.finish(
        matchId: state.matchId,
        score: _scorePct(correctCount, total),
        correctCount: correctCount,
        totalQuestions: total,
      );
      _closed = true;
      if (sequenceCompleted) {
        _visualAnalytics.sessionCompleted(
          correctCount: correctCount,
          roundsTotal: total,
          isArcade: false,
        );
      }
      emit(
        state.copyWith(
          goBack: goBack,
          sequenceCompleted: sequenceCompleted,
          phase: _phaseAfterSubmit,
          clearSnack: true,
        ),
      );
    } on Object {
      emit(
        state.copyWith(
          phase: _phaseAfterSubmit,
          snackMessage: trailSessionSaveError,
        ),
      );
    } finally {
      _closing = false;
    }
  }

  static int _scorePct(int correct, int total) {
    if (total <= 0) return 0;
    return ((correct * 100) / total).round();
  }
}
