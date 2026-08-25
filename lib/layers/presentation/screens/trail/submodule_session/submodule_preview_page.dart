import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lume/app/navigation/app_router.gr.dart';
import 'package:lume/layers/presentation/screens/games/game_round.dart';
import 'package:lume/layers/presentation/screens/games/games_page.dart';
import 'package:lume/layers/presentation/screens/trail/submodule_session/submodule_preview_body.dart';
import 'package:lume/layers/presentation/screens/trail/submodule_session/submodule_session_bloc.dart';
import 'package:lume/layers/presentation/screens/trail/submodule_session/submodule_session_event.dart';
import 'package:lume/layers/presentation/screens/trail/submodule_session/submodule_session_state.dart';

/// Preview step hosted by [SubmoduleSessionPage] (not a nested route).
class SubmodulePreviewView extends StatelessWidget {
  const SubmodulePreviewView({super.key});

  Future<void> _openGames(BuildContext context) async {
    final sessionBloc = context.read<SubmoduleSessionBloc>();
    final state = sessionBloc.state;
    if (state.status != SubmoduleSessionStatus.ready || state.games.isEmpty) {
      return;
    }

    final rounds = [
      for (final game in state.games)
        GameRound(id: '${game.pairId}', game: game),
    ];

    final result = await context.router.push<GamesSequenceResult?>(
      GamesRoute(
        rounds: rounds,
        onSaveRound: ({required roundId, required scorePct}) async {
          sessionBloc.add(
            SubmoduleSessionRoundScored(
              pairId: int.parse(roundId),
              scorePct: scorePct,
            ),
          );
          return 0;
        },
        mode: GamesPlayMode.trail,
      ),
    );

    if (!context.mounted) return;

    if (result != null) {
      sessionBloc.add(
        SubmoduleSessionGamesCompleted(correctCount: result.correctCount),
      );
    } else {
      sessionBloc.add(const SubmoduleSessionGamesCancelled());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubmoduleSessionBloc, SubmoduleSessionState>(
      builder: (context, state) {
        final isLoading = state.status == SubmoduleSessionStatus.loading;
        final errorMessage =
            state.status == SubmoduleSessionStatus.error &&
                state.stage == SubmoduleSessionStage.preview
            ? state.errorMessage
            : null;

        return SubmodulePreviewBody(
          isLoading: isLoading,
          progressValue: state.progressValue,
          title: state.title,
          preview: state.preview,
          imageUrl: state.imageUrl,
          errorMessage: errorMessage,
          onAbandoned: () {
            context.read<SubmoduleSessionBloc>().add(
              const SubmoduleSessionAbandoned(),
            );
          },
          onContinue: () => _openGames(context),
          onRetry: () {
            if (state.canRetrySave) {
              context.read<SubmoduleSessionBloc>().add(
                const SubmoduleSessionRetrySave(),
              );
            } else {
              context.read<SubmoduleSessionBloc>().add(
                SubmoduleSessionStarted(
                  trailId: state.trailId,
                  submoduleId: state.submoduleId,
                  forceRefresh: true,
                ),
              );
            }
          },
        );
      },
    );
  }
}
