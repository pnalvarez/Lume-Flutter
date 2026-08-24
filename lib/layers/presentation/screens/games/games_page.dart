import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lume/core/di/di.dart';
import 'package:lume/layers/presentation/screens/games/games_hub_bloc.dart';
import 'package:lume/layers/presentation/screens/games/games_hub_body.dart';
import 'package:lume/layers/presentation/screens/games/games_hub_event.dart';
import 'package:lume/layers/presentation/screens/games/games_hub_state.dart';

@RoutePage()
class GamesPage extends StatelessWidget {
  const GamesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<GamesHubBloc>()..add(const GamesHubStarted()),
      child: const _GamesView(),
    );
  }
}

class _GamesView extends StatelessWidget {
  const _GamesView();

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
