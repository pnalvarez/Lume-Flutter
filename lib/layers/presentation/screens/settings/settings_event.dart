import 'package:flutter/foundation.dart';

@immutable
sealed class SettingsEvent {
  const SettingsEvent();
}

final class SettingsPersonalInfoPressed extends SettingsEvent {
  const SettingsPersonalInfoPressed();
}

final class SettingsCategoriesPressed extends SettingsEvent {
  const SettingsCategoriesPressed();
}

final class SettingsNavigationHandled extends SettingsEvent {
  const SettingsNavigationHandled();
}
