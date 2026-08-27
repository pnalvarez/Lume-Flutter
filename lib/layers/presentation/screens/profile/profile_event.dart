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

final class ProfileSettingsPressed extends ProfileEvent {
  const ProfileSettingsPressed();
}

final class ProfileNavigationHandled extends ProfileEvent {
  const ProfileNavigationHandled();
}
