import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/models/game_play/choice_play.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';

abstract interface class IPlayBattleOfCuriosities {
  ChoicePlayOutcome? selectOption({
    required BattleOfCuriositiesGameDomain game,
    required String optionId,
  });
}

@Injectable(as: IPlayBattleOfCuriosities)
final class PlayBattleOfCuriosities implements IPlayBattleOfCuriosities {
  @override
  ChoicePlayOutcome? selectOption({
    required BattleOfCuriositiesGameDomain game,
    required String optionId,
  }) {
    return ChoicePlayOutcome(
      selectedOptionId: optionId,
      isCorrect: optionId == game.correct.wireValue,
    );
  }
}
