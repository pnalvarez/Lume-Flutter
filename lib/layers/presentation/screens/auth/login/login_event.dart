import 'package:flutter/foundation.dart';

enum LoginMode { login, signup }

enum LoginDestination { home, confirmEmail, recoverPassword, onboarding }

@immutable
sealed class LoginEvent {
  const LoginEvent();
}

final class LoginEmailChanged extends LoginEvent {
  const LoginEmailChanged(this.email);

  final String email;
}

final class LoginPasswordChanged extends LoginEvent {
  const LoginPasswordChanged(this.password);

  final String password;
}

final class LoginModeToggled extends LoginEvent {
  const LoginModeToggled();
}

final class LoginSubmitted extends LoginEvent {
  const LoginSubmitted();
}

final class LoginForgotPasswordPressed extends LoginEvent {
  const LoginForgotPasswordPressed();
}

final class LoginWhatIsLumePressed extends LoginEvent {
  const LoginWhatIsLumePressed();
}

final class LoginNavigationHandled extends LoginEvent {
  const LoginNavigationHandled();
}
