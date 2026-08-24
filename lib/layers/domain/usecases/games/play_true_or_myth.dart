import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/models/game_play/choice_play.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';

abstract interface class IPlayTrueOrMyth {
  ChoicePlayOutcome? selectOption({
    required TrueOrMythGameDomain game,
    required String optionId,
  });
}

@Injectable(as: IPlayTrueOrMyth)
final class PlayTrueOrMyth implements IPlayTrueOrMyth {
  @override
  ChoicePlayOutcome? selectOption({
    required TrueOrMythGameDomain game,
    required String optionId,
  }) {
    return ChoicePlayOutcome(
      selectedOptionId: optionId,
      isCorrect: optionId == game.verdict.wireValue,
    );
  }
}
