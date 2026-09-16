import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/core/analytics/analytics.dart';
import 'package:lume/layers/domain/helpers/trail_progress_calculator.dart';
import 'package:lume/layers/domain/models/game/submodule_games_domain.dart';
import 'package:lume/layers/domain/models/trail/trail_progress_domain.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';
import 'package:lume/layers/domain/usecases/get_submodule_games.dart';
import 'package:lume/layers/domain/usecases/save_pair_progress.dart';
import 'package:lume/layers/presentation/screens/games/games_complete_body.dart';
import 'package:lume/layers/presentation/screens/trail/submodule_session/submodule_session_bloc.dart';
import 'package:lume/layers/presentation/screens/trail/submodule_session/submodule_session_event.dart';
import 'package:lume/layers/presentation/screens/trail/submodule_session/submodule_session_state.dart';
import '../../helpers/fake_analytics.dart';

class _GetGames implements IGetSubmoduleGames {
  @override
  Future<SubmoduleGamesDomain> call({
    required int submoduleId,
    bool forceRefresh = false,
  }) async {
    return const SubmoduleGamesDomain(
      id: 1,
      title: 'Sub',
      sortOrder: 1,
      preview: 'Preview text',
      games: [
        LightningQuizGameDomain(
          pairId: 10,
          sortOrder: 1,
          prompt: 'Q1',
          options: ['a', 'b'],
          correctIndex: 0,
          explanation: 'e1',
        ),
        LightningQuizGameDomain(
          pairId: 11,
          sortOrder: 2,
          prompt: 'Q2',
          options: ['a', 'b'],
          correctIndex: 1,
          explanation: 'e2',
        ),
      ],
    );
  }
}

class _SavePair implements ISavePairProgress {
  final calls = <({int pairId, int scorePct})>[];

  @override
  Future<PairProgressDomain> call({
    required int pairId,
    required int scorePct,
  }) async {
    calls.add((pairId: pairId, scorePct: scorePct));
    return PairProgressDomain(
      pairId: pairId,
      scorePct: scorePct,
      completed: scorePct >= 60,
      xpAwarded: 0,
    );
  }
}

void main() {
  group('SubmoduleSessionBloc', () {
    late _SavePair save;
    late FakeAnalytics analytics;
    final progressCalculator = TrailProgressCalculator();

    setUp(() {
      save = _SavePair();
      analytics = FakeAnalytics();
    });

    SubmoduleSessionBloc buildBloc() =>
        SubmoduleSessionBloc(_GetGames(), save, progressCalculator, analytics);

    blocTest<SubmoduleSessionBloc, SubmoduleSessionState>(
      'buffers round scores without persisting until games completed',
      build: buildBloc,
      act: (bloc) async {
        bloc.add(const SubmoduleSessionStarted(trailId: 1, submoduleId: 1));
        await Future<void>.delayed(Duration.zero);
        bloc.add(const SubmoduleSessionRoundScored(pairId: 10, scorePct: 100));
      },
      wait: const Duration(milliseconds: 10),
      verify: (bloc) {
        expect(save.calls, isEmpty);
        expect(bloc.state.pairScores[10], 100);
      },
    );

    blocTest<SubmoduleSessionBloc, SubmoduleSessionState>(
      'flushes all pair scores only after games completed',
      build: buildBloc,
      act: (bloc) async {
        bloc.add(const SubmoduleSessionStarted(trailId: 1, submoduleId: 1));
        await Future<void>.delayed(Duration.zero);
        bloc.add(const SubmoduleSessionRoundScored(pairId: 10, scorePct: 100));
        bloc.add(const SubmoduleSessionRoundScored(pairId: 11, scorePct: 0));
        bloc.add(const SubmoduleSessionGamesCompleted(correctCount: 1));
      },
      wait: const Duration(milliseconds: 20),
      verify: (bloc) {
        expect(save.calls.length, 2);
        expect(save.calls.map((c) => c.pairId), [10, 11]);
        expect(bloc.state.stage, SubmoduleSessionStage.completed);
        expect(bloc.state.correctCount, 1);
        expect(bloc.state.completeStatus, GamesCompleteStatus.failure);
        expect(bloc.state.completeUnlockMessage, isNotEmpty);
        expect(
          analytics.hasEvent(AnalyticsEvents.submoduleSessionStarted),
          isTrue,
        );
        expect(
          analytics.hasEvent(AnalyticsEvents.submoduleSessionCompleted),
          isTrue,
        );
      },
    );

    blocTest<SubmoduleSessionBloc, SubmoduleSessionState>(
      'marks complete as success when pass average is met',
      build: buildBloc,
      act: (bloc) async {
        bloc.add(const SubmoduleSessionStarted(trailId: 1, submoduleId: 1));
        await Future<void>.delayed(Duration.zero);
        bloc.add(const SubmoduleSessionRoundScored(pairId: 10, scorePct: 100));
        bloc.add(const SubmoduleSessionRoundScored(pairId: 11, scorePct: 100));
        bloc.add(const SubmoduleSessionGamesCompleted(correctCount: 2));
      },
      wait: const Duration(milliseconds: 20),
      verify: (bloc) {
        expect(bloc.state.stage, SubmoduleSessionStage.completed);
        expect(bloc.state.completeStatus, GamesCompleteStatus.success);
      },
    );

    blocTest<SubmoduleSessionBloc, SubmoduleSessionState>(
      'games cancelled discards memory without saving',
      build: buildBloc,
      act: (bloc) async {
        bloc.add(const SubmoduleSessionStarted(trailId: 1, submoduleId: 1));
        await Future<void>.delayed(Duration.zero);
        bloc.add(const SubmoduleSessionRoundScored(pairId: 10, scorePct: 100));
        bloc.add(const SubmoduleSessionGamesCancelled());
      },
      wait: const Duration(milliseconds: 20),
      verify: (bloc) {
        expect(save.calls, isEmpty);
        expect(bloc.state.pairScores, isEmpty);
        expect(bloc.state.stage, SubmoduleSessionStage.preview);
        expect(
          analytics.parametersFor(AnalyticsEvents.submoduleSessionAbandoned),
          {
            AnalyticsParams.trailId: 1,
            AnalyticsParams.submoduleId: 1,
            AnalyticsParams.reason: 'games_cancelled',
            AnalyticsParams.gamesPlayed: 1,
            AnalyticsParams.roundsTotal: 2,
          },
        );
      },
    );

    blocTest<SubmoduleSessionBloc, SubmoduleSessionState>(
      'abandon discards memory without saving',
      build: buildBloc,
      act: (bloc) async {
        bloc.add(const SubmoduleSessionStarted(trailId: 1, submoduleId: 1));
        await Future<void>.delayed(Duration.zero);
        bloc.add(const SubmoduleSessionRoundScored(pairId: 10, scorePct: 100));
        bloc.add(const SubmoduleSessionAbandoned());
      },
      wait: const Duration(milliseconds: 20),
      verify: (bloc) {
        expect(save.calls, isEmpty);
        expect(bloc.state.pairScores, isEmpty);
        expect(bloc.state.goBackToTrail, isTrue);
        expect(
          analytics.parametersFor(AnalyticsEvents.submoduleSessionAbandoned),
          {
            AnalyticsParams.trailId: 1,
            AnalyticsParams.submoduleId: 1,
            AnalyticsParams.reason: 'leave',
            AnalyticsParams.gamesPlayed: 1,
            AnalyticsParams.roundsTotal: 2,
          },
        );
      },
    );
  });
}
