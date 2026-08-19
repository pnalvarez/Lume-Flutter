import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/domain/usecases/mark_onboarding_seen.dart';
import 'package:lume/layers/presentation/screens/onboarding/onboarding_bloc.dart';
import 'package:lume/layers/presentation/screens/onboarding/onboarding_event.dart';
import 'package:lume/layers/presentation/screens/onboarding/onboarding_state.dart';

class _MarkSeen implements IMarkOnboardingSeen {
  var calls = 0;

  @override
  Future<void> call() async {
    calls += 1;
  }
}

void main() {
  blocTest<OnboardingBloc, OnboardingState>(
    'next on the last slide marks onboarding seen and goes to login',
    build: () => OnboardingBloc(markOnboardingSeen: _MarkSeen()),
    act: (bloc) async {
      bloc.add(const OnboardingNextPressed());
      bloc.add(const OnboardingNextPressed());
    },
    expect: () => [
      const OnboardingState(index: 1),
      const OnboardingState(index: 1, goToLogin: true),
    ],
  );

  blocTest<OnboardingBloc, OnboardingState>(
    'skip marks onboarding seen and goes to login',
    build: () => OnboardingBloc(markOnboardingSeen: _MarkSeen()),
    act: (bloc) => bloc.add(const OnboardingSkipPressed()),
    expect: () => [const OnboardingState(goToLogin: true)],
  );
}
