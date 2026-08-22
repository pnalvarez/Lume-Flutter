import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/helpers/answer_match.dart';
import 'package:lume/layers/presentation/screens/games/who_am_i/who_am_i_event.dart';
import 'package:lume/layers/presentation/screens/games/who_am_i/who_am_i_state.dart';

@injectable
final class WhoAmIBloc extends Bloc<WhoAmIEvent, WhoAmIState> {
  WhoAmIBloc() : super(const WhoAmIState()) {
    on<WhoAmIStarted>(_onStarted);
    on<WhoAmIAnswerChanged>(_onAnswerChanged);
    on<WhoAmIRevealHint>(_onRevealHint);
    on<WhoAmISubmit>(_onSubmit);
    on<WhoAmINext>(_onNext);
  }

  void _onStarted(WhoAmIStarted event, Emitter<WhoAmIState> emit) {
    emit(WhoAmIState(game: event.game));
  }

  void _onAnswerChanged(WhoAmIAnswerChanged event, Emitter<WhoAmIState> emit) {
    if (state.answered) return;
    emit(state.copyWith(answer: event.answer));
  }

  void _onRevealHint(WhoAmIRevealHint event, Emitter<WhoAmIState> emit) {
    final game = state.game;
    if (game == null || state.answered) return;
    if (state.hintsVisible >= game.hints.length) return;
    emit(state.copyWith(hintsVisible: state.hintsVisible + 1));
  }

  void _onSubmit(WhoAmISubmit event, Emitter<WhoAmIState> emit) {
    final game = state.game;
    if (game == null || state.answered) return;
    final correct = AnswerMatch.isCorrect(
      state.answer,
      game.correctAnswer,
      aliases: game.acceptedSynonyms,
    );
    emit(state.copyWith(answered: true, isCorrect: correct));
  }

  void _onNext(WhoAmINext event, Emitter<WhoAmIState> emit) {
    if (!state.answered || state.finished) return;
    emit(state.copyWith(finished: true));
  }
}
