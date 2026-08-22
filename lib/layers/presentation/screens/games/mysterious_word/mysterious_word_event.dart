import 'package:flutter/foundation.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';

@immutable
sealed class MysteriousWordEvent {
  const MysteriousWordEvent();
}

final class MysteriousWordStarted extends MysteriousWordEvent {
  const MysteriousWordStarted(this.game);

  final MysteriousWordGameDomain game;
}

final class MysteriousWordLetterPressed extends MysteriousWordEvent {
  const MysteriousWordLetterPressed(this.letter);

  final String letter;
}

final class MysteriousWordNext extends MysteriousWordEvent {
  const MysteriousWordNext();
}
