import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/core/analytics/analytics.dart';
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
import 'package:lume/layers/domain/models/game/finished_game_match_domain.dart';
import 'package:lume/layers/domain/usecases/get_random_game_round.dart';
import 'package:lume/layers/domain/usecases/save_arcade_record.dart';
import 'package:lume/layers/domain/usecases/save_arcade_round.dart';
import 'package:lume/layers/domain/usecases/save_pair_progress.dart';
import 'package:lume/layers/domain/usecases/finish_game_match.dart';
import 'package:lume/layers/presentation/screens/games/game_round.dart';
import 'package:lume/layers/presentation/screens/games/games_bloc.dart';
import 'package:lume/layers/presentation/screens/games/games_event.dart';
import 'package:lume/layers/presentation/screens/games/games_state.dart';
import '../../helpers/fake_analytics.dart';

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

class _FinishGameMatch implements IFinishGameMatch {
  final calls =
      <
        ({
          String matchId,
          int score,
          int correctCount,
          int totalQuestions,
          Map<String, Object?>? metadata,
        })
      >[];
  Object? error;

  /// Throws this many times, then succeeds. [error] throws on every call.
  var failuresLeft = 0;
  var attempts = 0;

  @override
  Future<FinishedGameMatchDomain> call({
    required String matchId,
    required int score,
    required int correctCount,
    required int totalQuestions,
    int? durationSeconds,
    Map<String, Object?>? metadata,
  }) async {
    attempts++;
    if (failuresLeft > 0) {
      failuresLeft--;
      throw StateError('finish failed');
    }
    if (error != null) throw error!;
    calls.add((
      matchId: matchId,
      score: score,
      correctCount: correctCount,
      totalQuestions: totalQuestions,
      metadata: metadata,
    ));
    return const FinishedGameMatchDomain(xpEarned: 12);
  }
}

GamesBloc _createGamesBloc(
  _SavePairProgress save, {
  _GetRandomGameRound? getRandomRound,
  _SaveArcadeRound? saveArcadeRound,
  _SaveArcadeRecord? saveArcadeRecord,
  _FinishGameMatch? finishGameMatch,
  FakeAnalytics? analytics,
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
  finishGameMatch ?? _FinishGameMatch(),
  analytics ?? FakeAnalytics(),
);

void main() {
  group('GamesBloc', () {
    late List<({String roundId, int scorePct})> saves;
    late _SavePairProgress savePair;
    late _FinishGameMatch finish;

    setUp(() {
      saves = [];
      savePair = _SavePairProgress();
      finish = _FinishGameMatch();
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

    blocTest<GamesBloc, GamesState>(
      'hub mode finishes the match when the session completes',
      build: () => _createGamesBloc(savePair, finishGameMatch: finish),
      act: (bloc) async {
        bloc.add(
          const GamesStarted(
            rounds: rounds,
            mode: GamesPlayMode.hub,
            matchId: 'match-1',
          ),
        );
        bloc.add(const GamesChoiceSelected('0'));
        bloc.add(const GamesNextPressed());
        await Future<void>.delayed(const Duration(milliseconds: 5));
        bloc.add(const GamesChoiceSelected('1'));
        bloc.add(const GamesNextPressed());
      },
      wait: const Duration(milliseconds: 20),
      verify: (bloc) {
        expect(bloc.state.sequenceCompleted, isTrue);
        expect(finish.calls, [
          (
            matchId: 'match-1',
            score: 100,
            correctCount: 2,
            totalQuestions: 2,
            metadata: null,
          ),
        ]);
      },
    );

    blocTest<GamesBloc, GamesState>(
      'hub abandon finishes a partial match against the full session length',
      build: () => _createGamesBloc(savePair, finishGameMatch: finish),
      act: (bloc) async {
        bloc.add(
          const GamesStarted(
            rounds: rounds,
            mode: GamesPlayMode.hub,
            matchId: 'match-1',
          ),
        );
        bloc.add(const GamesChoiceSelected('0'));
        bloc.add(const GamesNextPressed());
        await Future<void>.delayed(const Duration(milliseconds: 5));
        bloc.add(const GamesAbandoned());
      },
      wait: const Duration(milliseconds: 20),
      verify: (bloc) {
        expect(bloc.state.goBack, isTrue);
        expect(finish.calls, [
          (
            matchId: 'match-1',
            score: 50,
            correctCount: 1,
            totalQuestions: 2,
            metadata: null,
          ),
        ]);
      },
    );

    blocTest<GamesBloc, GamesState>(
      'hub abandon before any answer does not finish the match',
      build: () => _createGamesBloc(savePair, finishGameMatch: finish),
      act: (bloc) async {
        bloc.add(
          const GamesStarted(
            rounds: rounds,
            mode: GamesPlayMode.hub,
            matchId: 'match-1',
          ),
        );
        bloc.add(const GamesAbandoned());
      },
      wait: const Duration(milliseconds: 10),
      verify: (_) {
        expect(finish.calls, isEmpty);
      },
    );

    blocTest<GamesBloc, GamesState>(
      'hub abandon after an answer but before next finishes that answer',
      build: () => _createGamesBloc(savePair, finishGameMatch: finish),
      act: (bloc) async {
        bloc.add(
          const GamesStarted(
            rounds: rounds,
            mode: GamesPlayMode.hub,
            matchId: 'match-1',
          ),
        );
        bloc.add(const GamesChoiceSelected('0'));
        bloc.add(const GamesAbandoned());
      },
      wait: const Duration(milliseconds: 20),
      verify: (bloc) {
        expect(bloc.state.goBack, isTrue);
        expect(savePair.calls, [(pairId: 10, scorePct: 100)]);
        expect(finish.calls, [
          (
            matchId: 'match-1',
            score: 50,
            correctCount: 1,
            totalQuestions: 2,
            metadata: null,
          ),
        ]);
      },
    );

    blocTest<GamesBloc, GamesState>(
      'hub finish failure then retry saves the pair once and finishes once',
      build: () {
        finish.failuresLeft = 1;
        return _createGamesBloc(savePair, finishGameMatch: finish);
      },
      act: (bloc) async {
        bloc.add(
          const GamesStarted(
            rounds: [GameRound(id: '10', game: _quiz1)],
            mode: GamesPlayMode.hub,
            matchId: 'match-1',
          ),
        );
        bloc.add(const GamesChoiceSelected('0'));
        bloc.add(const GamesNextPressed());
        await Future<void>.delayed(const Duration(milliseconds: 5));
        bloc.add(const GamesRetrySave());
      },
      wait: const Duration(milliseconds: 20),
      verify: (bloc) {
        expect(bloc.state.sequenceCompleted, isTrue);
        expect(savePair.calls, [(pairId: 10, scorePct: 100)]);
        expect(finish.calls, [
          (
            matchId: 'match-1',
            score: 100,
            correctCount: 1,
            totalQuestions: 1,
            metadata: null,
          ),
        ]);
      },
    );

    blocTest<GamesBloc, GamesState>(
      'hub finish failure then leave closes with the saved round included',
      build: () {
        finish.failuresLeft = 1;
        return _createGamesBloc(savePair, finishGameMatch: finish);
      },
      act: (bloc) async {
        bloc.add(
          const GamesStarted(
            rounds: [GameRound(id: '10', game: _quiz1)],
            mode: GamesPlayMode.hub,
            matchId: 'match-1',
          ),
        );
        bloc.add(const GamesChoiceSelected('0'));
        bloc.add(const GamesNextPressed());
        await Future<void>.delayed(const Duration(milliseconds: 5));
        bloc.add(const GamesAbandoned());
      },
      wait: const Duration(milliseconds: 20),
      verify: (bloc) {
        expect(bloc.state.goBack, isTrue);
        expect(savePair.calls, [(pairId: 10, scorePct: 100)]);
        expect(finish.calls, [
          (
            matchId: 'match-1',
            score: 100,
            correctCount: 1,
            totalQuestions: 1,
            metadata: null,
          ),
        ]);
      },
    );

    blocTest<GamesBloc, GamesState>(
      'hub finish failure then leave stays on the session when finish fails again',
      build: () {
        finish.error = StateError('finish failed');
        return _createGamesBloc(savePair, finishGameMatch: finish);
      },
      act: (bloc) async {
        bloc.add(
          const GamesStarted(
            rounds: [GameRound(id: '10', game: _quiz1)],
            mode: GamesPlayMode.hub,
            matchId: 'match-1',
          ),
        );
        bloc.add(const GamesChoiceSelected('0'));
        bloc.add(const GamesNextPressed());
        await Future<void>.delayed(const Duration(milliseconds: 5));
        bloc.add(const GamesAbandoned());
      },
      wait: const Duration(milliseconds: 20),
      verify: (bloc) {
        expect(bloc.state.goBack, isFalse);
        expect(bloc.state.status, GamesStatus.error);
        expect(finish.attempts, 2);
        expect(finish.calls, isEmpty);
      },
    );

    const leilaoRounds = [
      GameRound(
        id: '20',
        game: WhoAmIGameDomain(
          pairId: 20,
          sortOrder: 1,
          header: 'Who?',
          hints: ['one', 'two'],
          correctAnswer: 'Ada',
          acceptedSynonyms: [],
          explanation: 'e',
        ),
      ),
      GameRound(
        id: '21',
        game: WhoAmIGameDomain(
          pairId: 21,
          sortOrder: 2,
          header: 'Who?',
          hints: ['one', 'two'],
          correctAnswer: 'Ada',
          acceptedSynonyms: [],
          explanation: 'e',
        ),
      ),
    ];

    blocTest<GamesBloc, GamesState>(
      'leilao counts correct answers that did not reveal a hint',
      build: () => _createGamesBloc(savePair, finishGameMatch: finish),
      act: (bloc) async {
        bloc.add(
          const GamesStarted(
            rounds: leilaoRounds,
            mode: GamesPlayMode.hub,
            matchId: 'match-1',
            gameSlug: 'leilao_dicas',
          ),
        );
        bloc.add(const GamesWhoAmIAnswerChanged('Ada'));
        bloc.add(const GamesWhoAmISubmit());
        bloc.add(const GamesNextPressed());
        await Future<void>.delayed(const Duration(milliseconds: 5));
        bloc.add(const GamesWhoAmIAnswerChanged('Ada'));
        bloc.add(const GamesWhoAmISubmit());
        bloc.add(const GamesNextPressed());
      },
      wait: const Duration(milliseconds: 20),
      verify: (_) {
        expect(finish.calls.single.metadata, {'zero_hint_streak': 2});
      },
    );

    blocTest<GamesBloc, GamesState>(
      'leilao ignores a correct answer after a hint is revealed',
      build: () => _createGamesBloc(savePair, finishGameMatch: finish),
      act: (bloc) async {
        bloc.add(
          const GamesStarted(
            rounds: leilaoRounds,
            mode: GamesPlayMode.hub,
            matchId: 'match-1',
            gameSlug: 'leilao_dicas',
          ),
        );
        bloc.add(const GamesWhoAmIRevealHint());
        bloc.add(const GamesWhoAmIAnswerChanged('Ada'));
        bloc.add(const GamesWhoAmISubmit());
        bloc.add(const GamesNextPressed());
        await Future<void>.delayed(const Duration(milliseconds: 5));
        bloc.add(const GamesWhoAmIAnswerChanged('Ada'));
        bloc.add(const GamesWhoAmISubmit());
        bloc.add(const GamesNextPressed());
      },
      wait: const Duration(milliseconds: 20),
      verify: (_) {
        expect(finish.calls.single.metadata, {'zero_hint_streak': 1});
      },
    );

    const streakRounds = [
      GameRound(
        id: '20',
        game: WhoAmIGameDomain(
          pairId: 20,
          sortOrder: 1,
          header: 'Who?',
          hints: ['one', 'two'],
          correctAnswer: 'Ada',
          acceptedSynonyms: [],
          explanation: 'e',
        ),
      ),
      GameRound(
        id: '21',
        game: WhoAmIGameDomain(
          pairId: 21,
          sortOrder: 2,
          header: 'Who?',
          hints: ['one', 'two'],
          correctAnswer: 'Ada',
          acceptedSynonyms: [],
          explanation: 'e',
        ),
      ),
      GameRound(
        id: '22',
        game: WhoAmIGameDomain(
          pairId: 22,
          sortOrder: 3,
          header: 'Who?',
          hints: ['one', 'two'],
          correctAnswer: 'Ada',
          acceptedSynonyms: [],
          explanation: 'e',
        ),
      ),
    ];

    blocTest<GamesBloc, GamesState>(
      'leilao zero-hint streak resets after a miss',
      build: () => _createGamesBloc(savePair, finishGameMatch: finish),
      act: (bloc) async {
        bloc.add(
          const GamesStarted(
            rounds: streakRounds,
            mode: GamesPlayMode.hub,
            matchId: 'match-1',
            gameSlug: 'leilao_dicas',
          ),
        );
        bloc.add(const GamesWhoAmIAnswerChanged('Ada'));
        bloc.add(const GamesWhoAmISubmit());
        bloc.add(const GamesNextPressed());
        await Future<void>.delayed(const Duration(milliseconds: 5));
        bloc.add(const GamesWhoAmIAnswerChanged('Nope'));
        bloc.add(const GamesWhoAmISubmit());
        bloc.add(const GamesNextPressed());
        await Future<void>.delayed(const Duration(milliseconds: 5));
        bloc.add(const GamesWhoAmIAnswerChanged('Ada'));
        bloc.add(const GamesWhoAmISubmit());
        bloc.add(const GamesNextPressed());
      },
      wait: const Duration(milliseconds: 30),
      verify: (_) {
        expect(finish.calls.single.metadata, {'zero_hint_streak': 1});
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

  group('GamesBloc analytics', () {
    test('start logs game_round_started', () async {
      final analytics = FakeAnalytics();
      final bloc = _createGamesBloc(_SavePairProgress(), analytics: analytics);
      bloc.add(
        GamesStarted(
          rounds: [
            GameRound(id: '10', game: _quiz1),
            GameRound(id: '11', game: _quiz2),
          ],
          mode: GamesPlayMode.hub,
        ),
      );
      await pumpEventQueue();
      expect(analytics.hasEvent(AnalyticsEvents.gameRoundStarted), isTrue);
      expect(analytics.parametersFor(AnalyticsEvents.gameRoundStarted), {
        AnalyticsParams.playMode: 'hub',
        AnalyticsParams.roundsTotal: 2,
        AnalyticsParams.gameType: 'lightning_quiz',
      });
      await bloc.close();
    });

    test('abandon logs game_session_abandoned', () async {
      final analytics = FakeAnalytics();
      final bloc = _createGamesBloc(_SavePairProgress(), analytics: analytics);
      bloc.add(
        GamesStarted(
          rounds: [GameRound(id: '10', game: _quiz1)],
          mode: GamesPlayMode.hub,
        ),
      );
      await pumpEventQueue();
      bloc.add(const GamesAbandoned());
      await pumpEventQueue();
      expect(analytics.hasEvent(AnalyticsEvents.gameSessionAbandoned), isTrue);
      expect(analytics.hasEvent(AnalyticsEvents.gameSessionCompleted), isFalse);
      expect(analytics.hasEvent(AnalyticsEvents.arcadeAbandoned), isFalse);
      await bloc.close();
    });

    test('arcade abandon logs arcade_abandoned with score', () async {
      final analytics = FakeAnalytics();
      final bloc = _createGamesBloc(
        _SavePairProgress(),
        getRandomRound: _GetRandomGameRound(),
        saveArcadeRound: _SaveArcadeRound(),
        analytics: analytics,
      );
      bloc.add(
        GamesStarted(
          rounds: [GameRound(id: '10', game: _quiz1)],
          mode: GamesPlayMode.arcade,
          arcadeRecord: 5,
        ),
      );
      await pumpEventQueue();
      // Correct option index 0 → hit → score becomes 1, next round appended.
      bloc.add(const GamesChoiceSelected('0'));
      await pumpEventQueue();
      bloc.add(const GamesNextPressed());
      await pumpEventQueue();
      bloc.add(const GamesAbandoned());
      await pumpEventQueue();
      expect(analytics.hasEvent(AnalyticsEvents.arcadeAbandoned), isTrue);
      expect(analytics.parametersFor(AnalyticsEvents.arcadeAbandoned), {
        AnalyticsParams.score: 1,
        AnalyticsParams.record: 5,
        AnalyticsParams.roundIndex: 1,
        AnalyticsParams.roundsTotal: 2,
      });
      expect(analytics.hasEvent(AnalyticsEvents.gameSessionCompleted), isFalse);
      await bloc.close();
    });
  });
}
