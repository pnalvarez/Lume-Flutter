import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/domain/models/trail/trail_progress_domain.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';
import 'package:lume/layers/domain/usecases/games/play_battle_of_curiosities.dart';
import 'package:lume/layers/domain/usecases/games/play_complete_sentence.dart';
import 'package:lume/layers/domain/usecases/games/play_connections.dart';
import 'package:lume/layers/domain/usecases/games/play_lightning_quiz.dart';
import 'package:lume/layers/domain/usecases/games/play_mysterious_word.dart';
import 'package:lume/layers/domain/usecases/games/play_timeline.dart';
import 'package:lume/layers/domain/usecases/games/play_true_or_myth.dart';
import 'package:lume/layers/domain/usecases/games/play_who_am_i.dart';
import 'package:lume/layers/domain/usecases/save_pair_progress.dart';
import 'package:lume/layers/presentation/screens/games/game_round.dart';
import 'package:lume/layers/presentation/screens/games/games_bloc.dart';
import 'package:lume/layers/presentation/screens/games/games_event.dart';
import 'package:lume/layers/presentation/screens/games/games_state.dart';

const _quiz1 = LightningQuizGameDomain(
  pairId: 10,
  sortOrder: 1,
  prompt: 'Q1',
  options: ['a', 'b'],
  correctIndex: 0,
  explanation: 'e1',
);

const _quiz2 = LightningQuizGameDomain(
  pairId: 11,
  sortOrder: 2,
  prompt: 'Q2',
  options: ['a', 'b'],
  correctIndex: 1,
  explanation: 'e2',
);

class _SavePairProgress implements ISavePairProgress {
  final calls = <({int pairId, int scorePct})>[];
  int xpAwarded = 0;

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
      xpAwarded: xpAwarded,
    );
  }
}

GamesBloc createGamesBloc(_SavePairProgress save) => GamesBloc(
  PlayLightningQuiz(),
  PlayTimeline(),
  PlayTrueOrMyth(),
  PlayBattleOfCuriosities(),
  PlayWhoAmI(),
  PlayCompleteSentence(),
  PlayConnections(),
  PlayMysteriousWord(),
  save,
);

void main() {
  group('GamesBloc', () {
    late List<({String roundId, int scorePct})> saves;
    late _SavePairProgress savePair;

    setUp(() {
      saves = [];
      savePair = _SavePairProgress();
    });

    const rounds = [
      GameRound(id: '10', game: _quiz1),
      GameRound(id: '11', game: _quiz2),
    ];

    Future<int> onSaveRound({
      required String roundId,
      required int scorePct,
    }) async {
      saves.add((roundId: roundId, scorePct: scorePct));
      return 0;
    }

    blocTest<GamesBloc, GamesState>(
      'advances after correct choice and save, increments progress',
      build: () => createGamesBloc(savePair),
      act: (bloc) async {
        bloc.add(
          GamesStarted(
            rounds: rounds,
            mode: GamesPlayMode.trail,
            onSaveRound: onSaveRound,
          ),
        );
        bloc.add(const GamesChoiceSelected('0'));
        bloc.add(const GamesNextPressed());
      },
      wait: const Duration(milliseconds: 10),
      verify: (bloc) {
        expect(saves, [(roundId: '10', scorePct: 100)]);
        expect(bloc.state.currentIndex, 1);
        expect(bloc.state.completedCount, 1);
        expect(bloc.state.progressValue, 0.5);
        expect(bloc.state.answered, isFalse);
      },
    );

    blocTest<GamesBloc, GamesState>(
      'completes sequence after last round save',
      build: () => createGamesBloc(savePair),
      act: (bloc) async {
        bloc.add(
          GamesStarted(
            rounds: rounds,
            mode: GamesPlayMode.trail,
            onSaveRound: onSaveRound,
          ),
        );
        bloc.add(const GamesChoiceSelected('0'));
        bloc.add(const GamesNextPressed());
        await Future<void>.delayed(Duration.zero);
        bloc.add(const GamesChoiceSelected('1'));
        bloc.add(const GamesNextPressed());
      },
      wait: const Duration(milliseconds: 20),
      verify: (bloc) {
        expect(saves.length, 2);
        expect(bloc.state.sequenceCompleted, isTrue);
        expect(bloc.state.correctCount, 2);
        expect(bloc.state.progressValue, 1.0);
      },
    );

    blocTest<GamesBloc, GamesState>(
      'records incorrect score via save callback',
      build: () => createGamesBloc(savePair),
      act: (bloc) async {
        bloc.add(
          GamesStarted(
            rounds: rounds,
            mode: GamesPlayMode.trail,
            onSaveRound: onSaveRound,
          ),
        );
        bloc.add(const GamesChoiceSelected('1'));
        bloc.add(const GamesNextPressed());
      },
      wait: const Duration(milliseconds: 10),
      verify: (_) {
        expect(saves, [(roundId: '10', scorePct: 0)]);
      },
    );

    blocTest<GamesBloc, GamesState>(
      'hub mode persists via save_pair_progress on next',
      build: () {
        savePair.xpAwarded = 8;
        return createGamesBloc(savePair);
      },
      act: (bloc) async {
        bloc.add(const GamesStarted(rounds: rounds, mode: GamesPlayMode.hub));
        bloc.add(const GamesChoiceSelected('0'));
        bloc.add(const GamesNextPressed());
      },
      wait: const Duration(milliseconds: 10),
      verify: (bloc) {
        expect(savePair.calls, [(pairId: 10, scorePct: 100)]);
        expect(saves, isEmpty);
        expect(bloc.state.xpAwardedToShow, 8);
      },
    );
  });
}
