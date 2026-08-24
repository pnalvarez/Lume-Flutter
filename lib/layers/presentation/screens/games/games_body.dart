import 'package:flutter/material.dart';
import 'package:lume/common/strings/trail_strings.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';
import 'package:lume/layers/presentation/screens/games/battle_of_curiosities/battle_of_curiosities_body.dart';
import 'package:lume/layers/presentation/screens/games/complete_sentence/complete_sentence_body.dart';
import 'package:lume/layers/presentation/screens/games/connections/connections_body.dart';
import 'package:lume/layers/presentation/screens/games/games_state.dart';
import 'package:lume/layers/presentation/screens/games/lightning_quiz/lightning_quiz_body.dart';
import 'package:lume/layers/presentation/screens/games/mysterious_word/mysterious_word_body.dart';
import 'package:lume/layers/presentation/screens/games/timeline/timeline_body.dart';
import 'package:lume/layers/presentation/screens/games/true_or_myth/true_or_myth_body.dart';
import 'package:lume/layers/presentation/screens/games/who_am_i/who_am_i_body.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/buttons/lume_button.dart';
import 'package:lume_design_system/molecules/buttons/lume_icon_button.dart';
import 'package:lume_design_system/molecules/loaders/circular_loader.dart';
import 'package:lume_design_system/molecules/progress/lume_progress_bar.dart';
import 'package:lume_design_system/organisms/navigation/page_header.dart';

/// Sequence play UI. No Bloc, router, or GetIt — safe for Widgetbook.
class GamesBody extends StatelessWidget {
  const GamesBody({
    super.key,
    required this.state,
    required this.onRetry,
    required this.onChoiceSelected,
    required this.onWhoAmIAnswerChanged,
    required this.onWhoAmIRevealHint,
    required this.onWhoAmISubmit,
    required this.onBlankSelected,
    required this.onCompleteSentenceSubmit,
    required this.onConnectionsLeftSelected,
    required this.onConnectionsRightSelected,
    required this.onConnectionsUndoLast,
    required this.onConnectionsSubmit,
    required this.onMysteriousWordLetterPressed,
    required this.onNext,
    this.useCloseTrailing = false,
    this.onClose,
    this.onAbandoned,
  });

  final GamesState state;
  final VoidCallback onRetry;
  final bool useCloseTrailing;
  final VoidCallback? onClose;
  final VoidCallback? onAbandoned;
  final ValueChanged<String> onChoiceSelected;
  final ValueChanged<String> onWhoAmIAnswerChanged;
  final VoidCallback onWhoAmIRevealHint;
  final VoidCallback onWhoAmISubmit;
  final void Function(int blankOrder, String option) onBlankSelected;
  final VoidCallback onCompleteSentenceSubmit;
  final ValueChanged<String> onConnectionsLeftSelected;
  final ValueChanged<String> onConnectionsRightSelected;
  final VoidCallback onConnectionsUndoLast;
  final VoidCallback onConnectionsSubmit;
  final ValueChanged<String> onMysteriousWordLetterPressed;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isSaving = state.status == GamesStatus.saving;
    final errorMessage = state.status == GamesStatus.error
        ? state.errorMessage
        : null;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: PageHeader(
        onBack: useCloseTrailing ? null : onAbandoned,
        titleWidget: Padding(
          padding: EdgeInsets.only(
            right: useCloseTrailing ? AppSpacings.xs : AppSpacings.s,
          ),
          child: LumeProgressBar(
            value: state.progressValue.clamp(0.0, 1.0),
            height: 8,
            showPercentage: false,
            fillColor: cs.primary,
          ),
        ),
        trailing: useCloseTrailing && onClose != null
            ? LumeIconButton(
                icon: Icons.close_rounded,
                onPressed: onClose,
                size: LumeIconButtonSize.sm,
              )
            : null,
      ),
      body: switch ((isSaving, errorMessage)) {
        (true, _) => const Center(child: CircularLoader()),
        (_, final String message) => Padding(
          padding: const EdgeInsets.all(AppSpacings.xl2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                message,
                textAlign: TextAlign.center,
                style: typ.body3Light.copyWith(color: cs.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacings.l),
              LumeButton(
                label: trailSessionRetry,
                type: LumeButtonType.outlined,
                onPressed: onRetry,
              ),
            ],
          ),
        ),
        _ => Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacings.l),
          child: KeyedSubtree(
            key: ValueKey(
              '${state.currentIndex}-${state.currentRound?.id ?? ''}',
            ),
            child: _buildRound(context),
          ),
        ),
      },
    );
  }

  Widget _buildRound(BuildContext context) {
    final game = state.currentGame;
    if (game == null) return const SizedBox.shrink();

    return switch (game) {
      LightningQuizGameDomain() => LightningQuizBody(
        state: state.lightningQuizView!,
        onOptionSelected: onChoiceSelected,
        onNext: onNext,
      ),
      TimelineGameDomain() => TimelineBody(
        state: state.timelineView!,
        onOptionSelected: onChoiceSelected,
        onNext: onNext,
      ),
      TrueOrMythGameDomain() => TrueOrMythBody(
        state: state.trueOrMythView!,
        onOptionSelected: onChoiceSelected,
        onNext: onNext,
      ),
      BattleOfCuriositiesGameDomain() => BattleOfCuriositiesBody(
        state: state.battleView!,
        onOptionSelected: onChoiceSelected,
        onNext: onNext,
      ),
      WhoAmIGameDomain() => WhoAmIBody(
        state: state.whoAmIView!,
        onAnswerChanged: onWhoAmIAnswerChanged,
        onRevealHint: onWhoAmIRevealHint,
        onSubmit: onWhoAmISubmit,
        onNext: onNext,
      ),
      CompleteSentenceGameDomain() => CompleteSentenceBody(
        state: state.completeSentenceView!,
        onBlankSelected: onBlankSelected,
        onSubmit: onCompleteSentenceSubmit,
        onNext: onNext,
      ),
      MysteriousWordGameDomain() => MysteriousWordBody(
        state: state.mysteriousWordView!,
        onLetterPressed: onMysteriousWordLetterPressed,
        onNext: onNext,
      ),
      ConnectionsGameDomain() => ConnectionsBody(
        state: state.connectionsView!,
        onLeftSelected: onConnectionsLeftSelected,
        onRightSelected: onConnectionsRightSelected,
        onUndoLast: onConnectionsUndoLast,
        onSubmit: onConnectionsSubmit,
        onNext: onNext,
      ),
    };
  }
}
