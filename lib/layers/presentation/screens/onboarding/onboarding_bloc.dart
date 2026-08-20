import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lume/layers/domain/usecases/mark_onboarding_seen.dart';
import 'package:lume/layers/presentation/screens/onboarding/onboarding_event.dart';
import 'package:lume/layers/presentation/screens/onboarding/onboarding_slides.dart';
import 'package:lume/layers/presentation/screens/onboarding/onboarding_state.dart';

@injectable
final class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc(this._markOnboardingSeen) : super(const OnboardingState()) {
    on<OnboardingPageChanged>(_onPageChanged);
    on<OnboardingNextPressed>(_onNextPressed);
    on<OnboardingBackPressed>(_onBackPressed);
    on<OnboardingSkipPressed>(_onSkipPressed);
    on<OnboardingNavigationHandled>(_onNavigationHandled);
  }

  final IMarkOnboardingSeen _markOnboardingSeen;

  void _onPageChanged(
    OnboardingPageChanged event,
    Emitter<OnboardingState> emit,
  ) {
    final next = event.index.clamp(0, onboardingSlides.length - 1);
    if (next == state.index) return;
    emit(state.copyWith(index: next));
  }

  Future<void> _onNextPressed(
    OnboardingNextPressed event,
    Emitter<OnboardingState> emit,
  ) async {
    if (state.isLast) {
      await _complete(emit);
      return;
    }
    emit(state.copyWith(index: state.index + 1));
  }

  void _onBackPressed(
    OnboardingBackPressed event,
    Emitter<OnboardingState> emit,
  ) {
    if (state.isFirst) return;
    emit(state.copyWith(index: state.index - 1));
  }

  Future<void> _onSkipPressed(
    OnboardingSkipPressed event,
    Emitter<OnboardingState> emit,
  ) {
    return _complete(emit);
  }

  void _onNavigationHandled(
    OnboardingNavigationHandled event,
    Emitter<OnboardingState> emit,
  ) {
    if (!state.goToLogin) return;
    emit(state.copyWith(goToLogin: false));
  }

  Future<void> _complete(Emitter<OnboardingState> emit) async {
    try {
      await _markOnboardingSeen();
    } on Object {
      // Still leave onboarding; the flag is a convenience, not a gate.
    }
    emit(state.copyWith(goToLogin: true));
  }
}
