import 'package:flutter/foundation.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';

@immutable
sealed class TrueOrMythEvent {
  const TrueOrMythEvent();
}

final class TrueOrMythStarted extends TrueOrMythEvent {
  const TrueOrMythStarted(this.game);

  final TrueOrMythGameDomain game;
}

final class TrueOrMythOptionSelected extends TrueOrMythEvent {
  const TrueOrMythOptionSelected(this.optionId);

  final String optionId;
}

final class TrueOrMythNextPressed extends TrueOrMythEvent {
  const TrueOrMythNextPressed();
}
