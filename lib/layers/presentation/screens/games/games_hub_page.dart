import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lume/app/navigation/app_router.gr.dart';
import 'package:lume/core/di/di.dart';
import 'package:lume/layers/presentation/screens/games/games_hub_bloc.dart';
import 'package:lume/layers/presentation/screens/games/games_hub_body.dart';
import 'package:lume/layers/presentation/screens/games/games_hub_event.dart';
import 'package:lume/layers/presentation/screens/games/games_hub_state.dart';
import 'package:lume/layers/presentation/screens/games/games_page.dart';
import 'package:lume_design_system/organisms/feedback/lume_loading_overlay.dart';

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

class _GamesHubView extends StatefulWidget {
  const _GamesHubView();

  @override
  State<_GamesHubView> createState() => _GamesHubViewState();
}

class _GamesHubViewState extends State<_GamesHubView> {
  @override
  void dispose() {
    hideLumeLoadingOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<GamesHubBloc, GamesHubState>(
          listenWhen: (previous, current) =>
              previous.isLoadingGame != current.isLoadingGame,
          listener: (context, state) {
            if (state.isLoadingGame) {
              showLumeLoadingOverlay(context);
            } else {
              hideLumeLoadingOverlay();
            }
          },
        ),
        BlocListener<GamesHubBloc, GamesHubState>(
          listenWhen: (previous, current) =>
              previous.openPlayRounds != current.openPlayRounds,
          listener: (context, state) async {
            final rounds = state.openPlayRounds;
            if (rounds == null) return;

            context.read<GamesHubBloc>().add(const GamesHubNavigationHandled());

            await context.router.push<void>(
              GamesRoute(rounds: rounds, mode: GamesPlayMode.hub),
            );
          },
        ),
        BlocListener<GamesHubBloc, GamesHubState>(
          listenWhen: (previous, current) =>
              previous.openArcadeRounds != current.openArcadeRounds,
          listener: (context, state) async {
            final rounds = state.openArcadeRounds;
            if (rounds == null) return;

            final record = state.arcadeRecord;
            context.read<GamesHubBloc>().add(const GamesHubNavigationHandled());

            await context.router.push<void>(
              GamesRoute(
                rounds: rounds,
                mode: GamesPlayMode.arcade,
                arcadeRecord: record,
              ),
            );
          },
        ),
        BlocListener<GamesHubBloc, GamesHubState>(
          listenWhen: (previous, current) =>
              previous.gameRoundErrorMessage != current.gameRoundErrorMessage,
          listener: (context, state) {
            final message = state.gameRoundErrorMessage;
            if (message == null) return;

            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(message)));

            context.read<GamesHubBloc>().add(
              const GamesHubGameRoundErrorDismissed(),
            );
          },
        ),
      ],
      child: BlocBuilder<GamesHubBloc, GamesHubState>(
        builder: (context, state) {
          return GamesHubBody(
            state: state,
            onRetry: () {
              context.read<GamesHubBloc>().add(
                const GamesHubStarted(forceRefresh: true),
              );
            },
            onGamePressed: (gameSlug) {
              context.read<GamesHubBloc>().add(GamesHubGamePressed(gameSlug));
            },
            onArcadePressed: () {
              context.read<GamesHubBloc>().add(const GamesHubArcadePressed());
            },
          );
        },
      ),
    );
  }
}
