import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lume/layers/presentation/screens/games/timeline/timeline_event.dart';
import 'package:lume/layers/presentation/screens/games/timeline/timeline_state.dart';

@injectable
final class TimelineBloc extends Bloc<TimelineEvent, TimelineState> {
  TimelineBloc() : super(const TimelineState()) {
    on<TimelineStarted>(_onStarted);
    on<TimelineOptionSelected>(_onOptionSelected);
    on<TimelineNextPressed>(_onNextPressed);
  }

  void _onStarted(TimelineStarted event, Emitter<TimelineState> emit) {
    emit(TimelineState(game: event.game));
  }

  void _onOptionSelected(
    TimelineOptionSelected event,
    Emitter<TimelineState> emit,
  ) {
    final game = state.game;
    if (game == null || state.answered) return;
    final index = int.tryParse(event.optionId);
    if (index == null) return;
    emit(
      state.copyWith(
        selectedOptionId: event.optionId,
        answered: true,
        isCorrect: index == game.correctIndex,
      ),
    );
  }

  void _onNextPressed(TimelineNextPressed event, Emitter<TimelineState> emit) {
    if (!state.answered || state.finished) return;
    emit(state.copyWith(finished: true));
  }
}
