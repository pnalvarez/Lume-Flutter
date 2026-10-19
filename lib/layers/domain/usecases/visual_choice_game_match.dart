import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/models/game/finished_game_match_domain.dart';
import 'package:lume/layers/domain/models/game/visual_choice_game_config.dart';
import 'package:lume/layers/domain/usecases/finish_game_match.dart';
import 'package:lume/layers/domain/usecases/start_game_match.dart';

/// Opens and closes a visual-choice match through the hub match use cases.
///
/// The caller supplies the config [gameSlug]; nothing here hardcodes a
/// visual slug. Does not call `get_game_round` or `save_pair_progress`.
abstract interface class IVisualChoiceGameMatch {
  Future<String> start({required String gameSlug});

  Future<FinishedGameMatchDomain> finish({
    required String matchId,
    required int score,
    required int correctCount,
    int totalQuestions = visualChoiceGameRoundsPerMatch,
    int? durationSeconds,
  });
}

@Injectable(as: IVisualChoiceGameMatch)
class VisualChoiceGameMatch implements IVisualChoiceGameMatch {
  VisualChoiceGameMatch(this._startGameMatch, this._finishGameMatch);

  final IStartGameMatch _startGameMatch;
  final IFinishGameMatch _finishGameMatch;

  @override
  Future<String> start({required String gameSlug}) {
    return _startGameMatch(gameSlug: gameSlug);
  }

  @override
  Future<FinishedGameMatchDomain> finish({
    required String matchId,
    required int score,
    required int correctCount,
    int totalQuestions = visualChoiceGameRoundsPerMatch,
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
