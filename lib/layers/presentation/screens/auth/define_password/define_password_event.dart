import 'package:flutter/foundation.dart';

enum DefinePasswordStatus { checking, ready, invalid }

enum DefinePasswordDestination { home, recoverPassword }

@immutable
sealed class DefinePasswordEvent {
  const DefinePasswordEvent();
}

final class DefinePasswordStarted extends DefinePasswordEvent {
  const DefinePasswordStarted();
}

final class DefinePasswordChanged extends DefinePasswordEvent {
  const DefinePasswordChanged(this.password);

  final String password;
}

final class DefinePasswordConfirmChanged extends DefinePasswordEvent {
  const DefinePasswordConfirmChanged(this.confirmation);

  final String confirmation;
}

final class DefinePasswordSubmitted extends DefinePasswordEvent {
  const DefinePasswordSubmitted();
}

final class DefinePasswordRequestNewLink extends DefinePasswordEvent {
  const DefinePasswordRequestNewLink();
}

final class DefinePasswordNavigationHandled extends DefinePasswordEvent {
  const DefinePasswordNavigationHandled();
}
