import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/models/game_play/choice_play.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';

abstract interface class IPlayTimeline {
  ChoicePlayOutcome? selectOption({
    required TimelineGameDomain game,
    required String optionId,
  });
}

@Injectable(as: IPlayTimeline)
final class PlayTimeline implements IPlayTimeline {
  @override
  ChoicePlayOutcome? selectOption({
    required TimelineGameDomain game,
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
