import 'package:lume/layers/domain/models/game/finished_game_match_domain.dart';
import 'package:lume/layers/domain/models/game/hub_game_domain.dart';
import 'package:lume/layers/domain/models/game/hub_game_round_domain.dart';
import 'package:lume/layers/domain/models/game/submodule_games_domain.dart';

abstract interface class IGameRepository {
  Future<SubmoduleGamesDomain> getSubmoduleGames({
    required int submoduleId,
    bool forceRefresh = false,
  });

  Future<List<HubGameDomain>> getHubGames({bool forceRefresh = false});

  Future<HubGameRoundDomain> getGameRound({
    required String gameSlug,
    int limit = 5,
  });

  /// One random playable round picked by the backend, for arcade mode.
  Future<HubGameRoundDomain> getRandomGameRound();

  /// Inserts an open `game_matches` row and returns its id.
  Future<String> startGameMatch({required String gameSlug});

  /// Marks the match finished and refreshes achievement progress.
  Future<FinishedGameMatchDomain> finishGameMatch({
    required String matchId,
    required int score,
    required int correctCount,
    required int totalQuestions,
    int? durationSeconds,
    Map<String, Object?>? metadata,
  });
}
