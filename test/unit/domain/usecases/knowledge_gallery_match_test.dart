import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/domain/models/game/finished_game_match_domain.dart';
import 'package:lume/layers/domain/models/game/hub_game_domain.dart';
import 'package:lume/layers/domain/models/game/hub_game_round_domain.dart';
import 'package:lume/layers/domain/models/game/knowledge_gallery_round.dart';
import 'package:lume/layers/domain/models/game/submodule_games_domain.dart';
import 'package:lume/layers/domain/repository/game_repository.dart';
import 'package:lume/layers/domain/usecases/finish_game_match.dart';
import 'package:lume/layers/domain/usecases/knowledge_gallery_match.dart';
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
    expect(totalQuestions, knowledgeGalleryRoundsPerMatch);
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
  test(
    'start and finish use hub match use cases with galeria_conhecimento',
    () async {
      final games = _Games();
      final sut = KnowledgeGalleryMatch(
        StartGameMatch(games),
        FinishGameMatch(games),
      );

      final matchId = await sut.start();
      final finished = await sut.finish(
        matchId: matchId,
        score: 40,
        correctCount: 4,
      );

      expect(games.startedSlugs, [knowledgeGalleryGameSlug]);
      expect(knowledgeGalleryGameSlug, 'galeria_conhecimento');
      expect(finished.xpEarned, 12);
      expect(games.finishCalls, 1);
      expect(games.getGameRoundCalls, 0);
    },
  );
}
