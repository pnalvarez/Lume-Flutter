import 'package:flutter/foundation.dart';
import 'package:lume/layers/presentation/screens/onboarding/onboarding_slides.dart';

@immutable
final class OnboardingState {
  const OnboardingState({this.index = 0, this.goToLogin = false});

  final int index;
  final bool goToLogin;

  bool get isFirst => index <= 0;
  bool get isLast => index >= onboardingSlides.length - 1;

  OnboardingState copyWith({int? index, bool? goToLogin}) {
    return OnboardingState(
      index: index ?? this.index,
      goToLogin: goToLogin ?? this.goToLogin,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is OnboardingState &&
      other.index == index &&
      other.goToLogin == goToLogin;

  @override
  int get hashCode => Object.hash(index, goToLogin);
}
