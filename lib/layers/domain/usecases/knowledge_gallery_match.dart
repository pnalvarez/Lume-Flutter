import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/models/game/finished_game_match_domain.dart';
import 'package:lume/layers/domain/models/game/knowledge_gallery_round.dart';
import 'package:lume/layers/domain/usecases/finish_game_match.dart';
import 'package:lume/layers/domain/usecases/start_game_match.dart';

/// Opens and closes a Knowledge Gallery match through the hub match use cases.
///
/// Always uses [knowledgeGalleryGameSlug]. Does not call `get_game_round` or
/// `save_pair_progress`.
abstract interface class IKnowledgeGalleryMatch {
  Future<String> start();

  Future<FinishedGameMatchDomain> finish({
    required String matchId,
    required int score,
    required int correctCount,
    int totalQuestions = knowledgeGalleryRoundsPerMatch,
    int? durationSeconds,
  });
}

@Injectable(as: IKnowledgeGalleryMatch)
class KnowledgeGalleryMatch implements IKnowledgeGalleryMatch {
  KnowledgeGalleryMatch(this._startGameMatch, this._finishGameMatch);

  final IStartGameMatch _startGameMatch;
  final IFinishGameMatch _finishGameMatch;

  @override
  Future<String> start() {
    return _startGameMatch(gameSlug: knowledgeGalleryGameSlug);
  }

  @override
  Future<FinishedGameMatchDomain> finish({
    required String matchId,
    required int score,
    required int correctCount,
    int totalQuestions = knowledgeGalleryRoundsPerMatch,
    int? durationSeconds,
  }) {
    return _finishGameMatch(
      matchId: matchId,
      score: score,
      correctCount: correctCount,
      totalQuestions: totalQuestions,
      durationSeconds: durationSeconds,
    );
  }
}
