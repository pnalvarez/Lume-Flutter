import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lume/core/di/di.dart';
import 'package:lume/layers/presentation/screens/trail/submodule_session/submodule_complete_page.dart';
import 'package:lume/layers/presentation/screens/trail/submodule_session/submodule_preview_page.dart';
import 'package:lume/layers/presentation/screens/trail/submodule_session/submodule_session_bloc.dart';
import 'package:lume/layers/presentation/screens/trail/submodule_session/submodule_session_event.dart';
import 'package:lume/layers/presentation/screens/trail/submodule_session/submodule_session_state.dart';
import 'package:lume_design_system/molecules/loaders/circular_loader.dart';

/// Owns [SubmoduleSessionBloc] and swaps preview / complete.
/// Play runs on [GamesPage] (pushed from preview with rounds + save callback).
@RoutePage()
class SubmoduleSessionPage extends StatelessWidget {
  const SubmoduleSessionPage({
    super.key,
    required this.trailId,
    required this.submoduleId,
  });

  final int trailId;
  final int submoduleId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SubmoduleSessionBloc>()
        ..add(
          SubmoduleSessionStarted(trailId: trailId, submoduleId: submoduleId),
        ),
      child: const _SubmoduleSessionShell(),
    );
  }
}

class _SubmoduleSessionShell extends StatefulWidget {
  const _SubmoduleSessionShell();

  @override
  State<_SubmoduleSessionShell> createState() => _SubmoduleSessionShellState();
}

class _SubmoduleSessionShellState extends State<_SubmoduleSessionShell> {
  bool _allowPop = false;

  void _finishExit() {
    if (!mounted || _allowPop) return;
    setState(() => _allowPop = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (context.router.canPop()) {
        context.router.pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SubmoduleSessionBloc, SubmoduleSessionState>(
      listenWhen: (previous, current) =>
          !previous.goBackToTrail && current.goBackToTrail,
      listener: (context, state) {
        context.read<SubmoduleSessionBloc>().add(
          const SubmoduleSessionNavigationHandled(),
        );
        _finishExit();
      },
      child: PopScope(
        canPop: _allowPop,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) return;
          context.read<SubmoduleSessionBloc>().add(
            const SubmoduleSessionAbandoned(),
          );
        },
        child: BlocBuilder<SubmoduleSessionBloc, SubmoduleSessionState>(
          buildWhen: (previous, current) =>
              previous.stage != current.stage ||
              previous.status != current.status,
          builder: (context, state) {
            if (state.status == SubmoduleSessionStatus.saving) {
              return const Scaffold(
                body: Center(child: CircularLoader()),
              );
            }
            return switch (state.stage) {
              SubmoduleSessionStage.preview => const SubmodulePreviewView(),
              SubmoduleSessionStage.completed => const SubmoduleCompleteView(),
            };
          },
        ),
      ),
    );
  }
}
