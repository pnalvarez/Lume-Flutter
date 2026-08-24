import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/models/game_play/complete_sentence_play.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';

abstract interface class IPlayCompleteSentence {
  CompleteSentencePlayOutcome selectBlank({
    required CompleteSentencePlayState current,
    required int blankOrder,
    required String option,
  });

  CompleteSentencePlayOutcome? submit({
    required CompleteSentencePlayState current,
    required CompleteSentenceGameDomain game,
  });
}

@Injectable(as: IPlayCompleteSentence)
final class PlayCompleteSentence implements IPlayCompleteSentence {
  @override
  CompleteSentencePlayOutcome selectBlank({
    required CompleteSentencePlayState current,
    required int blankOrder,
    required String option,
  }) {
    final next = Map<int, String>.from(current.selections)
      ..[blankOrder] = option;
    return CompleteSentencePlayOutcome(
      state: current.copyWith(selections: next),
    );
  }

  @override
  CompleteSentencePlayOutcome? submit({
    required CompleteSentencePlayState current,
    required CompleteSentenceGameDomain game,
  }) {
    if (current.selections.length < game.blanks.length) return null;

    final correct = game.blanks.every(
      (blank) => current.selections[blank.order] == blank.correct,
    );
    return CompleteSentencePlayOutcome(
      state: current,
      answered: true,
      isCorrect: correct,
    );
  }
}
