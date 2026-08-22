import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/helpers/answer_match.dart';
import 'package:lume/layers/presentation/screens/games/mysterious_word/mysterious_word_event.dart';
import 'package:lume/layers/presentation/screens/games/mysterious_word/mysterious_word_state.dart';

@injectable
final class MysteriousWordBloc
    extends Bloc<MysteriousWordEvent, MysteriousWordState> {
  MysteriousWordBloc() : super(const MysteriousWordState()) {
    on<MysteriousWordStarted>(_onStarted);
    on<MysteriousWordLetterPressed>(_onLetterPressed);
    on<MysteriousWordNext>(_onNext);
  }

  void _onStarted(
    MysteriousWordStarted event,
    Emitter<MysteriousWordState> emit,
  ) {
    emit(MysteriousWordState(game: event.game));
  }

  void _onLetterPressed(
    MysteriousWordLetterPressed event,
    Emitter<MysteriousWordState> emit,
  ) {
    if (state.game == null || state.answered) return;

    final letter = AnswerMatch.normalizeText(event.letter)
        .toUpperCase()
        .replaceAll(RegExp('[^A-Z]'), '');
    if (letter.length != 1) return;
    if (state.guessedLetters.contains(letter)) return;

    final nextGuessed = {...state.guessedLetters, letter};
    final word = state.normalizedWord;
    final hit = word.contains(letter);
    final wrongCount = hit ? state.wrongCount : state.wrongCount + 1;
    final won = word.isNotEmpty &&
        word.split('').every(nextGuessed.contains);
    final lost = wrongCount >= MysteriousWordState.maxWrong;

    emit(
      state.copyWith(
        guessedLetters: nextGuessed,
        wrongCount: wrongCount,
        answered: won || lost,
        isCorrect: won,
      ),
    );
  }

  void _onNext(MysteriousWordNext event, Emitter<MysteriousWordState> emit) {
    if (!state.answered || state.finished) return;
    emit(state.copyWith(finished: true));
  }
}
