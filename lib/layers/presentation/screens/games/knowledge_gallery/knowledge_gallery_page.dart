import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lume/common/strings/games_hub_strings.dart';
import 'package:lume/core/di/di.dart';
import 'package:lume/layers/domain/models/game/knowledge_gallery_round.dart';
import 'package:lume/layers/presentation/screens/games/games_complete_body.dart';
import 'package:lume/layers/presentation/screens/games/games_leave_confirm.dart';
import 'package:lume/layers/presentation/screens/games/knowledge_gallery/knowledge_gallery_bloc.dart';
import 'package:lume/layers/presentation/screens/games/knowledge_gallery/knowledge_gallery_body.dart';
import 'package:lume/layers/presentation/screens/games/knowledge_gallery/knowledge_gallery_event.dart';
import 'package:lume/layers/presentation/screens/games/knowledge_gallery/knowledge_gallery_play_state.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/molecules/progress/lume_progress_bar.dart';
import 'package:lume_design_system/organisms/navigation/page_header.dart';

@RoutePage()
class KnowledgeGalleryPage extends StatelessWidget {
  const KnowledgeGalleryPage({
    super.key,
    required this.rounds,
    required this.matchId,
  });

  final List<KnowledgeGalleryRound> rounds;
  final String matchId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<KnowledgeGalleryBloc>()
            ..add(KnowledgeGalleryStarted(rounds: rounds, matchId: matchId)),
      child: const _KnowledgeGalleryView(),
    );
  }
}

class _KnowledgeGalleryView extends StatefulWidget {
  const _KnowledgeGalleryView();

  @override
  State<_KnowledgeGalleryView> createState() => _KnowledgeGalleryViewState();
}

class _KnowledgeGalleryViewState extends State<_KnowledgeGalleryView> {
  var _allowPop = false;
  var _confirming = false;

  Future<void> _requestExit() async {
    if (_allowPop || _confirming) return;
    final completed = context
        .read<KnowledgeGalleryBloc>()
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
    context.read<KnowledgeGalleryBloc>().add(const KnowledgeGalleryAbandoned());
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
        BlocListener<KnowledgeGalleryBloc, KnowledgeGalleryPlayState>(
          listenWhen: (previous, current) => !previous.goBack && current.goBack,
          listener: (context, state) {
            context.read<KnowledgeGalleryBloc>().add(
              const KnowledgeGalleryNavigationHandled(),
            );
            _finishExit();
          },
        ),
        BlocListener<KnowledgeGalleryBloc, KnowledgeGalleryPlayState>(
          listenWhen: (previous, current) =>
              current.snackMessage != null &&
              current.snackMessage != previous.snackMessage,
          listener: (context, state) {
            final message = state.snackMessage;
            if (message == null) return;
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(message)));
            context.read<KnowledgeGalleryBloc>().add(
              const KnowledgeGallerySnackShown(),
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
        child: BlocBuilder<KnowledgeGalleryBloc, KnowledgeGalleryPlayState>(
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
                            child: KnowledgeGalleryBody(
                              state: view,
                              onOptionSelected: (optionId) {
                                context.read<KnowledgeGalleryBloc>().add(
                                  KnowledgeGalleryOptionSelected(optionId),
                                );
                              },
                              onNext: () {
                                context.read<KnowledgeGalleryBloc>().add(
                                  const KnowledgeGalleryNextPressed(),
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
