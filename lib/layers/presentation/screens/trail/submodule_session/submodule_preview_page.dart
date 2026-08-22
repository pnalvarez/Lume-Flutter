import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lume/layers/presentation/screens/trail/submodule_session/submodule_preview_body.dart';
import 'package:lume/layers/presentation/screens/trail/submodule_session/submodule_session_bloc.dart';
import 'package:lume/layers/presentation/screens/trail/submodule_session/submodule_session_event.dart';
import 'package:lume/layers/presentation/screens/trail/submodule_session/submodule_session_state.dart';

/// Preview step hosted by [SubmoduleSessionPage] (not a nested route).
class SubmodulePreviewView extends StatelessWidget {
  const SubmodulePreviewView({super.key});

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
          onContinue: () {
            context.read<SubmoduleSessionBloc>().add(
              const SubmoduleSessionPreviewContinue(),
            );
          },
          onRetry: () {
            context.read<SubmoduleSessionBloc>().add(
              SubmoduleSessionStarted(
                trailId: state.trailId,
                submoduleId: state.submoduleId,
                forceRefresh: true,
              ),
            );
          },
        );
      },
    );
  }
}
