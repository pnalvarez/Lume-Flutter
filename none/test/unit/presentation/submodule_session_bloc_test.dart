import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/domain/models/game/submodule_games_domain.dart';
import 'package:lume/layers/domain/models/trail/trail_progress_domain.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';
import 'package:lume/layers/domain/usecases/get_submodule_games.dart';
import 'package:lume/layers/domain/usecases/save_pair_progress.dart';
import 'package:lume/layers/presentation/screens/trail/submodule_session/submodule_session_bloc.dart';
import 'package:lume/layers/presentation/screens/trail/submodule_session/submodule_session_event.dart';
import 'package:lume/layers/presentation/screens/trail/submodule_session/submodule_session_state.dart';

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
    );
  }
}

void main() {
  group('SubmoduleSessionBloc', () {
    late _SavePair save;

    setUp(() {
      save = _SavePair();
    });

    blocTest<SubmoduleSessionBloc, SubmoduleSessionState>(
      'does not persist until all games finish',
      build: () => SubmoduleSessionBloc(_GetGames(), save),
      act: (bloc) async {
        bloc.add(const SubmoduleSessionStarted(trailId: 1, submoduleId: 1));
        await Future<void>.delayed(Duration.zero);
        bloc.add(const SubmoduleSessionPreviewContinue());
        bloc.add(const SubmoduleSessionGameFinished(true));
      },
      wait: const Duration(milliseconds: 10),
      verify: (_) {
        expect(save.calls, isEmpty);
      },
    );

    blocTest<SubmoduleSessionBloc, SubmoduleSessionState>(
      'flushes all pair scores only after the last game',
      build: () => SubmoduleSessionBloc(_GetGames(), save),
      act: (bloc) async {
        bloc.add(const SubmoduleSessionStarted(trailId: 1, submoduleId: 1));
        await Future<void>.delayed(Duration.zero);
        bloc.add(const SubmoduleSessionPreviewContinue());
        bloc.add(const SubmoduleSessionGameFinished(true));
        await Future<void>.delayed(Duration.zero);
        bloc.add(const SubmoduleSessionGameFinished(false));
      },
      wait: const Duration(milliseconds: 20),
      verify: (bloc) {
        expect(save.calls.length, 2);
        expect(save.calls.map((c) => c.pairId), [10, 11]);
        expect(bloc.state.stage, SubmoduleSessionStage.completed);
        expect(bloc.state.correctCount, 1);
      },
    );

    blocTest<SubmoduleSessionBloc, SubmoduleSessionState>(
      'abandon discards memory without saving',
      build: () => SubmoduleSessionBloc(_GetGames(), save),
      act: (bloc) async {
        bloc.add(const SubmoduleSessionStarted(trailId: 1, submoduleId: 1));
        await Future<void>.delayed(Duration.zero);
        bloc.add(const SubmoduleSessionPreviewContinue());
        bloc.add(const SubmoduleSessionGameFinished(true));
        await Future<void>.delayed(Duration.zero);
        bloc.add(const SubmoduleSessionAbandoned());
      },
      wait: const Duration(milliseconds: 20),
      verify: (bloc) {
        expect(save.calls, isEmpty);
        expect(bloc.state.pairScores, isEmpty);
        expect(bloc.state.goBackToTrail, isTrue);
      },
    );
  });
}
