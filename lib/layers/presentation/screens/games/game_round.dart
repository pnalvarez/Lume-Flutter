import 'package:flutter/foundation.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';

/// One playable unit in a [GamesPage] sequence.
///
/// [id] is opaque to the games screen — callers use it in [GamesRoundSave]
/// (e.g. trail pair id as a string). [game] holds the playable content.
@immutable
final class GameRound {
  const GameRound({required this.id, required this.game});

  final String id;
  final TrailGameDomain game;

  @override
  bool operator ==(Object other) =>
      other is GameRound && other.id == id && other.game == game;

  @override
  int get hashCode => Object.hash(id, game);
}

/// Persists a finished round. Implemented by the caller (trail preview, hub, …).
typedef GamesRoundSave =
    Future<void> Function({required String roundId, required int scorePct});

/// Result popped from [GamesPage] when the full sequence finishes successfully.
@immutable
final class GamesSequenceResult {
  const GamesSequenceResult({
    required this.correctCount,
    required this.total,
  });

  final int correctCount;
  final int total;
}
