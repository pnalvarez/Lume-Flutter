import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lume/layers/presentation/screens/games/battle_of_curiosities/battle_of_curiosities_event.dart';
import 'package:lume/layers/presentation/screens/games/battle_of_curiosities/battle_of_curiosities_state.dart';

@injectable
final class BattleOfCuriositiesBloc
    extends Bloc<BattleOfCuriositiesEvent, BattleOfCuriositiesState> {
  BattleOfCuriositiesBloc() : super(const BattleOfCuriositiesState()) {
    on<BattleOfCuriositiesStarted>(_onStarted);
    on<BattleOfCuriositiesOptionSelected>(_onOptionSelected);
    on<BattleOfCuriositiesNextPressed>(_onNextPressed);
  }

  void _onStarted(
    BattleOfCuriositiesStarted event,
    Emitter<BattleOfCuriositiesState> emit,
  ) {
    emit(BattleOfCuriositiesState(game: event.game));
  }

  void _onOptionSelected(
    BattleOfCuriositiesOptionSelected event,
    Emitter<BattleOfCuriositiesState> emit,
  ) {
    final game = state.game;
    if (game == null || state.answered) return;
    emit(
      state.copyWith(
        selectedOptionId: event.optionId,
        answered: true,
        isCorrect: event.optionId == game.correct.wireValue,
      ),
    );
  }

  void _onNextPressed(
    BattleOfCuriositiesNextPressed event,
    Emitter<BattleOfCuriositiesState> emit,
  ) {
    if (!state.answered || state.finished) return;
    emit(state.copyWith(finished: true));
  }
}
