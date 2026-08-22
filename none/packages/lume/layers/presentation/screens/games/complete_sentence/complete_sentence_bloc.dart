import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lume/layers/presentation/screens/games/complete_sentence/complete_sentence_event.dart';
import 'package:lume/layers/presentation/screens/games/complete_sentence/complete_sentence_state.dart';

@injectable
final class CompleteSentenceBloc
    extends Bloc<CompleteSentenceEvent, CompleteSentenceState> {
  CompleteSentenceBloc() : super(const CompleteSentenceState()) {
    on<CompleteSentenceStarted>(_onStarted);
    on<CompleteSentenceBlankSelected>(_onBlankSelected);
    on<CompleteSentenceSubmit>(_onSubmit);
    on<CompleteSentenceNext>(_onNext);
  }

  void _onStarted(
    CompleteSentenceStarted event,
    Emitter<CompleteSentenceState> emit,
  ) {
    emit(CompleteSentenceState(game: event.game));
  }

  void _onBlankSelected(
    CompleteSentenceBlankSelected event,
    Emitter<CompleteSentenceState> emit,
  ) {
    if (state.game == null || state.answered) return;
    final next = Map<int, String>.from(state.selections)
      ..[event.blankOrder] = event.option;
    emit(state.copyWith(selections: next));
  }

  void _onSubmit(
    CompleteSentenceSubmit event,
    Emitter<CompleteSentenceState> emit,
  ) {
    final game = state.game;
    if (game == null || state.answered) return;
    if (state.selections.length < game.blanks.length) return;

    final correct = game.blanks.every(
      (blank) => state.selections[blank.order] == blank.correct,
    );
    emit(state.copyWith(answered: true, isCorrect: correct));
  }

  void _onNext(CompleteSentenceNext event, Emitter<CompleteSentenceState> emit) {
    if (!state.answered || state.finished) return;
    emit(state.copyWith(finished: true));
  }
}
