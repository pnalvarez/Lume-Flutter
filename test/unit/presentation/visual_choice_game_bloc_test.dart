import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/core/analytics/analytics.dart';
import 'package:lume/layers/domain/models/game/finished_game_match_domain.dart';
import 'package:lume/layers/domain/models/game/visual_choice_game_config.dart';
import 'package:lume/layers/domain/models/game/visual_choice_game_round.dart';
import 'package:lume/layers/domain/usecases/visual_choice_game_match.dart';
import 'package:lume/layers/domain/usecases/submit_visual_choice_game_answer.dart';
import 'package:lume/layers/presentation/screens/games/visual_choice_game/visual_choice_game_bloc.dart';
import 'package:lume/layers/presentation/screens/games/visual_choice_game/visual_choice_game_event.dart';
import 'package:lume/layers/presentation/screens/games/visual_choice_game/visual_choice_game_play_state.dart';

import '../../helpers/fake_analytics.dart';

const _first = VisualChoiceGameRound(
  questionId: 1,
  prompt: 'Primeira?',
  imageUrl: 'https://cdn.example/1.jpg',
  questionType: 'movement',
  options: ['Impressionismo', 'Cubismo'],
  correctAnswer: 'Impressionismo',
);

const _second = VisualChoiceGameRound(
  questionId: 2,
  prompt: 'Segunda?',
  imageUrl: 'https://cdn.example/2.jpg',
  questionType: 'movement',
  options: ['Barroco', 'Romantismo'],
  correctAnswer: 'Romantismo',
);

class _Submit implements ISubmitVisualChoiceGameAnswer {
  final answers = <({int questionId, String answer})>[];
  var correct = true;
  String correctAnswer = 'Impressionismo';
  Object? error;
  Completer<void>? gate;

  @override
  Future<VisualChoiceGameAnswerResult> call({
    required int questionId,
    required String answer,
  }) async {
    answers.add((questionId: questionId, answer: answer));
    final pending = gate;
    if (pending != null) await pending.future;
    final failure = error;
    if (failure != null) throw failure;
    return VisualChoiceGameAnswerResult(
      correct: correct,
      correctAnswer: correctAnswer,
    );
  }
}

class _Match implements IVisualChoiceGameMatch {
  final finishes =
      <({String matchId, int score, int correctCount, int total})>[];

  final startedSlugs = <String>[];

  @override
  Future<String> start({required String gameSlug}) async {
    startedSlugs.add(gameSlug);
    return 'match';
  }

  @override
  Future<FinishedGameMatchDomain> finish({
    required String matchId,
    required int score,
    required int correctCount,
    int totalQuestions = visualChoiceGameRoundsPerMatch,
    int? durationSeconds,
  }) async {
    finishes.add((
      matchId: matchId,
      score: score,
      correctCount: correctCount,
      total: totalQuestions,
    ));
    return const FinishedGameMatchDomain();
  }
}

void main() {
  late _Submit submit;
  late _Match match;
  late FakeAnalytics analytics;

  setUp(() {
    submit = _Submit();
    match = _Match();
    analytics = FakeAnalytics();
  });

  VisualChoiceGameBloc build() =>
      VisualChoiceGameBloc(submit, match, analytics);

  blocTest<VisualChoiceGameBloc, VisualChoiceGamePlayState>(
    'plays each question, then closes the match on the last next',
    build: build,
    act: (bloc) async {
      bloc.add(
        const VisualChoiceGameStarted(
          rounds: [_first, _second],
          matchId: 'match-9',
          config: VisualChoiceGameConfig.knowledgeGallery,
        ),
      );
      await bloc.stream.firstWhere((state) => state.rounds.isNotEmpty);
      bloc.add(const VisualChoiceGameOptionSelected('0'));
      await bloc.stream.firstWhere((state) => state.answered);
      bloc.add(const VisualChoiceGameNextPressed());
      await bloc.stream.firstWhere((state) => state.index == 1);
      submit
        ..correct = false
        ..correctAnswer = 'Romantismo';
      bloc.add(const VisualChoiceGameOptionSelected('0'));
      await bloc.stream.firstWhere(
        (state) => state.index == 1 && state.answered,
      );
      bloc.add(const VisualChoiceGameNextPressed());
      await bloc.stream.firstWhere((state) => state.sequenceCompleted);
    },
    verify: (bloc) {
      expect(submit.answers, [
        (questionId: 1, answer: 'Impressionismo'),
        (questionId: 2, answer: 'Barroco'),
      ]);
      expect(match.finishes, [
        (matchId: 'match-9', score: 50, correctCount: 1, total: 2),
      ]);
      expect(bloc.state.sequenceCompleted, isTrue);
      expect(bloc.state.goBack, isFalse);
      expect(bloc.state.correctCount, 1);
      expect(
        analytics.hasEvent(AnalyticsEvents.knowledgeGalleryRoundStarted),
        isTrue,
      );
      expect(
        analytics.parametersFor(AnalyticsEvents.knowledgeGalleryRoundStarted),
        {AnalyticsParams.roundsTotal: 2, AnalyticsParams.isArcade: false},
      );
      expect(
        analytics.events
            .where(
              (e) => e.name == AnalyticsEvents.knowledgeGalleryQuestionAnswered,
            )
            .length,
        2,
      );
      expect(
        analytics.parametersFor(
          AnalyticsEvents.knowledgeGalleryQuestionAnswered,
        ),
        {
          AnalyticsParams.questionType: 'movement',
          AnalyticsParams.isCorrect: 0,
          AnalyticsParams.roundIndex: 1,
          AnalyticsParams.isArcade: false,
        },
      );
      expect(
        analytics.hasEvent(AnalyticsEvents.knowledgeGallerySessionCompleted),
        isTrue,
      );
      expect(
        analytics.parametersFor(
          AnalyticsEvents.knowledgeGallerySessionCompleted,
        ),
        {
          AnalyticsParams.correctCount: 1,
          AnalyticsParams.roundsTotal: 2,
          AnalyticsParams.isArcade: false,
        },
      );
      expect(
        analytics.hasEvent(AnalyticsEvents.knowledgeGallerySessionAbandoned),
        isFalse,
      );
    },
  );

  blocTest<VisualChoiceGameBloc, VisualChoiceGamePlayState>(
    'stays unanswered until submit_visual_answer returns',
    build: build,
    act: (bloc) async {
      final gate = Completer<void>();
      submit.gate = gate;
      bloc.add(
        const VisualChoiceGameStarted(
          rounds: [_first],
          matchId: 'match-9',
          config: VisualChoiceGameConfig.knowledgeGallery,
        ),
      );
      await bloc.stream.firstWhere((state) => state.rounds.isNotEmpty);
      bloc.add(const VisualChoiceGameOptionSelected('0'));
      await bloc.stream.firstWhere((state) => state.submitting);
      expect(bloc.state.answered, isFalse);
      expect(bloc.state.view?.canSelect, isFalse);
      expect(bloc.state.correctCount, 0);
      gate.complete();
      await bloc.stream.firstWhere((state) => state.answered);
    },
    verify: (bloc) {
      expect(bloc.state.submitting, isFalse);
      expect(bloc.state.isCorrect, isTrue);
      expect(bloc.state.correctCount, 1);
    },
  );

  blocTest<VisualChoiceGameBloc, VisualChoiceGamePlayState>(
    'a failed submit clears the selection and does not answer the round',
    build: build,
    act: (bloc) async {
      submit.error = StateError('submit failed');
      bloc.add(
        const VisualChoiceGameStarted(
          rounds: [_first],
          matchId: 'match-9',
          config: VisualChoiceGameConfig.knowledgeGallery,
        ),
      );
      await bloc.stream.firstWhere((state) => state.rounds.isNotEmpty);
      bloc.add(const VisualChoiceGameOptionSelected('0'));
      await bloc.stream.firstWhere((state) => state.snackMessage != null);
    },
    verify: (bloc) {
      expect(bloc.state.answered, isFalse);
      expect(bloc.state.submitting, isFalse);
      expect(bloc.state.selectedOptionId, isNull);
      expect(bloc.state.correctCount, 0);
      expect(bloc.state.isCorrect, isFalse);
      expect(
        analytics.hasEvent(AnalyticsEvents.knowledgeGalleryQuestionAnswered),
        isFalse,
      );
    },
  );

  test(
    'a choice queued during a failed submit does not clear the error',
    () async {
      final gate = Completer<void>();
      submit
        ..gate = gate
        ..error = StateError('submit failed');
      final bloc = build();
      bloc.add(
        const VisualChoiceGameStarted(
          rounds: [_first],
          matchId: 'match-9',
          config: VisualChoiceGameConfig.knowledgeGallery,
        ),
      );
      await bloc.stream.firstWhere((state) => state.rounds.isNotEmpty);
      bloc.add(const VisualChoiceGameOptionSelected('0'));
      await bloc.stream.firstWhere((state) => state.submitting);
      expect(bloc.state.view?.canSelect, isFalse);
      expect(bloc.state.answered, isFalse);
      bloc.add(const VisualChoiceGameOptionSelected('1'));
      await pumpEventQueue();
      gate.complete();
      await pumpEventQueue();
      expect(submit.answers, [(questionId: 1, answer: 'Impressionismo')]);
      expect(bloc.state.snackMessage, isNotNull);
      expect(bloc.state.selectedOptionId, isNull);
      expect(bloc.state.answered, isFalse);
      expect(bloc.state.submitting, isFalse);
      await bloc.close();
    },
  );

  blocTest<VisualChoiceGameBloc, VisualChoiceGamePlayState>(
    'leaving before any answer does not close the match',
    build: build,
    act: (bloc) {
      bloc.add(
        const VisualChoiceGameStarted(
          rounds: [_first],
          matchId: 'match-9',
          config: VisualChoiceGameConfig.knowledgeGallery,
        ),
      );
      bloc.add(const VisualChoiceGameAbandoned());
    },
    verify: (bloc) {
      expect(match.finishes, isEmpty);
      expect(bloc.state.goBack, isTrue);
      expect(
        analytics.hasEvent(AnalyticsEvents.knowledgeGallerySessionAbandoned),
        isTrue,
      );
      expect(
        analytics.parametersFor(
          AnalyticsEvents.knowledgeGallerySessionAbandoned,
        ),
        {
          AnalyticsParams.roundIndex: 0,
          AnalyticsParams.roundsTotal: 1,
          AnalyticsParams.isArcade: false,
        },
      );
      expect(
        analytics.hasEvent(AnalyticsEvents.knowledgeGallerySessionCompleted),
        isFalse,
      );
    },
  );

  blocTest<VisualChoiceGameBloc, VisualChoiceGamePlayState>(
    'leaving after an answer closes the match',
    build: build,
    act: (bloc) async {
      bloc.add(
        const VisualChoiceGameStarted(
          rounds: [_first, _second],
          matchId: 'm',
          config: VisualChoiceGameConfig.knowledgeGallery,
        ),
      );
      await bloc.stream.firstWhere((state) => state.rounds.isNotEmpty);
      bloc.add(const VisualChoiceGameOptionSelected('0'));
      await bloc.stream.firstWhere((state) => state.answered);
      bloc.add(const VisualChoiceGameAbandoned());
      await bloc.stream.firstWhere((state) => state.goBack);
    },
    verify: (_) {
      expect(match.finishes.single.correctCount, 1);
      expect(match.finishes.single.total, 2);
      expect(match.finishes.single.score, 50);
      expect(
        analytics.hasEvent(AnalyticsEvents.knowledgeGallerySessionAbandoned),
        isTrue,
      );
      expect(
        analytics.hasEvent(AnalyticsEvents.knowledgeGallerySessionCompleted),
        isFalse,
      );
    },
  );

  test('config lookup resolves known slugs to their static configs', () {
    expect(
      VisualChoiceGameConfig.forSlug(VisualChoiceGameSlugs.knowledgeGallery),
      VisualChoiceGameConfig.knowledgeGallery,
    );
    expect(
      VisualChoiceGameConfig.forSlug(VisualChoiceGameSlugs.facesOfHistory),
      VisualChoiceGameConfig.facesOfHistory,
    );
  });

  test(
    'Faces of History session logs only faces_of_history_* events',
    () async {
      final bloc = build();
      bloc.add(
        const VisualChoiceGameStarted(
          rounds: [_first, _second],
          matchId: 'm',
          config: VisualChoiceGameConfig.facesOfHistory,
        ),
      );
      await bloc.stream.firstWhere((state) => state.rounds.isNotEmpty);
      bloc.add(const VisualChoiceGameImageFailed());
      bloc.add(const VisualChoiceGameImageFailed());
      await pumpEventQueue();
      bloc.add(const VisualChoiceGameOptionSelected('0'));
      await bloc.stream.firstWhere((state) => state.answered);
      bloc.add(const VisualChoiceGameAbandoned());
      await bloc.stream.firstWhere((state) => state.goBack);

      expect(analytics.events.map((e) => e.name).toList(), [
        AnalyticsEvents.facesOfHistoryRoundStarted,
        AnalyticsEvents.facesOfHistoryImageFailed,
        AnalyticsEvents.facesOfHistoryQuestionAnswered,
        AnalyticsEvents.facesOfHistorySessionAbandoned,
      ]);
      expect(
        analytics.parametersFor(AnalyticsEvents.facesOfHistoryRoundStarted),
        {AnalyticsParams.roundsTotal: 2, AnalyticsParams.isArcade: false},
      );
      // Once per question index, flag only: never an image URL.
      expect(
        analytics.parametersFor(AnalyticsEvents.facesOfHistoryImageFailed),
        {AnalyticsParams.isArcade: false},
      );
      expect(
        analytics.parametersFor(AnalyticsEvents.facesOfHistorySessionAbandoned),
        {
          AnalyticsParams.roundIndex: 0,
          AnalyticsParams.roundsTotal: 2,
          AnalyticsParams.isArcade: false,
        },
      );
      expect(
        analytics.events.any((e) => e.name.startsWith('knowledge_gallery_')),
        isFalse,
      );
      expect(
        analytics.events.any((e) => e.name.startsWith('game_round_')),
        isFalse,
      );
      await bloc.close();
    },
  );

  test('Galeria session logs only knowledge_gallery_* events', () async {
    final bloc = build();
    bloc.add(
      const VisualChoiceGameStarted(
        rounds: [_first, _second],
        matchId: 'm',
        config: VisualChoiceGameConfig.knowledgeGallery,
      ),
    );
    await bloc.stream.firstWhere((state) => state.rounds.isNotEmpty);
    bloc.add(const VisualChoiceGameImageFailed());
    await pumpEventQueue();
    bloc.add(const VisualChoiceGameOptionSelected('0'));
    await bloc.stream.firstWhere((state) => state.answered);
    bloc.add(const VisualChoiceGameAbandoned());
    await bloc.stream.firstWhere((state) => state.goBack);

    expect(analytics.events.map((e) => e.name).toList(), [
      AnalyticsEvents.knowledgeGalleryRoundStarted,
      AnalyticsEvents.knowledgeGalleryImageFailed,
      AnalyticsEvents.knowledgeGalleryQuestionAnswered,
      AnalyticsEvents.knowledgeGallerySessionAbandoned,
    ]);
    expect(
      analytics.events.any((e) => e.name.startsWith('faces_of_history_')),
      isFalse,
    );
    await bloc.close();
  });

  blocTest<VisualChoiceGameBloc, VisualChoiceGamePlayState>(
    'image failed logs once per question index',
    build: build,
    act: (bloc) async {
      bloc.add(
        const VisualChoiceGameStarted(
          rounds: [_first, _second],
          matchId: 'm',
          config: VisualChoiceGameConfig.knowledgeGallery,
        ),
      );
      await bloc.stream.firstWhere((state) => state.rounds.isNotEmpty);
      bloc.add(const VisualChoiceGameImageFailed());
      bloc.add(const VisualChoiceGameImageFailed());
      await pumpEventQueue();
    },
    verify: (_) {
      expect(
        analytics.events
            .where((e) => e.name == AnalyticsEvents.knowledgeGalleryImageFailed)
            .length,
        1,
      );
    },
  );
}
