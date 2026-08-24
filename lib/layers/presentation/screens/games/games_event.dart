import 'package:lume/layers/presentation/screens/games/game_round.dart';

sealed class GamesEvent {
  const GamesEvent();
}

final class GamesStarted extends GamesEvent {
  const GamesStarted({required this.rounds, required this.onSaveRound});

  final List<GameRound> rounds;
  final GamesRoundSave onSaveRound;
}

final class GamesChoiceSelected extends GamesEvent {
  const GamesChoiceSelected(this.optionId);

  final String optionId;
}

final class GamesWhoAmIAnswerChanged extends GamesEvent {
  const GamesWhoAmIAnswerChanged(this.answer);

  final String answer;
}

final class GamesWhoAmIRevealHint extends GamesEvent {
  const GamesWhoAmIRevealHint();
}

final class GamesWhoAmISubmit extends GamesEvent {
  const GamesWhoAmISubmit();
}

final class GamesCompleteSentenceBlankSelected extends GamesEvent {
  const GamesCompleteSentenceBlankSelected({
    required this.blankOrder,
    required this.option,
  });

  final int blankOrder;
  final String option;
}

final class GamesCompleteSentenceSubmit extends GamesEvent {
  const GamesCompleteSentenceSubmit();
}

final class GamesConnectionsLeftSelected extends GamesEvent {
  const GamesConnectionsLeftSelected(this.leftId);

  final String leftId;
}

final class GamesConnectionsRightSelected extends GamesEvent {
  const GamesConnectionsRightSelected(this.rightId);

  final String rightId;
}

final class GamesConnectionsUndoLast extends GamesEvent {
  const GamesConnectionsUndoLast();
}

final class GamesConnectionsSubmit extends GamesEvent {
  const GamesConnectionsSubmit();
}

final class GamesMysteriousWordLetterPressed extends GamesEvent {
  const GamesMysteriousWordLetterPressed(this.letter);

  final String letter;
}

final class GamesNextPressed extends GamesEvent {
  const GamesNextPressed();
}

final class GamesRetrySave extends GamesEvent {
  const GamesRetrySave();
}

final class GamesAbandoned extends GamesEvent {
  const GamesAbandoned();
}

final class GamesNavigationHandled extends GamesEvent {
  const GamesNavigationHandled();
}
