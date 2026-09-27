import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/models/game/finished_game_match_domain.dart';
import 'package:lume/layers/domain/repository/game_repository.dart';

/// Closes a hub match so game achievements can count it.
abstract interface class IFinishGameMatch {
  Future<FinishedGameMatchDomain> call({
    required String matchId,
    required int score,
    required int correctCount,
    required int totalQuestions,
    int? durationSeconds,
    Map<String, Object?>? metadata,
  });
}

@Injectable(as: IFinishGameMatch)
class FinishGameMatch implements IFinishGameMatch {
  FinishGameMatch(this._repository);

  final IGameRepository _repository;

  @override
  Future<FinishedGameMatchDomain> call({
    required String matchId,
    required int score,
    required int correctCount,
    required int totalQuestions,
    int? durationSeconds,
    Map<String, Object?>? metadata,
  }) {
    return _repository.finishGameMatch(
      matchId: matchId,
      score: score,
      correctCount: correctCount,
      totalQuestions: totalQuestions,
      durationSeconds: durationSeconds,
      metadata: metadata,
    );
  }
}
