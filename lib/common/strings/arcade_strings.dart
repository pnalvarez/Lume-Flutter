const String arcadeLeaveTitle = 'Encerrar o modo arcade?';
const String arcadeLeaveBody =
    'Sua partida atual termina aqui, mas o que você já pontuou está salvo.';
const String arcadeLeaveConfirm = 'Encerrar';
const String arcadeLeaveCancel = 'Continuar jogando';

const String arcadeCompleteNewRecordTitle = 'Novo recorde!';
const String arcadeCompleteTitle = 'Fim de jogo';
const String arcadeCompleteAction = 'Voltar aos jogos';
const String arcadeRoundLoadError =
    'Não foi possível carregar a próxima rodada.';

String arcadeGameCounter(int games) => games == 1 ? '1 jogo' : '$games jogos';

String arcadeHeaderScored(int scored) => 'Acertou $scored';

String arcadeHeaderRecord(int record) => 'Recorde atual: $record';

String arcadeCompleteScore(int scored) =>
    'Você acertou ${arcadeGameCounter(scored)} nesta partida.';

String arcadeCompleteRecord(int record) =>
    'Seu recorde: ${arcadeGameCounter(record)}.';

String arcadeCompletePreviousRecord(int record) =>
    'Recorde anterior: ${arcadeGameCounter(record)}.';

String arcadeCompleteXp(int xp) => 'Você ganhou $xp XP nesta partida.';
