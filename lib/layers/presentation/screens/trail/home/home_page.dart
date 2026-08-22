import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lume/app/navigation/app_router.gr.dart';
import 'package:lume/core/di/di.dart';
import 'package:lume/layers/presentation/screens/trail/home/home_bloc.dart';
import 'package:lume/layers/presentation/screens/trail/home/home_body.dart';
import 'package:lume/layers/presentation/screens/trail/home/home_event.dart';
import 'package:lume/layers/presentation/screens/trail/home/home_state.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeBloc>()..add(const HomeStarted()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listenWhen: (previous, current) =>
          previous.selectedTrailId != current.selectedTrailId,
      listener: (context, state) async {
        final trailId = state.selectedTrailId;
        if (trailId == null) return;
        context.read<HomeBloc>().add(const HomeNavigationHandled());
        await context.router.push(TrailDetailRoute(trailId: trailId));
        if (!context.mounted) return;
        context.read<HomeBloc>().add(const HomeStarted(forceRefresh: true));
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return HomeBody(
            state: state,
            onRetry: () {
              context.read<HomeBloc>().add(
                const HomeStarted(forceRefresh: true),
              );
            },
            onTrailPressed: (trailId) {
              context.read<HomeBloc>().add(HomeTrailPressed(trailId));
            },
          );
        },
      ),
    );
  }
}
