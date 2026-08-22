import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lume/layers/presentation/screens/trail/submodule_session/submodule_complete_body.dart';
import 'package:lume/layers/presentation/screens/trail/submodule_session/submodule_session_bloc.dart';
import 'package:lume/layers/presentation/screens/trail/submodule_session/submodule_session_event.dart';
import 'package:lume/layers/presentation/screens/trail/submodule_session/submodule_session_state.dart';

/// Complete step hosted by [SubmoduleSessionPage] (not a nested route).
class SubmoduleCompleteView extends StatelessWidget {
  const SubmoduleCompleteView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubmoduleSessionBloc, SubmoduleSessionState>(
      builder: (context, state) {
        return SubmoduleCompleteBody(
          progressValue: state.progressValue,
          correctCount: state.correctCount,
          total: state.games.length,
          onBackToTrail: () {
            context.read<SubmoduleSessionBloc>().add(
              const SubmoduleSessionBackToTrailPressed(),
            );
          },
        );
      },
    );
  }
}
