import 'package:flutter/foundation.dart';

@immutable
sealed class OnboardingEvent {
  const OnboardingEvent();
}

final class OnboardingPageChanged extends OnboardingEvent {
  const OnboardingPageChanged(this.index);

  final int index;
}

final class OnboardingNextPressed extends OnboardingEvent {
  const OnboardingNextPressed();
}

final class OnboardingBackPressed extends OnboardingEvent {
  const OnboardingBackPressed();
}

final class OnboardingSkipPressed extends OnboardingEvent {
  const OnboardingSkipPressed();
}

final class OnboardingNavigationHandled extends OnboardingEvent {
  const OnboardingNavigationHandled();
}
