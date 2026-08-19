/// Copy for the auth flow (login, sign-up, email confirmation, password recovery).
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
const String loginFooterNoAccount = 'Não tem conta? Criar uma';
const String loginFooterHasAccount = 'Já tem conta? Entrar';
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
