import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lume/layers/presentation/screens/games/true_or_myth/true_or_myth_event.dart';
import 'package:lume/layers/presentation/screens/games/true_or_myth/true_or_myth_state.dart';

@injectable
final class TrueOrMythBloc extends Bloc<TrueOrMythEvent, TrueOrMythState> {
  TrueOrMythBloc() : super(const TrueOrMythState()) {
    on<TrueOrMythStarted>(_onStarted);
    on<TrueOrMythOptionSelected>(_onOptionSelected);
    on<TrueOrMythNextPressed>(_onNextPressed);
  }

  void _onStarted(TrueOrMythStarted event, Emitter<TrueOrMythState> emit) {
    emit(TrueOrMythState(game: event.game));
  }

  void _onOptionSelected(
    TrueOrMythOptionSelected event,
    Emitter<TrueOrMythState> emit,
  ) {
    final game = state.game;
    if (game == null || state.answered) return;
    emit(
      state.copyWith(
        selectedOptionId: event.optionId,
        answered: true,
        isCorrect: event.optionId == game.verdict.wireValue,
      ),
    );
  }

  void _onNextPressed(
    TrueOrMythNextPressed event,
    Emitter<TrueOrMythState> emit,
  ) {
    if (!state.answered || state.finished) return;
    emit(state.copyWith(finished: true));
  }
}
