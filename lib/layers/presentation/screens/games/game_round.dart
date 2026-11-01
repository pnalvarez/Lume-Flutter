import 'package:flutter/foundation.dart';
import 'package:lume/layers/domain/models/game/visual_choice_game_config.dart';
import 'package:lume/layers/domain/models/game/visual_choice_game_round.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';

/// One playable unit in a [GamesPage] sequence.
///
/// [id] is opaque to the games screen — callers use it in [GamesRoundSave]
/// (e.g. trail pair id as a string). A round is either a trail [game] or a
/// visual-choice [visual] question, which also carries its
/// [visualConfig] (slug + analytics events) so hosts never hardcode a
/// visual game.
@immutable
final class GameRound {
  const GameRound({required this.id, this.game, this.visual, this.visualConfig})
    : assert(
        (game != null) != (visual != null),
        'GameRound needs a trail game or a visual question',
      ),
      assert(
        visual == null || visualConfig != null,
        'A visual GameRound needs its VisualChoiceGameConfig',
      );

  final String id;
  final TrailGameDomain? game;
  final VisualChoiceGameRound? visual;
  final VisualChoiceGameConfig? visualConfig;

  /// Visual game slug for a [visual] round, null for trail rounds.
  String? get visualGameSlug => visualConfig?.gameSlug;

  @override
  bool operator ==(Object other) =>
      other is GameRound &&
      other.id == id &&
      other.game == game &&
      other.visual == visual &&
      other.visualConfig == visualConfig;

  @override
  int get hashCode => Object.hash(id, game, visual, visualConfig);
}

/// Persists a finished round. Implemented by the caller (trail preview, hub, …).
/// Returns XP awarded by the backend for this round (0 when none / already claimed).
typedef GamesRoundSave =
    Future<int> Function({required String roundId, required int scorePct});

/// Result popped from [GamesPage] when the full sequence finishes successfully.
@immutable
final class GamesSequenceResult {
  const GamesSequenceResult({required this.correctCount, required this.total});

  final int correctCount;
  final int total;
}
