import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lume/common/strings/trail_strings.dart';
import 'package:lume/core/analytics/analytics.dart';
import 'package:lume/core/analytics/knowledge_gallery_analytics.dart';
import 'package:lume/layers/domain/usecases/knowledge_gallery_match.dart';
import 'package:lume/layers/domain/usecases/submit_knowledge_gallery_answer.dart';
import 'package:lume/layers/presentation/screens/games/knowledge_gallery/knowledge_gallery_event.dart';
import 'package:lume/layers/presentation/screens/games/knowledge_gallery/knowledge_gallery_play_state.dart';
import 'package:lume/layers/presentation/screens/games/knowledge_gallery/knowledge_gallery_state.dart';

@injectable
final class KnowledgeGalleryBloc
    extends Bloc<KnowledgeGalleryEvent, KnowledgeGalleryPlayState> {
  KnowledgeGalleryBloc(this._submitAnswer, this._match, IAnalytics analytics)
    : _galleryAnalytics = KnowledgeGalleryAnalytics(analytics),
      super(const KnowledgeGalleryPlayState()) {
    on<KnowledgeGalleryStarted>(_onStarted);
    on<KnowledgeGalleryOptionSelected>(_onOptionSelected);
    on<KnowledgeGalleryNextPressed>(_onNextPressed);
    on<KnowledgeGalleryAbandoned>(_onAbandoned);
    on<KnowledgeGalleryImageFailed>(_onImageFailed);
    on<KnowledgeGalleryNavigationHandled>(_onNavigationHandled);
    on<KnowledgeGallerySnackShown>(_onSnackShown);
  }

  final ISubmitKnowledgeGalleryAnswer _submitAnswer;
  final IKnowledgeGalleryMatch _match;
  final KnowledgeGalleryAnalytics _galleryAnalytics;

  var _closed = false;
  var _closing = false;

  /// A failed close must not leave the round stuck in [KnowledgeGalleryPhase.submitting].
  KnowledgeGalleryPhase get _phaseAfterSubmit =>
      state.submitting ? KnowledgeGalleryPhase.playing : state.phase;

  void _onStarted(
    KnowledgeGalleryStarted event,
    Emitter<KnowledgeGalleryPlayState> emit,
  ) {
    if (event.rounds.isEmpty) {
      emit(state.copyWith(goBack: true));
      return;
    }
    _galleryAnalytics
      ..reset()
      ..roundStarted(roundsTotal: event.rounds.length, isArcade: false);
    emit(
      KnowledgeGalleryPlayState(rounds: event.rounds, matchId: event.matchId),
    );
  }

  Future<void> _onOptionSelected(
    KnowledgeGalleryOptionSelected event,
    Emitter<KnowledgeGalleryPlayState> emit,
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
        phase: KnowledgeGalleryPhase.submitting,
        selectedOptionId: event.optionId,
        clearSnack: true,
      ),
    );
    try {
      final result = await _submitAnswer(
        questionId: round.questionId,
        answer: answer,
      );
      _galleryAnalytics.questionAnswered(
        questionType: round.questionType,
        isCorrect: result.correct,
        roundIndex: roundIndex,
        isArcade: false,
      );
      emit(
        state.copyWith(
          phase: result.correct
              ? KnowledgeGalleryPhase.correct
              : KnowledgeGalleryPhase.incorrect,
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
    KnowledgeGalleryNextPressed event,
    Emitter<KnowledgeGalleryPlayState> emit,
  ) async {
    if (!state.answered) return;
    if (state.index >= state.rounds.length - 1) {
      await _closeMatch(emit, sequenceCompleted: true);
      return;
    }
    emit(state.copyWith(index: state.index + 1, clearAnswer: true));
  }

  Future<void> _onAbandoned(
    KnowledgeGalleryAbandoned event,
    Emitter<KnowledgeGalleryPlayState> emit,
  ) async {
    if (state.submitting || _closing) return;
    _galleryAnalytics.sessionAbandoned(
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
    KnowledgeGalleryImageFailed event,
    Emitter<KnowledgeGalleryPlayState> emit,
  ) {
    _galleryAnalytics.imageFailed(roundIndex: state.index, isArcade: false);
  }

  void _onNavigationHandled(
    KnowledgeGalleryNavigationHandled event,
    Emitter<KnowledgeGalleryPlayState> emit,
  ) {
    emit(state.copyWith(goBack: false));
  }

  void _onSnackShown(
    KnowledgeGallerySnackShown event,
    Emitter<KnowledgeGalleryPlayState> emit,
  ) {
    emit(state.copyWith(clearSnack: true));
  }

  Future<void> _closeMatch(
    Emitter<KnowledgeGalleryPlayState> emit, {
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
        _galleryAnalytics.sessionCompleted(
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
