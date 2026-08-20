import 'package:flutter/foundation.dart';
import 'package:lume/layers/domain/models/auth/auth_session.dart';

enum ConfirmEmailDestination { home, selectCategory }

@immutable
sealed class ConfirmEmailEvent {
  const ConfirmEmailEvent();
}

final class ConfirmEmailStarted extends ConfirmEmailEvent {
  const ConfirmEmailStarted({this.email = ''});

  final String email;
}

final class ConfirmEmailChanged extends ConfirmEmailEvent {
  const ConfirmEmailChanged(this.email);

  final String email;
}

final class ConfirmEmailResendPressed extends ConfirmEmailEvent {
  const ConfirmEmailResendPressed();
}

final class ConfirmEmailNoticeHandled extends ConfirmEmailEvent {
  const ConfirmEmailNoticeHandled();
}

final class ConfirmEmailNavigationHandled extends ConfirmEmailEvent {
  const ConfirmEmailNavigationHandled();
}

/// Internal: auth stream pushed a new session snapshot.
final class ConfirmEmailAuthUpdated extends ConfirmEmailEvent {
  const ConfirmEmailAuthUpdated(this.session);

  final AuthSession? session;
}
