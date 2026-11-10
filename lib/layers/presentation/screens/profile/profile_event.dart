import 'package:flutter/foundation.dart';

@immutable
sealed class ProfileEvent {
  const ProfileEvent();
}

final class ProfileStarted extends ProfileEvent {
  const ProfileStarted({this.forceRefresh = false});

  final bool forceRefresh;
}

final class ProfileSignOutPressed extends ProfileEvent {
  const ProfileSignOutPressed();
}

final class ProfilePersonalInfoPressed extends ProfileEvent {
  const ProfilePersonalInfoPressed();
}

final class ProfileNavigationHandled extends ProfileEvent {
  const ProfileNavigationHandled();
}
