import 'package:flutter/foundation.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';

@immutable
sealed class BattleOfCuriositiesEvent {
  const BattleOfCuriositiesEvent();
}

final class BattleOfCuriositiesStarted extends BattleOfCuriositiesEvent {
  const BattleOfCuriositiesStarted(this.game);

  final BattleOfCuriositiesGameDomain game;
}

final class BattleOfCuriositiesOptionSelected extends BattleOfCuriositiesEvent {
  const BattleOfCuriositiesOptionSelected(this.optionId);

  final String optionId;
}

final class BattleOfCuriositiesNextPressed extends BattleOfCuriositiesEvent {
  const BattleOfCuriositiesNextPressed();
}
