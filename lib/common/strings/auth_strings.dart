/// User-facing copy for auth, onboarding, and early app chrome.
library;

// --- Shared chrome ----------------------------------------------------------

const String authBrandTitle = 'LUME';
const String authBack = 'Voltar';
const String authBackToLogin = 'Voltar para o login';
const String authEmailPlaceholder = 'email';

// --- Login / sign-up --------------------------------------------------------

const String loginSubtitle = 'Microlearning com jogos';
const String loginPasswordPlaceholder = 'senha';
const String loginForgotPassword = 'Esqueci minha senha';
const String loginCtaSignIn = 'Entrar';
const String loginCtaSignUp = 'Criar conta';
const String loginFooterNoAccountPrompt = 'Não tem conta?';
const String loginFooterNoAccountAction = 'Criar uma';
const String loginFooterHasAccountPrompt = 'Já tem conta?';
const String loginFooterHasAccountAction = 'Entrar';
const String loginWhatIsLume = 'O que é o Lume?';
const String loginEmailNotConfirmedNotice =
    'Confirme seu email antes de entrar.';

// --- Confirm email ----------------------------------------------------------

const String confirmEmailSubtitle = 'Confirmação de email';
const String confirmEmailTitle = 'Verifique seu email';
const String confirmEmailBodyPrefix = 'Enviamos um link de confirmação para';
const String confirmEmailBodyUnspecifiedRecipient = ' o email cadastrado';
const String confirmEmailBodySuffix =
    '. Confirme sua conta antes de fazer login no Lume.';
const String confirmEmailResend = 'Reenviar email de confirmação';
const String confirmEmailResending = 'Reenviando...';
const String confirmEmailResentNotice = 'Email de confirmação reenviado.';
const String confirmEmailSuccessNotice =
    'Email confirmado! Entrando no Lume...';

// --- Recover password -------------------------------------------------------

const String recoverPasswordSubtitle = 'Recuperação de senha';
const String recoverPasswordInstructions =
    'Informe o email cadastrado e enviaremos um link para você redefinir sua senha.';
const String recoverPasswordSend = 'Enviar email de recuperação';
const String recoverPasswordSending = 'Enviando...';
const String recoverPasswordSentTitle = 'Email enviado!';
const String recoverPasswordSentBodyPrefix =
    'Enviamos um link de recuperação para ';
const String recoverPasswordSentBodySuffix =
    '. Verifique sua caixa de entrada e o spam.';

// --- Define password --------------------------------------------------------

const String definePasswordSubtitle = 'Definir nova senha';
const String definePasswordChecking = 'Validando seu link de recuperação...';
const String definePasswordInvalidTitle = 'Link inválido ou expirado';
const String definePasswordInvalidBody =
    'Este link de recuperação não é mais válido. Solicite um novo para redefinir sua senha.';
const String definePasswordRequestNewLink = 'Solicitar novo link';
const String definePasswordInstructions =
    'Escolha uma nova senha para sua conta.';
const String definePasswordPlaceholder = 'nova senha';
const String definePasswordConfirmPlaceholder = 'confirmar nova senha';
const String definePasswordSubmit = 'Redefinir senha';
const String definePasswordSaving = 'Salvando...';
const String definePasswordSuccessNotice = 'Senha redefinida com sucesso!';
const String definePasswordValidationBothEmpty =
    'Digite a nova senha e confirme a senha.';
const String definePasswordValidationPasswordEmpty = 'Digite a nova senha.';
const String definePasswordValidationConfirmEmpty = 'Confirme a nova senha.';
const String definePasswordValidationPasswordShort =
    'A senha deve ter pelo menos 6 caracteres.';
const String definePasswordValidationConfirmShort =
    'A confirmação deve ter pelo menos 6 caracteres.';
const String definePasswordValidationMismatch = 'As senhas não coincidem.';

// --- Auth failures ----------------------------------------------------------

const String authErrorEmailNotConfirmed = loginEmailNotConfirmedNotice;
const String authErrorInvalidCredentials = 'Email ou senha incorretos.';
const String authErrorEmailAlreadyRegistered = 'Este email já está cadastrado.';
const String authErrorNetwork =
    'Não foi possível conectar. Verifique sua conexão e tente novamente.';
const String authErrorGeneric = 'Erro ao autenticar';

// --- Onboarding -------------------------------------------------------------

const String onboardingSkip = 'Pular';
const String onboardingNext = 'Próximo';
const String onboardingStart = 'Começar agora';
const String onboardingLevelBadge = 'Nv. 12';
const String onboardingXpLabel = 'XP';
const String onboardingXpProgress = '820 / 1000';
const String onboardingSlide1Title = 'Você aprende pouco e esquece rápido ⚡';
const String onboardingSlide1Body =
    'A maioria das pessoas não tem tempo — nem paciência — pra sentar e estudar. O resultado? Um repertório raso, que não acompanha as conversas que importam. O Lume resolve isso em 5 minutos por dia.';
const String onboardingSlide1Alt =
    'Ilustração representando esquecimento e aprendizado raso';
const String onboardingSlide2Title =
    'Trilhas, revisões e jogos pra você chegar ao topo 🏆';
const String onboardingSlide2Body =
    'Desbloqueie trilhas de História, Filosofia, Arte, Ciência, Música, Literatura, Geografia e muito mais. Fixe o conteúdo em quizzes de revisão. Jogue Quiz Relâmpago, Verdade ou Mito e Batalha de Curiosidades. Ganhe XP, suba de nível e chegue ao nível máximo enquanto constrói um repertório que enriquece sua vida.';
const String onboardingSlide2Alt =
    'Ilustração de gamificação com barra de XP, troféu e estrelas';

// --- Dashboard / home chrome ------------------------------------------------

const String dashboardTabTrail = 'Trilha';
const String dashboardTabGames = 'Jogos';
const String dashboardTabProfile = 'Perfil';
const String homeAuthenticatedMessage = 'Você está autenticado.';
const String homeSignOut = 'Sair';

// --- Select category --------------------------------------------------------

const String selectCategoryTitle = 'O que você quer aprender?';
const String selectCategorySubtitle =
    'Escolha os temas que mais te interessam. Você pode mudar depois.';
const String selectCategorySelectAll = 'Selecionar tudo';
const String selectCategoryCta = 'Começar agora';
const String selectCategorySaveCta = 'Salvar';
const String selectCategoryLoadError =
    'Não foi possível carregar as categorias. Tente novamente.';
const String selectCategoryRetry = 'Tentar novamente';
const String selectCategorySaveError = 'Erro ao salvar preferências';
const String selectCategorySessionExpired =
    'Sessão expirada. Faça login novamente.';

/// Invisible sizing copy for [DisplayAsLoader] when no categories are cached yet.
const selectCategoryLoadingChipLabels = [
  'Categoria exemplo',
  'Tema de estudo',
  'Área de interesse',
  'Outro tema',
  'Mais um tema',
  'Categoria',
];
