import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/domain/models/game/finished_game_match_domain.dart';
import 'package:lume/layers/domain/models/game/knowledge_gallery_round.dart';
import 'package:lume/layers/domain/usecases/knowledge_gallery_match.dart';
import 'package:lume/layers/domain/usecases/submit_knowledge_gallery_answer.dart';
import 'package:lume/layers/presentation/screens/games/knowledge_gallery/knowledge_gallery_bloc.dart';
import 'package:lume/layers/presentation/screens/games/knowledge_gallery/knowledge_gallery_event.dart';
import 'package:lume/layers/presentation/screens/games/knowledge_gallery/knowledge_gallery_play_state.dart';

const _first = KnowledgeGalleryRound(
  questionId: 1,
  prompt: 'Primeira?',
  imageUrl: 'https://cdn.example/1.jpg',
  questionType: 'movement',
  options: ['Impressionismo', 'Cubismo'],
  correctAnswer: 'Impressionismo',
);

const _second = KnowledgeGalleryRound(
  questionId: 2,
  prompt: 'Segunda?',
  imageUrl: 'https://cdn.example/2.jpg',
  questionType: 'movement',
  options: ['Barroco', 'Romantismo'],
  correctAnswer: 'Romantismo',
);

class _Submit implements ISubmitKnowledgeGalleryAnswer {
  final answers = <({int questionId, String answer})>[];
  var correct = true;
  String correctAnswer = 'Impressionismo';

  @override
  Future<KnowledgeGalleryAnswerResult> call({
    required int questionId,
    required String answer,
  }) async {
    answers.add((questionId: questionId, answer: answer));
    return KnowledgeGalleryAnswerResult(
      correct: correct,
      correctAnswer: correctAnswer,
    );
  }
}

class _Match implements IKnowledgeGalleryMatch {
  final finishes =
      <({String matchId, int score, int correctCount, int total})>[];

  @override
  Future<String> start() async => 'match';

  @override
  Future<FinishedGameMatchDomain> finish({
    required String matchId,
    required int score,
    required int correctCount,
    int totalQuestions = knowledgeGalleryRoundsPerMatch,
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

  setUp(() {
    submit = _Submit();
    match = _Match();
  });

  KnowledgeGalleryBloc build() => KnowledgeGalleryBloc(submit, match);

  blocTest<KnowledgeGalleryBloc, KnowledgeGalleryPlayState>(
    'plays each question, then closes the match on the last next',
    build: build,
    act: (bloc) async {
      bloc.add(
        const KnowledgeGalleryStarted(
          rounds: [_first, _second],
          matchId: 'match-9',
        ),
      );
      await bloc.stream.firstWhere((state) => state.rounds.isNotEmpty);
      bloc.add(const KnowledgeGalleryOptionSelected('0'));
      await bloc.stream.firstWhere((state) => state.answered);
      bloc.add(const KnowledgeGalleryNextPressed());
      await bloc.stream.firstWhere((state) => state.index == 1);
      submit
        ..correct = false
        ..correctAnswer = 'Romantismo';
      bloc.add(const KnowledgeGalleryOptionSelected('0'));
      await bloc.stream.firstWhere(
        (state) => state.index == 1 && state.answered,
      );
      bloc.add(const KnowledgeGalleryNextPressed());
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
    },
  );

  blocTest<KnowledgeGalleryBloc, KnowledgeGalleryPlayState>(
    'leaving before any answer does not close the match',
    build: build,
    act: (bloc) {
      bloc.add(
        const KnowledgeGalleryStarted(rounds: [_first], matchId: 'match-9'),
      );
      bloc.add(const KnowledgeGalleryAbandoned());
    },
    verify: (bloc) {
      expect(match.finishes, isEmpty);
      expect(bloc.state.goBack, isTrue);
    },
  );

  blocTest<KnowledgeGalleryBloc, KnowledgeGalleryPlayState>(
    'leaving after an answer closes the match',
    build: build,
    act: (bloc) async {
      bloc.add(
        const KnowledgeGalleryStarted(rounds: [_first, _second], matchId: 'm'),
      );
      await bloc.stream.firstWhere((state) => state.rounds.isNotEmpty);
      bloc.add(const KnowledgeGalleryOptionSelected('0'));
      await bloc.stream.firstWhere((state) => state.answered);
      bloc.add(const KnowledgeGalleryAbandoned());
      await bloc.stream.firstWhere((state) => state.goBack);
    },
    verify: (_) {
      expect(match.finishes.single.correctCount, 1);
      expect(match.finishes.single.total, 2);
      expect(match.finishes.single.score, 50);
    },
  );
}
