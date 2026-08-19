import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lume/app/navigation/app_router.gr.dart';
import 'package:lume/app/navigation/auth_gate.dart';
import 'package:lume/core/di/di.dart';
import 'package:lume/layers/domain/usecases/has_seen_onboarding.dart';
import 'package:lume/layers/domain/usecases/restore_session.dart';
import 'package:lume/layers/presentation/screens/splash/splash_bloc.dart';
import 'package:lume/layers/presentation/screens/splash/splash_event.dart';
import 'package:lume/layers/presentation/screens/splash/splash_state.dart';
import 'package:lume_design_system/molecules/loaders/circular_loader.dart';

/// Cold-start gate: restore the session, then replace this route.
@RoutePage()
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashBloc(
        restoreSession: getIt<IRestoreSession>(),
        hasSeenOnboarding: _DeferredHasSeenOnboarding(),
      )..add(const SplashStarted()),
      child: const _SplashView(),
    );
  }
}

class _SplashView extends StatelessWidget {
  const _SplashView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listenWhen: (previous, current) => current is SplashReady,
      listener: (context, state) {
        final destination = (state as SplashReady).destination;
        context.router.replace(_routeFor(destination));
      },
      child: const Scaffold(
        body: CircularLoader(fullPage: true),
      ),
    );
  }
}

PageRouteInfo<void> _routeFor(SplashDestination destination) {
  return switch (destination) {
    SplashDestination.onboarding => const OnboardingRoute(),
    SplashDestination.login => const LoginRoute(),
    SplashDestination.home => const HomeRoute(),
  };
}

final class _DeferredHasSeenOnboarding implements IHasSeenOnboarding {
  @override
  Future<bool> call() async {
    final useCase = await getIt.getAsync<IHasSeenOnboarding>();
    return useCase();
  }
}
