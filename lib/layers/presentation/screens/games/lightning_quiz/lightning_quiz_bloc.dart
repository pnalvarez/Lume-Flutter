import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lume/layers/presentation/screens/games/lightning_quiz/lightning_quiz_event.dart';
import 'package:lume/layers/presentation/screens/games/lightning_quiz/lightning_quiz_state.dart';

@injectable
final class LightningQuizBloc
    extends Bloc<LightningQuizEvent, LightningQuizState> {
  LightningQuizBloc() : super(const LightningQuizState()) {
    on<LightningQuizStarted>(_onStarted);
    on<LightningQuizOptionSelected>(_onOptionSelected);
    on<LightningQuizNextPressed>(_onNextPressed);
  }

  void _onStarted(
    LightningQuizStarted event,
    Emitter<LightningQuizState> emit,
  ) {
    emit(LightningQuizState(game: event.game));
  }

  void _onOptionSelected(
    LightningQuizOptionSelected event,
    Emitter<LightningQuizState> emit,
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

  void _onNextPressed(
    LightningQuizNextPressed event,
    Emitter<LightningQuizState> emit,
  ) {
    if (!state.answered || state.finished) return;
    emit(state.copyWith(finished: true));
  }
}
