import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lume/core/di/di.dart';
import 'package:lume/layers/presentation/screens/trail/submodule_session/submodule_complete_page.dart';
import 'package:lume/layers/presentation/screens/trail/submodule_session/submodule_play_page.dart';
import 'package:lume/layers/presentation/screens/trail/submodule_session/submodule_preview_page.dart';
import 'package:lume/layers/presentation/screens/trail/submodule_session/submodule_session_bloc.dart';
import 'package:lume/layers/presentation/screens/trail/submodule_session/submodule_session_event.dart';
import 'package:lume/layers/presentation/screens/trail/submodule_session/submodule_session_state.dart';

/// Owns [SubmoduleSessionBloc] and swaps preview / play / complete views.
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
  /// When true, [PopScope] allows the route to leave without re-entering
  /// [onPopInvokedWithResult] (avoids abandon → maybePop → abandon loops).
  bool _allowPop = false;

  void _requestExit() {
    if (_allowPop) return;
    context.read<SubmoduleSessionBloc>().add(const SubmoduleSessionAbandoned());
  }

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
          _requestExit();
        },
        child: BlocBuilder<SubmoduleSessionBloc, SubmoduleSessionState>(
          buildWhen: (previous, current) => previous.stage != current.stage,
          builder: (context, state) {
            return switch (state.stage) {
              SubmoduleSessionStage.preview => const SubmodulePreviewView(),
              SubmoduleSessionStage.playing => const SubmodulePlayView(),
              SubmoduleSessionStage.completed => const SubmoduleCompleteView(),
            };
          },
        ),
      ),
    );
  }
}
