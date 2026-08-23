/// User-facing copy for the trail (first) tab and in-session games.
library;

// --- Home -------------------------------------------------------------------

const String trailHomeGreetingFallback = 'Explorador';
const String trailHomeGreetingPrefix = 'Olá, ';
const String trailHomeSubtitle = 'Vamos aprender algo novo hoje?';
const String trailHomeSectionTitle = 'Suas trilhas';
const String trailHomeEmpty = 'Nenhuma trilha disponível no momento.';
const String trailHomeLoadError = 'Não foi possível carregar suas trilhas.';
const String trailHomeRetry = 'Tentar novamente';
const String trailHomeSubmodulesLabel = 'submódulos';
const String trailHomeEmojiFallback = '🎮';

// --- Trail detail -----------------------------------------------------------

const String trailDetailLoadError = 'Não foi possível carregar esta trilha.';
const String trailDetailRetry = 'Tentar novamente';
const String trailDetailEmpty = 'Esta trilha ainda não tem submódulos.';
const String trailDetailSubmoduleDone = 'Concluído';
const String trailDetailSubmoduleTodo = 'Disponível';
const String trailDetailSubmoduleLocked = 'Bloqueado';
const String trailDetailGamesCountSuffix = 'jogos';

// --- Submodule session ------------------------------------------------------

const String trailPreviewContinue = 'Prosseguir';
const String trailSessionCompleteTitle = 'Você concluiu\no submódulo';
const String trailSessionCompleteBodyPrefix = 'Você acertou ';
const String trailSessionCompleteBodyMiddle = ' de ';
const String trailSessionCompleteBodySuffix = ' jogos.';

String trailSessionCompleteScore({
  required int correctCount,
  required int total,
}) =>
    '$trailSessionCompleteBodyPrefix$correctCount'
    '$trailSessionCompleteBodyMiddle$total'
    '$trailSessionCompleteBodySuffix';
const String trailSessionBackToTrail = 'Voltar para a trilha';
const String trailSessionLeaveTitle = 'Sair do submódulo?';
const String trailSessionLeaveBody =
    'Se sair agora, você perderá o progresso deste submódulo.';
const String trailSessionLeaveConfirm = 'Sair';
const String trailSessionLeaveCancel = 'Continuar';
const String trailSessionLoadError =
    'Não foi possível carregar este submódulo.';
const String trailSessionSaveError =
    'Não foi possível salvar seu progresso. Tente novamente.';
const String trailSessionRetry = 'Tentar novamente';
const String trailSessionEmptyGames = 'Este submódulo não tem jogos.';

// --- Shared game chrome -----------------------------------------------------

const String trailGameNext = 'Próximo';
const String trailGameCorrect = 'Acertou!';
const String trailGameWrong = 'Não foi dessa vez';
const String trailGameFeedbackDismiss = 'Entendi';
const String trailGameSubmit = 'Responder';
const String trailGameTypeBattle = 'Batalha de curiosidades';
const String trailGameTypeMysteriousWord = 'Palavra misteriosa';
const String trailGameTypeWhoAmI = 'Quem sou eu?';
const String trailGameTypeConnections = 'Conexões';
const String trailGameTypeTimeline = 'O que aconteceu depois?';
const String trailGameTypeTrueOrMyth = 'Verdade, mito ou parcial';
const String trailGameTypeCompleteSentence = 'Complete a sentença';
const String trailGameTypeLightningQuiz = 'Quiz relâmpago';
const String trailGameTrue = 'Verdade';
const String trailGameMyth = 'Mito';
const String trailGamePartial = 'Parcial';
const String trailGameHint = 'Dica';
const String trailGameRevealHint = 'Revelar dica';
const String trailGameAnswerPlaceholder = 'Sua resposta';
const String trailGameLivesLeft = 'vidas';
const String trailGameUndoLastPair = 'Desfazer último par';
