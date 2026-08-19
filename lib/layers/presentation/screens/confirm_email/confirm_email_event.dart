import 'package:flutter/foundation.dart';

@immutable
sealed class ConfirmEmailEvent {
  const ConfirmEmailEvent();
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
