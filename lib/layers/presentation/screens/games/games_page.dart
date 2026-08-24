import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lume/core/di/di.dart';
import 'package:lume/layers/presentation/screens/games/game_round.dart';
import 'package:lume/layers/presentation/screens/games/games_bloc.dart';
import 'package:lume/layers/presentation/screens/games/games_body.dart';
import 'package:lume/layers/presentation/screens/games/games_event.dart';
import 'package:lume/layers/presentation/screens/games/games_leave_confirm.dart';
import 'package:lume/layers/presentation/screens/games/games_state.dart';

enum GamesPlayMode { trail, hub }

/// Decoupled game-sequence screen. Callers pass [rounds] and [onSaveRound].
@RoutePage()
class GamesPage extends StatelessWidget {
  const GamesPage({
    super.key,
    required this.rounds,
    required this.onSaveRound,
    this.mode = GamesPlayMode.trail,
  });

  final List<GameRound> rounds;
  final GamesRoundSave onSaveRound;
  final GamesPlayMode mode;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<GamesBloc>()
        ..add(GamesStarted(rounds: rounds, onSaveRound: onSaveRound)),
      child: _GamesView(mode: mode),
    );
  }
}

class _GamesView extends StatefulWidget {
  const _GamesView({required this.mode});

  final GamesPlayMode mode;

  @override
  State<_GamesView> createState() => _GamesViewState();
}

class _GamesViewState extends State<_GamesView> {
  bool _allowPop = false;
  bool _leaveConfirmVisible = false;

  bool get _isHub => widget.mode == GamesPlayMode.hub;

  Future<void> _requestExit() async {
    if (_allowPop || _leaveConfirmVisible) return;

    _leaveConfirmVisible = true;
    final leave = await confirmLeaveGamesSequence(context);
    _leaveConfirmVisible = false;
    if (!leave || !mounted) return;

    context.read<GamesBloc>().add(const GamesAbandoned());
  }

  void _finishExit({GamesSequenceResult? result}) {
    if (!mounted || _allowPop) return;
    setState(() => _allowPop = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (context.router.canPop()) {
        context.router.pop(result);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<GamesBloc, GamesState>(
          listenWhen: (previous, current) =>
              !previous.sequenceCompleted && current.sequenceCompleted,
          listener: (context, state) {
            context.read<GamesBloc>().add(const GamesNavigationHandled());
            _finishExit(
              result: GamesSequenceResult(
                correctCount: state.correctCount,
                total: state.rounds.length,
              ),
            );
          },
        ),
        BlocListener<GamesBloc, GamesState>(
          listenWhen: (previous, current) =>
              !previous.goBack && current.goBack,
          listener: (context, state) {
            context.read<GamesBloc>().add(const GamesNavigationHandled());
            _finishExit();
          },
        ),
      ],
      child: PopScope(
        canPop: _allowPop,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) return;
          _requestExit();
        },
        child: BlocBuilder<GamesBloc, GamesState>(
          builder: (context, state) {
            return GamesBody(
              state: state,
              useCloseTrailing: _isHub,
              onClose: _requestExit,
              onAbandoned: _isHub ? null : _requestExit,
              onRetry: () {
                context.read<GamesBloc>().add(const GamesRetrySave());
              },
              onChoiceSelected: (optionId) {
                context.read<GamesBloc>().add(GamesChoiceSelected(optionId));
              },
              onWhoAmIAnswerChanged: (answer) {
                context.read<GamesBloc>().add(
                  GamesWhoAmIAnswerChanged(answer),
                );
              },
              onWhoAmIRevealHint: () {
                context.read<GamesBloc>().add(const GamesWhoAmIRevealHint());
              },
              onWhoAmISubmit: () {
                context.read<GamesBloc>().add(const GamesWhoAmISubmit());
              },
              onBlankSelected: (blankOrder, option) {
                context.read<GamesBloc>().add(
                  GamesCompleteSentenceBlankSelected(
                    blankOrder: blankOrder,
                    option: option,
                  ),
                );
              },
              onCompleteSentenceSubmit: () {
                context.read<GamesBloc>().add(
                  const GamesCompleteSentenceSubmit(),
                );
              },
              onConnectionsLeftSelected: (leftId) {
                context.read<GamesBloc>().add(
                  GamesConnectionsLeftSelected(leftId),
                );
              },
              onConnectionsRightSelected: (rightId) {
                context.read<GamesBloc>().add(
                  GamesConnectionsRightSelected(rightId),
                );
              },
              onConnectionsUndoLast: () {
                context.read<GamesBloc>().add(
                  const GamesConnectionsUndoLast(),
                );
              },
              onConnectionsSubmit: () {
                context.read<GamesBloc>().add(const GamesConnectionsSubmit());
              },
              onMysteriousWordLetterPressed: (letter) {
                context.read<GamesBloc>().add(
                  GamesMysteriousWordLetterPressed(letter),
                );
              },
              onNext: () {
                context.read<GamesBloc>().add(const GamesNextPressed());
              },
            );
          },
        ),
      ),
    );
  }
}
