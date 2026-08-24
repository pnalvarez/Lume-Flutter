const String gamesHubTitle = 'Jogos Lume';
const String gamesHubSubtitle = 'Jogue com o conteúdo das trilhas';
const String gamesHubSectionGeneral = 'Geral';
const String gamesHubSectionVisual = 'Jogos visuais';
const String gamesHubArcadeTitle = 'Modo Arcade';
const String gamesHubArcadeSubtitle =
    'Jogos aleatórios de todas as trilhas. Acerte em sequência para pontuar mais.';
const String gamesHubLoadError =
    'Não foi possível carregar os jogos. Tente novamente.';
const String gamesHubRetry = 'Tentar novamente';
const String gamesHubEmpty = 'Nenhum jogo disponível no momento.';
const String gamesHubRoundLoadError =
    'Não foi possível carregar esta rodada. Tente novamente.';
const String gamesHubRoundEmpty =
    'Ainda não há conteúdo disponível para este jogo.';
const String gamesHubRoundCompleteTitle = 'Rodada concluída';
const String gamesHubRoundCompleteAction = 'Voltar aos jogos';

String gamesHubRoundCompleteScore({
  required int correctCount,
  required int total,
}) => 'Você acertou $correctCount de $total jogos.';

/// Invisible sizing copy for [DisplayAsLoader] game-cell skeletons.
const String gamesHubLoadingCellTitle = 'Carregando título do jogo';
const String gamesHubLoadingCellDescription =
    'Descrição do jogo enquanto o conteúdo carrega';
