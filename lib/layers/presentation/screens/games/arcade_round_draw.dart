import 'dart:math';

import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/models/game/visual_choice_game_config.dart';
import 'package:lume/layers/domain/usecases/get_random_game_round.dart';
import 'package:lume/layers/domain/usecases/get_visual_choice_game_round.dart';
import 'package:lume/layers/presentation/screens/games/game_round.dart';

/// One Arcade question.
///
/// `get_random_game_round` only returns trail games. When a known visual
/// slug (see [visualChoiceGameSlugs]) is allowlisted it takes one equal
/// slot and is loaded with a single visual item for that slug. A trail
/// draw drops every visual slug. When no visual slug is present, the
/// allowlist is passed through unchanged.
abstract interface class IDrawArcadeRound {
  Future<GameRound?> call({required List<String> enabledSlugs});
}

@Injectable(as: IDrawArcadeRound)
class DrawArcadeRound implements IDrawArcadeRound {
  DrawArcadeRound(this._getRandomGameRound, this._getVisualChoiceGameRound);

  final IGetRandomGameRound _getRandomGameRound;
  final IGetVisualChoiceGameRound _getVisualChoiceGameRound;
  final Random _random = Random();

  @override
  Future<GameRound?> call({required List<String> enabledSlugs}) async {
    if (enabledSlugs.isNotEmpty) {
      final picked = enabledSlugs[_random.nextInt(enabledSlugs.length)];
      if (VisualChoiceGameConfig.isVisualGameSlug(picked)) {
        final config = VisualChoiceGameConfig.forSlug(picked);
        final rounds = await _getVisualChoiceGameRound(
          gameSlug: config.gameSlug,
          count: 1,
        );
        // Empty visual game must not end the arcade run — fall through to
        // a trail draw so a missing visual question is treated as a miss
        // on that slug.
        if (rounds.isNotEmpty) {
          final round = rounds.first;
          return GameRound(
            id: '${round.questionId}',
            visual: round,
            visualConfig: config,
          );
        }
      }
    }

    final game = await _getRandomGameRound(
      enabledSlugs: _trailSlugs(enabledSlugs),
    );
    if (game == null) return null;
    return GameRound(id: '${game.pairId}', game: game);
  }

  /// Slugs to pass to `get_random_game_round`.
  ///
  /// That RPC skips visual-choice games, so every known visual slug is
  /// removed when allowlisted. The original list is returned when no
  /// visual slug is present.
  List<String> _trailSlugs(List<String> enabledSlugs) {
    if (!enabledSlugs.any(VisualChoiceGameConfig.isVisualGameSlug)) {
      return enabledSlugs;
    }
    return [
      for (final slug in enabledSlugs)
        if (!VisualChoiceGameConfig.isVisualGameSlug(slug)) slug,
    ];
  }
}
