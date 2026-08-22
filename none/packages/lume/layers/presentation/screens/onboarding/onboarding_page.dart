import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lume/app/navigation/app_router.gr.dart';
import 'package:lume/core/di/di.dart';
import 'package:lume/layers/presentation/screens/onboarding/onboarding_bloc.dart';
import 'package:lume/layers/presentation/screens/onboarding/onboarding_body.dart';
import 'package:lume/layers/presentation/screens/onboarding/onboarding_event.dart';
import 'package:lume/layers/presentation/screens/onboarding/onboarding_state.dart';

@RoutePage()
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OnboardingBloc>(),
      child: const _OnboardingView(),
    );
  }
}

class _OnboardingView extends StatefulWidget {
  const _OnboardingView();

  @override
  State<_OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<_OnboardingView> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingBloc, OnboardingState>(
      listenWhen: (previous, current) =>
          previous.index != current.index ||
          previous.goToLogin != current.goToLogin,
      listener: (context, state) {
        if (state.goToLogin) {
          context.read<OnboardingBloc>().add(
            const OnboardingNavigationHandled(),
          );
          context.router.replace(const LoginRoute());
          return;
        }
        if (_controller.hasClients &&
            _controller.page?.round() != state.index) {
          _controller.animateToPage(
            state.index,
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
          );
        }
      },
      child: BlocBuilder<OnboardingBloc, OnboardingState>(
        builder: (context, state) {
          return OnboardingBody(
            pageController: _controller,
            index: state.index,
            isLast: state.isLast,
            onSkip: () {
              context.read<OnboardingBloc>().add(const OnboardingSkipPressed());
            },
            onNext: () {
              context.read<OnboardingBloc>().add(const OnboardingNextPressed());
            },
            onPageChanged: (index) {
              context.read<OnboardingBloc>().add(OnboardingPageChanged(index));
            },
          );
        },
      ),
    );
  }
}
