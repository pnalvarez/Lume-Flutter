import 'dart:math';

import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/models/game/knowledge_gallery_round.dart';
import 'package:lume/layers/domain/usecases/get_knowledge_gallery_round.dart';
import 'package:lume/layers/domain/usecases/get_random_game_round.dart';
import 'package:lume/layers/presentation/screens/games/game_round.dart';

/// One Arcade question.
///
/// `get_random_game_round` only returns trail games. When
/// [knowledgeGalleryGameSlug] is allowlisted it takes one equal slot and is
/// loaded with a single visual item. A trail draw drops that slug. When the
/// slug is absent, the allowlist is passed through unchanged.
abstract interface class IDrawArcadeRound {
  Future<GameRound?> call({required List<String> enabledSlugs});
}

@Injectable(as: IDrawArcadeRound)
class DrawArcadeRound implements IDrawArcadeRound {
  DrawArcadeRound(this._getRandomGameRound, this._getKnowledgeGalleryRound);

  final IGetRandomGameRound _getRandomGameRound;
  final IGetKnowledgeGalleryRound _getKnowledgeGalleryRound;
  final Random _random = Random();

  @override
  Future<GameRound?> call({required List<String> enabledSlugs}) async {
    if (enabledSlugs.isNotEmpty &&
        _isKnowledgeGallery(
          enabledSlugs,
          _random.nextInt(enabledSlugs.length),
        )) {
      final rounds = await _getKnowledgeGalleryRound(count: 1);
      // Empty gallery must not end the arcade run — fall through to a trail
      // draw so a missing visual question is treated as a miss on that slug.
      if (rounds.isNotEmpty) {
        final round = rounds.first;
        return GameRound(id: '${round.questionId}', gallery: round);
      }
    }

    final game = await _getRandomGameRound(
      enabledSlugs: _trailSlugs(enabledSlugs),
    );
    if (game == null) return null;
    return GameRound(id: '${game.pairId}', game: game);
  }

  /// Each allowlisted slug has an equal chance. An empty list never draws it.
  bool _isKnowledgeGallery(List<String> enabledSlugs, int roll) {
    if (enabledSlugs.isEmpty) return false;
    final index = roll.abs() % enabledSlugs.length;
    return enabledSlugs[index] == knowledgeGalleryGameSlug;
  }

  /// Slugs to pass to `get_random_game_round`.
  ///
  /// That RPC skips Knowledge Gallery, so the gallery slug is removed when it
  /// is allowlisted. The original list is returned when the slug is absent.
  List<String> _trailSlugs(List<String> enabledSlugs) {
    if (!enabledSlugs.contains(knowledgeGalleryGameSlug)) return enabledSlugs;
    return [
      for (final slug in enabledSlugs)
        if (slug != knowledgeGalleryGameSlug) slug,
    ];
  }
}
