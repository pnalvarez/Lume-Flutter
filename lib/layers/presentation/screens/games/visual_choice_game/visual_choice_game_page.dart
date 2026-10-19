import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lume/common/strings/games_hub_strings.dart';
import 'package:lume/core/di/di.dart';
import 'package:lume/layers/domain/models/game/visual_choice_game_config.dart';
import 'package:lume/layers/domain/models/game/visual_choice_game_round.dart';
import 'package:lume/layers/presentation/screens/games/games_complete_body.dart';
import 'package:lume/layers/presentation/screens/games/games_leave_confirm.dart';
import 'package:lume/layers/presentation/screens/games/visual_choice_game/visual_choice_game_bloc.dart';
import 'package:lume/layers/presentation/screens/games/visual_choice_game/visual_choice_game_body.dart';
import 'package:lume/layers/presentation/screens/games/visual_choice_game/visual_choice_game_event.dart';
import 'package:lume/layers/presentation/screens/games/visual_choice_game/visual_choice_game_play_state.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/molecules/progress/lume_progress_bar.dart';
import 'package:lume_design_system/organisms/navigation/page_header.dart';

@RoutePage()
class VisualChoiceGamePage extends StatelessWidget {
  const VisualChoiceGamePage({
    super.key,
    required this.rounds,
    required this.matchId,
    required this.config,
  });

  final List<VisualChoiceGameRound> rounds;
  final String matchId;

  /// Visual game being played (slug + analytics event names).
  final VisualChoiceGameConfig config;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<VisualChoiceGameBloc>()
        ..add(
          VisualChoiceGameStarted(
            rounds: rounds,
            matchId: matchId,
            config: config,
          ),
        ),
      child: const _VisualChoiceGameView(),
    );
  }
}

class _VisualChoiceGameView extends StatefulWidget {
  const _VisualChoiceGameView();

  @override
  State<_VisualChoiceGameView> createState() => _VisualChoiceGameViewState();
}

class _VisualChoiceGameViewState extends State<_VisualChoiceGameView> {
  var _allowPop = false;
  var _confirming = false;

  Future<void> _requestExit() async {
    if (_allowPop || _confirming) return;
    final completed = context
        .read<VisualChoiceGameBloc>()
        .state
        .sequenceCompleted;
    if (completed) {
      _finishExit();
      return;
    }
    _confirming = true;
    final leave = await confirmLeaveGamesSequence(context);
    _confirming = false;
    if (!leave || !mounted) return;
    context.read<VisualChoiceGameBloc>().add(const VisualChoiceGameAbandoned());
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
    final cs = Theme.of(context).colorScheme;

    return MultiBlocListener(
      listeners: [
        BlocListener<VisualChoiceGameBloc, VisualChoiceGamePlayState>(
          listenWhen: (previous, current) => !previous.goBack && current.goBack,
          listener: (context, state) {
            context.read<VisualChoiceGameBloc>().add(
              const VisualChoiceGameNavigationHandled(),
            );
            _finishExit();
          },
        ),
        BlocListener<VisualChoiceGameBloc, VisualChoiceGamePlayState>(
          listenWhen: (previous, current) =>
              current.snackMessage != null &&
              current.snackMessage != previous.snackMessage,
          listener: (context, state) {
            final message = state.snackMessage;
            if (message == null) return;
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(message)));
            context.read<VisualChoiceGameBloc>().add(
              const VisualChoiceGameSnackShown(),
            );
          },
        ),
      ],
      child: PopScope(
        canPop: _allowPop,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) return;
          _requestExit();
        },
        child: BlocBuilder<VisualChoiceGameBloc, VisualChoiceGamePlayState>(
          builder: (context, state) {
            final view = state.view;
            return Stack(
              fit: StackFit.expand,
              children: [
                Scaffold(
                  backgroundColor: cs.surface,
                  appBar: PageHeader(
                    onBack: _requestExit,
                    titleWidget: Padding(
                      padding: const EdgeInsets.only(right: AppSpacings.s),
                      child: LumeProgressBar(
                        value: state.progress.clamp(0.0, 1.0),
                        height: 8,
                        showPercentage: false,
                        fillColor: cs.primary,
                      ),
                    ),
                  ),
                  body: view == null
                      ? const SizedBox.shrink()
                      : SafeArea(
                          top: false,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacings.l,
                            ),
                            child: VisualChoiceGameBody(
                              state: view,
                              onOptionSelected: (optionId) {
                                context.read<VisualChoiceGameBloc>().add(
                                  VisualChoiceGameOptionSelected(optionId),
                                );
                              },
                              onNext: () {
                                context.read<VisualChoiceGameBloc>().add(
                                  const VisualChoiceGameNextPressed(),
                                );
                              },
                              onImageFailed: () {
                                context.read<VisualChoiceGameBloc>().add(
                                  const VisualChoiceGameImageFailed(),
                                );
                              },
                            ),
                          ),
                        ),
                ),
                if (state.sequenceCompleted)
                  GamesCompleteBody(
                    title: gamesHubRoundCompleteTitle,
                    scoreText: gamesHubRoundCompleteScore(
                      correctCount: state.correctCount,
                      total: state.rounds.length,
                    ),
                    actionLabel: gamesHubRoundCompleteAction,
                    onAction: _finishExit,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
