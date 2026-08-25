import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lume/common/strings/games_hub_strings.dart';
import 'package:lume/core/di/di.dart';
import 'package:lume/layers/presentation/screens/games/arcade_complete_body.dart';
import 'package:lume/layers/presentation/screens/games/game_round.dart';
import 'package:lume/layers/presentation/screens/games/games_bloc.dart';
import 'package:lume/layers/presentation/screens/games/games_body.dart';
import 'package:lume/layers/presentation/screens/games/games_complete_body.dart';
import 'package:lume/layers/presentation/screens/games/games_event.dart';
import 'package:lume/layers/presentation/screens/games/games_leave_confirm.dart';
import 'package:lume/layers/presentation/screens/games/games_state.dart';
import 'package:lume/layers/presentation/shared/xp_snack_bar.dart';

export 'package:lume/layers/presentation/screens/games/games_event.dart'
    show GamesPlayMode;

/// Decoupled game-sequence screen.
///
/// Trail callers pass [onSaveRound] to buffer scores in the parent session.
/// Hub mode persists via [GamesBloc] on next/retry events.
/// Arcade mode is an endless run: [GamesBloc] appends a new random round after
/// every hit and ends the run on the first miss.
@RoutePage()
class GamesPage extends StatelessWidget {
  const GamesPage({
    super.key,
    required this.rounds,
    this.onSaveRound,
    this.mode = GamesPlayMode.trail,
    this.arcadeRecord = 0,
  });

  final List<GameRound> rounds;
  final GamesRoundSave? onSaveRound;
  final GamesPlayMode mode;

  /// Arcade mode: personal best fetched by the hub before starting.
  final int arcadeRecord;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<GamesBloc>()
        ..add(
          GamesStarted(
            rounds: rounds,
            mode: mode,
            onSaveRound: onSaveRound,
            arcadeRecord: arcadeRecord,
          ),
        ),
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
  GamesSequenceResult? _hubCompleteResult;
  bool _arcadeCompleteVisible = false;

  bool get _isHub => widget.mode == GamesPlayMode.hub;

  bool get _isArcade => widget.mode == GamesPlayMode.arcade;

  bool get _completeVisible =>
      _hubCompleteResult != null || _arcadeCompleteVisible;

  Future<void> _requestExit() async {
    if (_allowPop || _leaveConfirmVisible) return;

    // The run is already over; leaving needs no confirmation.
    if (_completeVisible) {
      _finishExit(result: _hubCompleteResult);
      return;
    }

    _leaveConfirmVisible = true;
    final leave = _isArcade
        ? await confirmLeaveArcadeRun(context)
        : await confirmLeaveGamesSequence(context);
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
            if (_isArcade) {
              setState(() => _arcadeCompleteVisible = true);
              return;
            }
            final result = GamesSequenceResult(
              correctCount: state.correctCount,
              total: state.rounds.length,
            );
            if (_isHub) {
              setState(() => _hubCompleteResult = result);
              return;
            }
            _finishExit(result: result);
          },
        ),
        BlocListener<GamesBloc, GamesState>(
          listenWhen: (previous, current) =>
              current.xpAwardedToShow != null &&
              current.xpAwardedToShow != previous.xpAwardedToShow,
          listener: (context, state) {
            final xp = state.xpAwardedToShow;
            if (xp == null) return;
            showXpAwardedSnackBar(
              context,
              xp,
              position: _isArcade
                  ? LumeSnackBarPosition.bottom
                  : LumeSnackBarPosition.top,
            );
            context.read<GamesBloc>().add(const GamesXpSnackBarShown());
          },
        ),
        BlocListener<GamesBloc, GamesState>(
          listenWhen: (previous, current) => !previous.goBack && current.goBack,
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
            final complete = _hubCompleteResult;

            return Stack(
              fit: StackFit.expand,
              children: [
                GamesBody(
                  state: state,
                  hideProgress: _isArcade,
                  useCloseLeading: _isArcade && !_completeVisible,
                  showLives: _isArcade && !_completeVisible,
                  useCloseTrailing: _isHub && !_completeVisible,
                  onClose: _requestExit,
                  onAbandoned: _isHub ? null : _requestExit,
                  onRetry: () {
                    context.read<GamesBloc>().add(const GamesRetrySave());
                  },
                  onChoiceSelected: (optionId) {
                    context.read<GamesBloc>().add(
                      GamesChoiceSelected(optionId),
                    );
                  },
                  onWhoAmIAnswerChanged: (answer) {
                    context.read<GamesBloc>().add(
                      GamesWhoAmIAnswerChanged(answer),
                    );
                  },
                  onWhoAmIRevealHint: () {
                    context.read<GamesBloc>().add(
                      const GamesWhoAmIRevealHint(),
                    );
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
                    context.read<GamesBloc>().add(
                      const GamesConnectionsSubmit(),
                    );
                  },
                  onMysteriousWordLetterPressed: (letter) {
                    context.read<GamesBloc>().add(
                      GamesMysteriousWordLetterPressed(letter),
                    );
                  },
                  onNext: () {
                    context.read<GamesBloc>().add(const GamesNextPressed());
                  },
                ),
                if (_arcadeCompleteVisible)
                  ArcadeCompleteBody(
                    scoredCount: state.arcade.scoredCount,
                    record: state.arcade.record,
                    isNewRecord: state.arcade.isNewRecord,
                    xpEarned: state.arcade.xpEarned,
                    onAction: _finishExit,
                  )
                else if (complete != null)
                  GamesCompleteBody(
                    title: gamesHubRoundCompleteTitle,
                    scoreText: gamesHubRoundCompleteScore(
                      correctCount: complete.correctCount,
                      total: complete.total,
                    ),
                    actionLabel: gamesHubRoundCompleteAction,
                    onAction: () => _finishExit(result: complete),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
