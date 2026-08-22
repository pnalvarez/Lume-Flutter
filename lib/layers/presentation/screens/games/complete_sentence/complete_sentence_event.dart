import 'package:flutter/foundation.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';

@immutable
sealed class CompleteSentenceEvent {
  const CompleteSentenceEvent();
}

final class CompleteSentenceStarted extends CompleteSentenceEvent {
  const CompleteSentenceStarted(this.game);

  final CompleteSentenceGameDomain game;
}

final class CompleteSentenceBlankSelected extends CompleteSentenceEvent {
  const CompleteSentenceBlankSelected({
    required this.blankOrder,
    required this.option,
  });

  final int blankOrder;
  final String option;
}

final class CompleteSentenceSubmit extends CompleteSentenceEvent {
  const CompleteSentenceSubmit();
}

final class CompleteSentenceNext extends CompleteSentenceEvent {
  const CompleteSentenceNext();
}
