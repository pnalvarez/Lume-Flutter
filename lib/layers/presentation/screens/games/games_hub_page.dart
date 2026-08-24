import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lume/core/di/di.dart';
import 'package:lume/layers/presentation/screens/games/games_hub_bloc.dart';
import 'package:lume/layers/presentation/screens/games/games_hub_body.dart';
import 'package:lume/layers/presentation/screens/games/games_hub_event.dart';
import 'package:lume/layers/presentation/screens/games/games_hub_state.dart';

@RoutePage()
class GamesHubPage extends StatelessWidget {
  const GamesHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<GamesHubBloc>()..add(const GamesHubStarted()),
      child: const _GamesHubView(),
    );
  }
}

class _GamesHubView extends StatelessWidget {
  const _GamesHubView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GamesHubBloc, GamesHubState>(
      builder: (context, state) {
        return GamesHubBody(
          state: state,
          onRetry: () {
            context.read<GamesHubBloc>().add(
              const GamesHubStarted(forceRefresh: true),
            );
          },
          onGamePressed: (gameId) {
            context.read<GamesHubBloc>().add(GamesHubGamePressed(gameId));
          },
          onArcadePressed: () {
            context.read<GamesHubBloc>().add(const GamesHubArcadePressed());
          },
        );
      },
    );
  }
}
