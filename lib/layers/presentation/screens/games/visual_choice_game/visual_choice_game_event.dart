import 'package:flutter/foundation.dart';
import 'package:lume/layers/domain/models/game/visual_choice_game_config.dart';
import 'package:lume/layers/domain/models/game/visual_choice_game_round.dart';

@immutable
sealed class VisualChoiceGameEvent {
  const VisualChoiceGameEvent();
}

final class VisualChoiceGameStarted extends VisualChoiceGameEvent {
  const VisualChoiceGameStarted({
    required this.rounds,
    required this.matchId,
    required this.config,
  });

  final List<VisualChoiceGameRound> rounds;
  final String matchId;

  /// Visual game being played (slug + analytics event names).
  final VisualChoiceGameConfig config;
}

final class VisualChoiceGameOptionSelected extends VisualChoiceGameEvent {
  const VisualChoiceGameOptionSelected(this.optionId);

  /// Index in the current options, as `'0'` … `'3'`.
  final String optionId;
}

final class VisualChoiceGameNextPressed extends VisualChoiceGameEvent {
  const VisualChoiceGameNextPressed();
}

final class VisualChoiceGameAbandoned extends VisualChoiceGameEvent {
  const VisualChoiceGameAbandoned();
}

/// Artwork failed to resolve or load. No URL — analytics only.
final class VisualChoiceGameImageFailed extends VisualChoiceGameEvent {
  const VisualChoiceGameImageFailed();
}

final class VisualChoiceGameNavigationHandled extends VisualChoiceGameEvent {
  const VisualChoiceGameNavigationHandled();
}

final class VisualChoiceGameSnackShown extends VisualChoiceGameEvent {
  const VisualChoiceGameSnackShown();
}
