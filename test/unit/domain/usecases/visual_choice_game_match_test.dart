import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/domain/models/game/finished_game_match_domain.dart';
import 'package:lume/layers/domain/models/game/hub_game_domain.dart';
import 'package:lume/layers/domain/models/game/hub_game_round_domain.dart';
import 'package:lume/layers/domain/models/game/visual_choice_game_config.dart';
import 'package:lume/layers/domain/models/game/submodule_games_domain.dart';
import 'package:lume/layers/domain/repository/game_repository.dart';
import 'package:lume/layers/domain/usecases/finish_game_match.dart';
import 'package:lume/layers/domain/usecases/visual_choice_game_match.dart';
import 'package:lume/layers/domain/usecases/start_game_match.dart';

class _Games implements IGameRepository {
  final startedSlugs = <String>[];
  var finishCalls = 0;
  var getGameRoundCalls = 0;

  @override
  Future<String> startGameMatch({required String gameSlug}) async {
    startedSlugs.add(gameSlug);
    return 'match-1';
  }

  @override
  Future<FinishedGameMatchDomain> finishGameMatch({
    required String matchId,
    required int score,
    required int correctCount,
    required int totalQuestions,
    int? durationSeconds,
    Map<String, Object?>? metadata,
  }) async {
    finishCalls++;
    expect(matchId, 'match-1');
    expect(score, 40);
    expect(correctCount, 4);
    expect(totalQuestions, visualChoiceGameRoundsPerMatch);
    return const FinishedGameMatchDomain(xpEarned: 12);
  }

  @override
  Future<HubGameRoundDomain> getGameRound({
    required String gameSlug,
    int limit = 5,
  }) {
    getGameRoundCalls++;
    throw UnimplementedError();
  }

  @override
  Future<List<HubGameDomain>> getHubGames({bool forceRefresh = false}) {
    throw UnimplementedError();
  }

  @override
  Future<HubGameRoundDomain> getRandomGameRound({
    required List<String> enabledSlugs,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<SubmoduleGamesDomain> getSubmoduleGames({
    required int submoduleId,
    bool forceRefresh = false,
  }) {
    throw UnimplementedError();
  }
}

void main() {
  test('start forwards the given slug to the hub match use cases', () async {
    final games = _Games();
    final sut = VisualChoiceGameMatch(
      StartGameMatch(games),
      FinishGameMatch(games),
    );

    final matchId = await sut.start(
      gameSlug: VisualChoiceGameSlugs.facesOfHistory,
    );
    final finished = await sut.finish(
      matchId: matchId,
      score: 40,
      correctCount: 4,
    );

    expect(games.startedSlugs, [VisualChoiceGameSlugs.facesOfHistory]);
    expect(VisualChoiceGameSlugs.knowledgeGallery, 'galeria_conhecimento');
    expect(VisualChoiceGameSlugs.facesOfHistory, 'rostos_historia');
    expect(finished.xpEarned, 12);
    expect(games.finishCalls, 1);
    expect(games.getGameRoundCalls, 0);
  });
}
