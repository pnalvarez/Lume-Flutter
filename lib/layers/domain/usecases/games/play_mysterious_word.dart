import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/helpers/answer_match.dart';
import 'package:lume/layers/domain/models/game_play/mysterious_word_play.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';

abstract interface class IPlayMysteriousWord {
  MysteriousWordPlayOutcome? pressLetter({
    required MysteriousWordPlayState current,
    required MysteriousWordGameDomain game,
    required String letter,
  });
}

@Injectable(as: IPlayMysteriousWord)
final class PlayMysteriousWord implements IPlayMysteriousWord {
  @override
  MysteriousWordPlayOutcome? pressLetter({
    required MysteriousWordPlayState current,
    required MysteriousWordGameDomain game,
    required String letter,
  }) {
    final normalizedLetter = AnswerMatch.normalizeText(
      letter,
    ).toUpperCase().replaceAll(RegExp('[^A-Z]'), '');
    if (normalizedLetter.length != 1) return null;
    if (current.guessedLetters.contains(normalizedLetter)) return null;

    final normalizedWord = AnswerMatch.normalizeText(
      game.word,
    ).toUpperCase().replaceAll(RegExp('[^A-Z]'), '');

    final nextGuessed = {...current.guessedLetters, normalizedLetter};
    final hit = normalizedWord.contains(normalizedLetter);
    final wrongCount = hit ? current.wrongCount : current.wrongCount + 1;
    final won =
        normalizedWord.isNotEmpty &&
        normalizedWord.split('').every(nextGuessed.contains);
    final lost = wrongCount >= MysteriousWordRules.maxWrong;

    return MysteriousWordPlayOutcome(
      state: current.copyWith(
        guessedLetters: nextGuessed,
        wrongCount: wrongCount,
      ),
      answered: won || lost,
      isCorrect: won,
    );
  }
}
