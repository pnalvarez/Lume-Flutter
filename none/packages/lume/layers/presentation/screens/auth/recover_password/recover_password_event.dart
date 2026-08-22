import 'package:flutter/foundation.dart';

@immutable
sealed class RecoverPasswordEvent {
  const RecoverPasswordEvent();
}

final class RecoverPasswordEmailChanged extends RecoverPasswordEvent {
  const RecoverPasswordEmailChanged(this.email);

  final String email;
}

final class RecoverPasswordSubmitted extends RecoverPasswordEvent {
  const RecoverPasswordSubmitted();
}

final class RecoverPasswordNoticeHandled extends RecoverPasswordEvent {
  const RecoverPasswordNoticeHandled();
}

final class RecoverPasswordGoToLogin extends RecoverPasswordEvent {
  const RecoverPasswordGoToLogin();
}

final class RecoverPasswordNavigationHandled extends RecoverPasswordEvent {
  const RecoverPasswordNavigationHandled();
}
