import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/models/game_play/choice_play.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';

abstract interface class IPlayLightningQuiz {
  ChoicePlayOutcome? selectOption({
    required LightningQuizGameDomain game,
    required String optionId,
  });
}

@Injectable(as: IPlayLightningQuiz)
final class PlayLightningQuiz implements IPlayLightningQuiz {
  @override
  ChoicePlayOutcome? selectOption({
    required LightningQuizGameDomain game,
    required String optionId,
  }) {
    final index = int.tryParse(optionId);
    if (index == null) return null;
    return ChoicePlayOutcome(
      selectedOptionId: optionId,
      isCorrect: index == game.correctIndex,
    );
  }
}
