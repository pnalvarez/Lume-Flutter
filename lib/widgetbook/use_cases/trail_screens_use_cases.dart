import 'package:flutter/material.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game_values.dart';
import 'package:lume/layers/presentation/screens/games/battle_of_curiosities/battle_of_curiosities_body.dart';
import 'package:lume/layers/presentation/screens/games/battle_of_curiosities/battle_of_curiosities_state.dart';
import 'package:lume/layers/presentation/screens/games/complete_sentence/complete_sentence_body.dart';
import 'package:lume/layers/presentation/screens/games/complete_sentence/complete_sentence_state.dart';
import 'package:lume/layers/presentation/screens/games/connections/connections_body.dart';
import 'package:lume/layers/presentation/screens/games/connections/connections_state.dart';
import 'package:lume/layers/presentation/screens/games/game_round.dart';
import 'package:lume/layers/presentation/screens/games/games_body.dart';
import 'package:lume/layers/presentation/screens/games/games_state.dart';
import 'package:lume/layers/presentation/screens/games/lightning_quiz/lightning_quiz_body.dart';
import 'package:lume/layers/presentation/screens/games/lightning_quiz/lightning_quiz_state.dart';
import 'package:lume/layers/presentation/screens/games/mysterious_word/mysterious_word_body.dart';
import 'package:lume/layers/presentation/screens/games/mysterious_word/mysterious_word_state.dart';
import 'package:lume/layers/presentation/screens/games/shared/choice_game_body.dart';
import 'package:lume/layers/presentation/screens/games/timeline/timeline_body.dart';
import 'package:lume/layers/presentation/screens/games/timeline/timeline_state.dart';
import 'package:lume/layers/presentation/screens/games/true_or_myth/true_or_myth_body.dart';
import 'package:lume/layers/presentation/screens/games/true_or_myth/true_or_myth_state.dart';
import 'package:lume/layers/presentation/screens/games/who_am_i/who_am_i_body.dart';
import 'package:lume/layers/presentation/screens/games/who_am_i/who_am_i_state.dart';
import 'package:lume/layers/presentation/screens/trail/home/home_body.dart';
import 'package:lume/layers/presentation/screens/trail/home/home_state.dart';
import 'package:lume/layers/presentation/screens/trail/submodule_session/submodule_complete_body.dart';
import 'package:lume/layers/presentation/screens/trail/submodule_session/submodule_preview_body.dart';
import 'package:lume/layers/presentation/screens/trail/trail_detail/trail_detail_body.dart';
import 'package:lume/layers/presentation/screens/trail/trail_detail/trail_detail_state.dart';
import 'package:lume_design_system/organisms/game/choice_group.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

void _noop() {}
void _noopString(String _) {}
void _noopInt(int _) {}
void _noopBlank(int order, String option) {}

const _sampleQuiz = LightningQuizGameDomain(
  pairId: 1,
  sortOrder: 1,
  prompt: 'Qual foi a primeira capital do Brasil?',
  options: ['Salvador', 'Rio de Janeiro', 'Brasília', 'São Paulo'],
  correctIndex: 0,
  explanation: 'Salvador foi a primeira capital colonial.',
);

const _sampleTimeline = TimelineGameDomain(
  pairId: 2,
  sortOrder: 2,
  initialSituation: 'A Independência do Brasil foi proclamada em 1822.',
  options: [
    'Dom Pedro I tornou-se imperador',
    'A República foi proclamada',
    'O Brasil voltou a ser colônia',
  ],
  correctIndex: 0,
  relationType: 'depois',
  explanation: 'Após a independência, Dom Pedro I assumiu o trono.',
);

const _sampleTrueOrMyth = TrueOrMythGameDomain(
  pairId: 3,
  sortOrder: 3,
  text: 'O Café com Leite foi um acordo formal escrito entre SP e MG.',
  verdict: TrueOrMythVerdict.myth,
  explanation: 'Foi um arranjo informal da República Oligárquica.',
);

const _sampleBattle = BattleOfCuriositiesGameDomain(
  pairId: 4,
  sortOrder: 4,
  question: 'Qual país tem mais medalhas olímpicas de ouro?',
  optionA: 'Estados Unidos',
  optionB: 'China',
  correct: BattleCorrectSide.a,
  comparisonCriterion: 'Total histórico',
  explanation: 'Os EUA lideram o quadro histórico.',
);

const _sampleWhoAmI = WhoAmIGameDomain(
  pairId: 5,
  sortOrder: 5,
  header: 'Quem sou eu na história do Brasil?',
  hints: [
    'Lutei pela independência da Bahia.',
    'Sou conhecida como heroína de Itaparica.',
    'Meu nome é Maria Quitéria.',
  ],
  correctAnswer: 'Maria Quitéria',
  acceptedSynonyms: ['Quitéria'],
  explanation: 'Maria Quitéria foi pioneira no Exército brasileiro.',
);

const _sampleSentence = CompleteSentenceGameDomain(
  pairId: 6,
  sortOrder: 6,
  sentence: 'A _______ do Brasil aconteceu em _______.',
  blanks: [
    SentenceBlankDomain(
      order: 0,
      options: ['Independência', 'Abolição', 'República'],
      correct: 'Independência',
    ),
    SentenceBlankDomain(
      order: 1,
      options: ['1822', '1888', '1889'],
      correct: '1822',
    ),
  ],
  explanation: 'A Independência foi proclamada em 1822.',
);

const _sampleWord = MysteriousWordGameDomain(
  pairId: 7,
  sortOrder: 7,
  word: 'IMPÉRIO',
  description: 'Regime político após a Independência.',
  hint: 'Foi liderado por Dom Pedro I e Dom Pedro II.',
  explanation: 'O Império durou de 1822 a 1889.',
);

const _sampleConnections = ConnectionsGameDomain(
  pairId: 8,
  sortOrder: 8,
  title: 'Tarefas da IA',
  subtitle: 'Associe cada termo à função correspondente.',
  leftColumn: [
    ConnectionItemDomain(id: 'l1', text: '1822'),
    ConnectionItemDomain(id: 'l2', text: '1888'),
    ConnectionItemDomain(id: 'l3', text: '1889'),
  ],
  rightColumn: [
    ConnectionItemDomain(id: 'r1', text: 'Independência'),
    ConnectionItemDomain(id: 'r2', text: 'Abolição'),
    ConnectionItemDomain(id: 'r3', text: 'República'),
  ],
  pairs: [
    ConnectionPairDomain(leftId: 'l1', rightId: 'r1'),
    ConnectionPairDomain(leftId: 'l2', rightId: 'r2'),
    ConnectionPairDomain(leftId: 'l3', rightId: 'r3'),
  ],
);

// --- Trail home (extra states) ----------------------------------------------

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Trail Home',
  name: 'Error',
  type: HomeBody,
)
Widget trailHomeError(BuildContext context) {
  return HomeBody(
    state: const HomeState(
      status: HomeStatus.error,
      errorMessage: 'Não foi possível carregar suas trilhas.',
    ),
    onRetry: _noop,
    onTrailPressed: _noopInt,
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Trail Home',
  name: 'Empty',
  type: HomeBody,
)
Widget trailHomeEmpty(BuildContext context) {
  return HomeBody(
    state: const HomeState(
      status: HomeStatus.ready,
      greetingName: 'Pedro',
      trails: [],
    ),
    onRetry: _noop,
    onTrailPressed: _noopInt,
  );
}

// --- Trail detail (module details) ------------------------------------------

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Trail Detail',
  name: 'Ready',
  type: TrailDetailBody,
)
Widget trailDetailReady(BuildContext context) {
  return TrailDetailBody(
    state: const TrailDetailState(
      status: TrailDetailStatus.ready,
      trailId: 1,
      title: 'História do Brasil',
      emoji: '🇧🇷',
      levels: [
        TrailDetailLevelUi(
          title: 'Nível 1 — Colônia',
          submodules: [
            TrailDetailSubmoduleRowUi(
              id: 10,
              title: 'Chegada dos portugueses',
              gamesCount: 4,
              isCompleted: true,
            ),
            TrailDetailSubmoduleRowUi(
              id: 11,
              title: 'Economia açucareira',
              gamesCount: 4,
              isCompleted: false,
            ),
          ],
        ),
        TrailDetailLevelUi(
          title: 'Nível 2 — Império',
          isLocked: true,
          submodules: [
            TrailDetailSubmoduleRowUi(
              id: 12,
              title: 'Independência',
              gamesCount: 4,
              isCompleted: false,
              isLocked: true,
            ),
          ],
        ),
      ],
    ),
    onBack: _noop,
    onRetry: _noop,
    onSubmodulePressed: _noopInt,
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Trail Detail',
  name: 'Loading',
  type: TrailDetailBody,
)
Widget trailDetailLoading(BuildContext context) {
  return TrailDetailBody(
    state: const TrailDetailState(trailId: 1, title: 'História'),
    onBack: _noop,
    onRetry: _noop,
    onSubmodulePressed: _noopInt,
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Trail Detail',
  name: 'Error',
  type: TrailDetailBody,
)
Widget trailDetailError(BuildContext context) {
  return TrailDetailBody(
    state: const TrailDetailState(
      status: TrailDetailStatus.error,
      trailId: 1,
      errorMessage: 'Não foi possível carregar esta trilha.',
    ),
    onBack: _noop,
    onRetry: _noop,
    onSubmodulePressed: _noopInt,
  );
}

// --- Submodule session ------------------------------------------------------

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Submodule Preview',
  name: 'Default',
  type: SubmodulePreviewBody,
)
Widget submodulePreview(BuildContext context) {
  return SubmodulePreviewBody(
    isLoading: false,
    title: 'Economia açucareira',
    preview:
        'Neste submódulo você vai explorar como o açúcar moldou a economia '
        'colonial e a sociedade do Brasil nos primeiros séculos.',
    onAbandoned: _noop,
    onContinue: _noop,
    onRetry: _noop,
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Submodule Preview',
  name: 'Loading',
  type: SubmodulePreviewBody,
)
Widget submodulePreviewLoading(BuildContext context) {
  return SubmodulePreviewBody(
    isLoading: true,
    onAbandoned: _noop,
    onContinue: _noop,
    onRetry: _noop,
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Submodule Preview',
  name: 'Error',
  type: SubmodulePreviewBody,
)
Widget submodulePreviewError(BuildContext context) {
  return SubmodulePreviewBody(
    isLoading: false,
    errorMessage: 'Não foi possível carregar este submódulo.',
    onAbandoned: _noop,
    onContinue: _noop,
    onRetry: _noop,
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Games',
  name: 'Playing quiz',
  type: GamesBody,
)
Widget gamesPlayingQuiz(BuildContext context) {
  return GamesBody(
    state: GamesState.initial(
      rounds: const [
        GameRound(id: '1', game: _sampleQuiz),
        GameRound(id: '2', game: _sampleTimeline),
      ],
    ),
    onAbandoned: _noop,
    onRetry: _noop,
    onChoiceSelected: _noopString,
    onWhoAmIAnswerChanged: _noopString,
    onWhoAmIRevealHint: _noop,
    onWhoAmISubmit: _noop,
    onBlankSelected: _noopBlank,
    onCompleteSentenceSubmit: _noop,
    onConnectionsLeftSelected: _noopString,
    onConnectionsRightSelected: _noopString,
    onConnectionsUndoLast: _noop,
    onConnectionsSubmit: _noop,
    onMysteriousWordLetterPressed: _noopString,
    onNext: _noop,
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Games',
  name: 'Progress mid-sequence',
  type: GamesBody,
)
Widget gamesProgressMid(BuildContext context) {
  return GamesBody(
    state: const GamesState(
      rounds: [
        GameRound(id: '1', game: _sampleQuiz),
        GameRound(id: '2', game: _sampleTimeline),
        GameRound(id: '3', game: _sampleQuiz),
      ],
      currentIndex: 1,
      completedCount: 1,
    ),
    onAbandoned: _noop,
    onRetry: _noop,
    onChoiceSelected: _noopString,
    onWhoAmIAnswerChanged: _noopString,
    onWhoAmIRevealHint: _noop,
    onWhoAmISubmit: _noop,
    onBlankSelected: _noopBlank,
    onCompleteSentenceSubmit: _noop,
    onConnectionsLeftSelected: _noopString,
    onConnectionsRightSelected: _noopString,
    onConnectionsUndoLast: _noop,
    onConnectionsSubmit: _noop,
    onMysteriousWordLetterPressed: _noopString,
    onNext: _noop,
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Submodule Complete',
  name: 'Default',
  type: SubmoduleCompleteBody,
)
Widget submoduleCompleted(BuildContext context) {
  return SubmoduleCompleteBody(correctCount: 2, total: 2, onBackToTrail: _noop);
}

// --- Shared choice chrome ---------------------------------------------------

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Games]/Shared',
  name: 'Choice idle',
  type: ChoiceGameBody,
)
Widget choiceGameIdle(BuildContext context) {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: ChoiceGameBody(
        eyebrow: 'Quiz relâmpago',
        prompt: _sampleQuiz.prompt,
        options: [
          for (var i = 0; i < _sampleQuiz.options.length; i++)
            ChoiceOption(id: '$i', label: _sampleQuiz.options[i]),
        ],
        answered: false,
        isCorrect: false,
        onOptionSelected: _noopString,
        onNext: _noop,
      ),
    ),
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Games]/Shared',
  name: 'Choice answered',
  type: ChoiceGameBody,
)
Widget choiceGameAnswered(BuildContext context) {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: ChoiceGameBody(
        eyebrow: 'Quiz relâmpago',
        prompt: _sampleQuiz.prompt,
        options: [
          ChoiceOption(
            id: '0',
            label: _sampleQuiz.options[0],
            state: ChoiceVisualState.positive,
          ),
          ChoiceOption(
            id: '1',
            label: _sampleQuiz.options[1],
            state: ChoiceVisualState.negative,
          ),
          ChoiceOption(
            id: '2',
            label: _sampleQuiz.options[2],
            state: ChoiceVisualState.disabled,
          ),
          ChoiceOption(
            id: '3',
            label: _sampleQuiz.options[3],
            state: ChoiceVisualState.disabled,
          ),
        ],
        answered: true,
        isCorrect: false,
        explanation: _sampleQuiz.explanation,
        onOptionSelected: _noopString,
        onNext: _noop,
      ),
    ),
  );
}

// --- Per-type game bodies ---------------------------------------------------

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Games]/Lightning Quiz',
  name: 'Idle',
  type: LightningQuizBody,
)
Widget lightningQuizIdle(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: LightningQuizBody(
      state: const LightningQuizState(game: _sampleQuiz),
      onOptionSelected: _noopString,
      onNext: _noop,
    ),
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Games]/Lightning Quiz',
  name: 'Answered correct',
  type: LightningQuizBody,
)
Widget lightningQuizCorrect(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: LightningQuizBody(
      state: const LightningQuizState(
        game: _sampleQuiz,
        selectedOptionId: '0',
        answered: true,
        isCorrect: true,
      ),
      onOptionSelected: _noopString,
      onNext: _noop,
    ),
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Games]/Timeline',
  name: 'Idle',
  type: TimelineBody,
)
Widget timelineIdle(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: TimelineBody(
      state: const TimelineState(game: _sampleTimeline),
      onOptionSelected: _noopString,
      onNext: _noop,
    ),
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Games]/True or Myth',
  name: 'Idle',
  type: TrueOrMythBody,
)
Widget trueOrMythIdle(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: TrueOrMythBody(
      state: const TrueOrMythState(game: _sampleTrueOrMyth),
      onOptionSelected: _noopString,
      onNext: _noop,
    ),
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Games]/Battle of Curiosities',
  name: 'Idle',
  type: BattleOfCuriositiesBody,
)
Widget battleIdle(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: BattleOfCuriositiesBody(
      state: const BattleOfCuriositiesState(game: _sampleBattle),
      onOptionSelected: _noopString,
      onNext: _noop,
    ),
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Games]/Who Am I',
  name: 'Playing',
  type: WhoAmIBody,
)
Widget whoAmIPlaying(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: WhoAmIBody(
      state: const WhoAmIState(game: _sampleWhoAmI, hintsVisible: 2),
      onAnswerChanged: _noopString,
      onRevealHint: _noop,
      onSubmit: _noop,
      onNext: _noop,
    ),
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Games]/Who Am I',
  name: 'Answered',
  type: WhoAmIBody,
)
Widget whoAmIAnswered(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: WhoAmIBody(
      state: const WhoAmIState(
        game: _sampleWhoAmI,
        answer: 'Maria Quitéria',
        hintsVisible: 3,
        answered: true,
        isCorrect: true,
      ),
      onAnswerChanged: _noopString,
      onRevealHint: _noop,
      onSubmit: _noop,
      onNext: _noop,
    ),
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Games]/Complete Sentence',
  name: 'Idle',
  type: CompleteSentenceBody,
)
Widget completeSentenceIdle(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: CompleteSentenceBody(
      state: const CompleteSentenceState(game: _sampleSentence),
      onBlankSelected: _noopBlank,
      onSubmit: _noop,
      onNext: _noop,
    ),
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Games]/Mysterious Word',
  name: 'Playing',
  type: MysteriousWordBody,
)
Widget mysteriousWordPlaying(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: MysteriousWordBody(
      state: MysteriousWordState(
        game: _sampleWord,
        guessedLetters: {'I', 'M', 'X'},
        wrongCount: 1,
      ),
      onLetterPressed: _noopString,
      onNext: _noop,
    ),
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Games]/Connections',
  name: 'Playing',
  type: ConnectionsBody,
)
Widget connectionsPlaying(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: ConnectionsBody(
      state: const ConnectionsState(
        game: _sampleConnections,
        selectedLeftId: 'l1',
        links: {'l2': 'r2', 'l3': 'r3'},
        linkOrder: ['l2', 'l3'],
      ),
      onLeftSelected: _noopString,
      onRightSelected: _noopString,
      onUndoLast: _noop,
      onSubmit: _noop,
      onNext: _noop,
    ),
  );
}
