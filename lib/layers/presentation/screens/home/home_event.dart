import 'package:flutter/foundation.dart';

@immutable
sealed class HomeEvent {
  const HomeEvent();
}

final class HomeSignOutPressed extends HomeEvent {
  const HomeSignOutPressed();
}

final class HomeNavigationHandled extends HomeEvent {
  const HomeNavigationHandled();
}
