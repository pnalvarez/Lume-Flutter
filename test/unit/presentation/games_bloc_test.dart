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
import 'package:lume/layers/domain/models/arcade/arcade_domain.dart';
import 'package:lume/layers/domain/usecases/get_random_game_round.dart';
import 'package:lume/layers/domain/usecases/save_arcade_record.dart';
import 'package:lume/layers/domain/usecases/save_arcade_round.dart';
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

class _GetRandomGameRound implements IGetRandomGameRound {
  int calls = 0;

  /// Games handed out in order; a `null` entry (or running past the end) stops
  /// the run. Leave unset to hand out [_quiz2] forever.
  List<TrailGameDomain?>? queue;

  @override
  Future<TrailGameDomain?> call() async {
    final index = calls;
    calls++;
    final pending = queue;
    if (pending == null) return _quiz2;
    if (index >= pending.length) return null;
    return pending[index];
  }
}

class _SaveArcadeRound implements ISaveArcadeRound {
  final calls = <({int pairId, int scorePct, int roundNumber})>[];
  int xpAwarded = 3;

  @override
  Future<ArcadeRoundResultDomain> call({
    required int pairId,
    required int scorePct,
    required int roundNumber,
  }) async {
    calls.add((pairId: pairId, scorePct: scorePct, roundNumber: roundNumber));
    return ArcadeRoundResultDomain(
      xpAwarded: scorePct > 0 ? xpAwarded : 0,
      isRecordRound: false,
    );
  }
}

class _SaveArcadeRecord implements ISaveArcadeRecord {
  final calls = <int>[];
  bool isNewRecord = true;

  @override
  Future<ArcadeRecordResultDomain> call({required int rounds}) async {
    calls.add(rounds);
    return ArcadeRecordResultDomain(
      bestRounds: rounds,
      isNewRecord: isNewRecord,
    );
  }
}

GamesBloc _createGamesBloc(
  _SavePairProgress save, {
  _GetRandomGameRound? getRandomRound,
  _SaveArcadeRound? saveArcadeRound,
  _SaveArcadeRecord? saveArcadeRecord,
}) => GamesBloc(
  PlayLightningQuiz(),
  PlayTimeline(),
  PlayTrueOrMyth(),
  PlayBattleOfCuriosities(),
  PlayWhoAmI(),
  PlayCompleteSentence(),
  PlayConnections(),
  PlayMysteriousWord(),
  save,
  getRandomRound ?? _GetRandomGameRound(),
  saveArcadeRound ?? _SaveArcadeRound(),
  saveArcadeRecord ?? _SaveArcadeRecord(),
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
      build: () => _createGamesBloc(savePair),
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
      build: () => _createGamesBloc(savePair),
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
      build: () => _createGamesBloc(savePair),
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
        return _createGamesBloc(savePair);
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

  group('GamesBloc arcade', () {
    late _SavePairProgress savePair;
    late _GetRandomGameRound getRandomRound;
    late _SaveArcadeRound saveRound;
    late _SaveArcadeRecord saveRecord;

    setUp(() {
      savePair = _SavePairProgress();
      getRandomRound = _GetRandomGameRound();
      saveRound = _SaveArcadeRound();
      saveRecord = _SaveArcadeRecord();
    });

    const firstRound = [GameRound(id: '10', game: _quiz1)];

    GamesBloc build() => _createGamesBloc(
      savePair,
      getRandomRound: getRandomRound,
      saveArcadeRound: saveRound,
      saveArcadeRecord: saveRecord,
    );

    blocTest<GamesBloc, GamesState>(
      'a hit appends the next random round and accumulates XP',
      build: build,
      act: (bloc) async {
        bloc.add(
          const GamesStarted(
            rounds: firstRound,
            mode: GamesPlayMode.arcade,
            arcadeRecord: 5,
          ),
        );
        bloc.add(const GamesChoiceSelected('0'));
        bloc.add(const GamesNextPressed());
      },
      wait: const Duration(milliseconds: 10),
      verify: (bloc) {
        expect(saveRound.calls, [(pairId: 10, scorePct: 100, roundNumber: 1)]);
        expect(bloc.state.rounds, hasLength(2));
        expect(bloc.state.currentIndex, 1);
        expect(bloc.state.arcade.scoredCount, 1);
        expect(bloc.state.arcade.record, 5);
        expect(bloc.state.arcade.xpEarned, 3);
        expect(bloc.state.sequenceCompleted, isFalse);
        expect(bloc.state.answered, isFalse);
        expect(saveRecord.calls, isEmpty);
      },
    );

    blocTest<GamesBloc, GamesState>(
      'a miss costs one life and keeps the run going',
      build: build,
      act: (bloc) async {
        bloc.add(
          const GamesStarted(
            rounds: firstRound,
            mode: GamesPlayMode.arcade,
            arcadeRecord: 5,
          ),
        );
        bloc.add(const GamesChoiceSelected('1'));
        bloc.add(const GamesNextPressed());
      },
      wait: const Duration(milliseconds: 10),
      verify: (bloc) {
        expect(saveRound.calls, [(pairId: 10, scorePct: 0, roundNumber: 1)]);
        expect(bloc.state.sequenceCompleted, isFalse);
        expect(bloc.state.arcade.misses, 1);
        expect(bloc.state.arcade.livesLeft, ArcadeInfo.maxLives - 1);
        expect(bloc.state.arcade.scoredCount, 0);
        expect(bloc.state.rounds, hasLength(2));
        expect(saveRecord.calls, isEmpty);
      },
    );

    blocTest<GamesBloc, GamesState>(
      'the run ends once all five lives are gone',
      build: build,
      act: (bloc) async {
        bloc.add(
          const GamesStarted(
            rounds: firstRound,
            mode: GamesPlayMode.arcade,
            arcadeRecord: 5,
          ),
        );
        // _quiz1 is answered by '0', every appended _quiz2 by '1'.
        for (var i = 0; i < ArcadeInfo.maxLives; i++) {
          bloc.add(GamesChoiceSelected(i == 0 ? '1' : '0'));
          bloc.add(const GamesNextPressed());
          await Future<void>.delayed(const Duration(milliseconds: 5));
        }
      },
      wait: const Duration(milliseconds: 20),
      verify: (bloc) {
        expect(saveRound.calls, hasLength(ArcadeInfo.maxLives));
        expect(bloc.state.arcade.misses, ArcadeInfo.maxLives);
        expect(bloc.state.arcade.livesLeft, 0);
        expect(bloc.state.arcade.isOutOfLives, isTrue);
        expect(bloc.state.sequenceCompleted, isTrue);
        expect(bloc.state.arcade.scoredCount, 0);
        expect(saveRecord.calls, isEmpty);
      },
    );

    blocTest<GamesBloc, GamesState>(
      'the score totals every hit in the run, not the longest streak',
      build: build,
      act: (bloc) async {
        bloc.add(
          const GamesStarted(
            rounds: firstRound,
            mode: GamesPlayMode.arcade,
            arcadeRecord: 5,
          ),
        );
        // hit, miss, hit, hit: broken up so no streak is longer than two.
        // _quiz1 is answered by '0', every appended _quiz2 by '1'.
        const picks = ['0', '0', '1', '1'];
        for (final pick in picks) {
          bloc.add(GamesChoiceSelected(pick));
          bloc.add(const GamesNextPressed());
          await Future<void>.delayed(const Duration(milliseconds: 5));
        }
      },
      wait: const Duration(milliseconds: 20),
      verify: (bloc) {
        expect(bloc.state.arcade.misses, 1);
        expect(bloc.state.arcade.scoredCount, 3);
        expect(bloc.state.correctCount, 3);
        expect(bloc.state.sequenceCompleted, isFalse);
      },
    );

    blocTest<GamesBloc, GamesState>(
      'beating the record saves it and flags the new record',
      build: () {
        getRandomRound.queue = const [_quiz2, null];
        return build();
      },
      act: (bloc) async {
        bloc.add(
          const GamesStarted(
            rounds: firstRound,
            mode: GamesPlayMode.arcade,
            arcadeRecord: 1,
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
        expect(bloc.state.arcade.scoredCount, 2);
        expect(saveRecord.calls, [2]);
        expect(bloc.state.arcade.isNewRecord, isTrue);
        expect(bloc.state.arcade.record, 1);
        expect(bloc.state.sequenceCompleted, isTrue);
      },
    );

    blocTest<GamesBloc, GamesState>(
      'abandoning ends the run instead of popping the screen',
      build: build,
      act: (bloc) async {
        bloc.add(
          const GamesStarted(
            rounds: firstRound,
            mode: GamesPlayMode.arcade,
            arcadeRecord: 5,
          ),
        );
        bloc.add(const GamesAbandoned());
      },
      wait: const Duration(milliseconds: 10),
      verify: (bloc) {
        expect(bloc.state.sequenceCompleted, isTrue);
        expect(bloc.state.goBack, isFalse);
      },
    );
  });
}
