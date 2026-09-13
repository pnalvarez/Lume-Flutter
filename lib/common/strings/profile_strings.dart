const String profileTitle = 'Perfil';
const String profileSettingsTooltip = 'Preferências';
const String profileSignOutTooltip = 'Sair';
const String profileSignOutTitle = 'Sair da conta?';
const String profileSignOutBody =
    'Você precisará entrar de novo para continuar.';
const String profileSignOutConfirm = 'Sair';
const String profileSignOutCancel = 'Cancelar';
const String profileLevelLabel = 'Nível';
const String profileStreakLabel = 'Dias seguidos';
const String profileDaysInAppLabel = 'No app';
const String profileSubmodulesLabel = 'Submódulos';
const String profileXpTotalLabel = 'XP Total';
const String profileSequenceLabel = 'Sequência';
const String profileXpTodayLabel = 'XP hoje';
const String profileXpWeekLabel = 'XP semana';
const String profileBestStreakLabel = 'Maior seq.';
const String profileLoadingNamePlaceholder = 'Explorador';
const String profileLoadError = 'Não foi possível carregar o perfil.';
const String profileRetry = 'Tentar novamente';
const String profileDisplayNameFallback = 'Explorador';

// --- Settings ---------------------------------------------------------------

const String settingsTitle = 'Configurações';
const String settingsPersonalInfoTitle = 'Informações pessoais';
const String settingsPersonalInfoDescription = 'Nome, sobrenome e idade';
const String settingsCategoriesTitle = 'Categorias';
const String settingsCategoriesDescription = 'Temas que você quer aprender';

String profileMemberSince(String? memberSince) =>
    'Membro desde ${memberSince ?? '—'}';

/// Formats a member-start [DateTime] as zero-padded `dd/mm/yyyy`.
String? profileFormatMemberSince(DateTime? memberStartedAt) {
  if (memberStartedAt == null) return null;
  final day = memberStartedAt.day.toString().padLeft(2, '0');
  final month = memberStartedAt.month.toString().padLeft(2, '0');
  return '$day/$month/${memberStartedAt.year}';
}

String profileStreakValue(int streak) => streak == 1 ? '1 dia' : '$streak dias';

String profileXpToNextLevel(int xpInLevel, int xpForNextLevel) =>
    '$xpInLevel/$xpForNextLevel XP para o próximo nível';

String profileDaysInAppValue(int days) => '${days}d';

String profileSequenceTileValue(int streak) => '${streak}d';
