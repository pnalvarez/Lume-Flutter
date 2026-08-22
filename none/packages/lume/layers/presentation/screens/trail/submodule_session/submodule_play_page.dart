import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lume/core/di/di.dart';
import 'package:lume/layers/presentation/screens/games/game_play_factory.dart';
import 'package:lume/layers/presentation/screens/trail/submodule_session/submodule_play_body.dart';
import 'package:lume/layers/presentation/screens/trail/submodule_session/submodule_session_bloc.dart';
import 'package:lume/layers/presentation/screens/trail/submodule_session/submodule_session_event.dart';
import 'package:lume/layers/presentation/screens/trail/submodule_session/submodule_session_state.dart';

/// Play step hosted by [SubmoduleSessionPage] (not a nested route).
class SubmodulePlayView extends StatelessWidget {
  const SubmodulePlayView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubmoduleSessionBloc, SubmoduleSessionState>(
      buildWhen: (previous, current) =>
          previous.currentIndex != current.currentIndex ||
          previous.status != current.status ||
          previous.stage != current.stage ||
          previous.errorMessage != current.errorMessage ||
          previous.progressValue != current.progressValue ||
          previous.games != current.games,
      builder: (context, state) {
        final isSaving = state.status == SubmoduleSessionStatus.saving;
        final errorMessage =
            state.status == SubmoduleSessionStatus.error &&
                state.stage == SubmoduleSessionStage.playing
            ? state.errorMessage
            : null;

        Widget? gameSlot;
        final game = state.currentGame;
        if (!isSaving &&
            errorMessage == null &&
            state.status == SubmoduleSessionStatus.ready &&
            game != null) {
          gameSlot = KeyedSubtree(
            key: ValueKey('${state.currentIndex}-${game.pairId}'),
            child: getIt<IGamePlayFactory>().build(
              game: game,
              onFinished: (correct) {
                context.read<SubmoduleSessionBloc>().add(
                  SubmoduleSessionGameFinished(correct),
                );
              },
            ),
          );
        }

        return SubmodulePlayBody(
          progressValue: state.progressValue,
          isSaving: isSaving,
          errorMessage: errorMessage,
          gameSlot: gameSlot,
          onAbandoned: () {
            context.read<SubmoduleSessionBloc>().add(
              const SubmoduleSessionAbandoned(),
            );
          },
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
