import 'package:flutter/foundation.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';

@immutable
sealed class TimelineEvent {
  const TimelineEvent();
}

final class TimelineStarted extends TimelineEvent {
  const TimelineStarted(this.game);

  final TimelineGameDomain game;
}

final class TimelineOptionSelected extends TimelineEvent {
  const TimelineOptionSelected(this.optionId);

  final String optionId;
}

final class TimelineNextPressed extends TimelineEvent {
  const TimelineNextPressed();
}
