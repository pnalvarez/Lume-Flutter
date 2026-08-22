import 'package:flutter/foundation.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';

@immutable
sealed class LightningQuizEvent {
  const LightningQuizEvent();
}

final class LightningQuizStarted extends LightningQuizEvent {
  const LightningQuizStarted(this.game);

  final LightningQuizGameDomain game;
}

final class LightningQuizOptionSelected extends LightningQuizEvent {
  const LightningQuizOptionSelected(this.optionId);

  final String optionId;
}

final class LightningQuizNextPressed extends LightningQuizEvent {
  const LightningQuizNextPressed();
}
