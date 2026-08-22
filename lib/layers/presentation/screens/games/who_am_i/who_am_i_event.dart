import 'package:flutter/foundation.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';

@immutable
sealed class WhoAmIEvent {
  const WhoAmIEvent();
}

final class WhoAmIStarted extends WhoAmIEvent {
  const WhoAmIStarted(this.game);

  final WhoAmIGameDomain game;
}

final class WhoAmIAnswerChanged extends WhoAmIEvent {
  const WhoAmIAnswerChanged(this.answer);

  final String answer;
}

final class WhoAmIRevealHint extends WhoAmIEvent {
  const WhoAmIRevealHint();
}

final class WhoAmISubmit extends WhoAmIEvent {
  const WhoAmISubmit();
}

final class WhoAmINext extends WhoAmIEvent {
  const WhoAmINext();
}
