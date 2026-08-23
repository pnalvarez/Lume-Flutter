import 'package:flutter/material.dart';
import 'package:lume/common/strings/trail_strings.dart';
import 'package:lume/layers/presentation/screens/games/connections/connections_state.dart';
import 'package:lume/layers/presentation/screens/games/shared/game_answer_chrome.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/molecules/buttons/lume_button.dart';
import 'package:lume_design_system/molecules/chips/badge_chip.dart';
import 'package:lume_design_system/organisms/game/prompt_card.dart';

class ConnectionsBody extends StatelessWidget {
  const ConnectionsBody({
    super.key,
    required this.state,
    required this.onLeftSelected,
    required this.onRightSelected,
    required this.onUndoLast,
    required this.onSubmit,
    required this.onNext,
  });

  final ConnectionsState state;
  final ValueChanged<String> onLeftSelected;
  final ValueChanged<String> onRightSelected;
  final VoidCallback onUndoLast;
  final VoidCallback onSubmit;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final game = state.game;
    if (game == null) return const SizedBox.shrink();

    return GameAnswerChrome(
      answered: state.answered,
      isCorrect: state.isCorrect,
      onNext: onNext,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacings.m),
          PromptCard(
            eyebrow: game.title.isNotEmpty
                ? game.title
                : trailGameTypeConnections,
            text: game.subtitle.isNotEmpty
                ? game.subtitle
                : trailGameTypeConnections,
          ),
          const SizedBox(height: AppSpacings.l),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    for (final item in game.leftColumn) ...[
                      _ConnectionsBadgeChip(
                        label: item.text,
                        visual: state.leftVisual(item.id),
                        pairNumber: state.pairNumberForLeft(item.id),
                        onTap: state.answered
                            ? null
                            : () => onLeftSelected(item.id),
                      ),
                      const SizedBox(height: AppSpacings.s),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacings.m),
              Expanded(
                child: Column(
                  children: [
                    for (final item in game.rightColumn) ...[
                      _ConnectionsBadgeChip(
                        label: item.text,
                        visual: state.rightVisual(item.id),
                        pairNumber: state.pairNumberForRight(item.id),
                        onTap: state.canSelectRight
                            ? () => onRightSelected(item.id)
                            : null,
                      ),
                      const SizedBox(height: AppSpacings.s),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (!state.answered) ...[
            const SizedBox(height: AppSpacings.m),
            LumeButton(
              label: trailGameUndoLastPair,
              type: LumeButtonType.outlined,
              trait: LumeButtonTrait.secondary,
              isExpanded: true,
              isEnabled: state.canUndoLast,
              onPressed: onUndoLast,
            ),
            const SizedBox(height: AppSpacings.s),
            LumeButton(
              label: trailGameSubmit,
              isExpanded: true,
              isEnabled: state.allLinked,
              onPressed: onSubmit,
            ),
          ],
        ],
      ),
    );
  }
}

class _ConnectionsBadgeChip extends StatelessWidget {
  const _ConnectionsBadgeChip({
    required this.label,
    required this.visual,
    required this.pairNumber,
    required this.onTap,
  });

  final String label;
  final ConnectionsChipVisual visual;
  final int? pairNumber;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final (Color bg, Color border, Color fg) = switch (visual) {
      ConnectionsChipVisual.idle => (
        cs.surfaceContainerLowest,
        cs.outline,
        cs.onSurface,
      ),
      ConnectionsChipVisual.selected => (
        cs.primaryContainer,
        cs.primary,
        cs.onPrimaryContainer,
      ),
      ConnectionsChipVisual.linked => (
        cs.secondaryContainer,
        cs.secondary,
        cs.onSecondaryContainer,
      ),
      ConnectionsChipVisual.positive => (
        cs.primaryContainer,
        cs.primary,
        cs.onPrimaryContainer,
      ),
      ConnectionsChipVisual.negative => (
        cs.errorContainer,
        cs.error,
        cs.onErrorContainer,
      ),
    };

    return BadgeChip(
      label: label,
      backgroundColor: bg,
      borderColor: border,
      foregroundColor: fg,
      badgeLabel: pairNumber?.toString(),
      badgeBackgroundColor: cs.secondary,
      badgeForegroundColor: cs.onSecondary,
      onTap: onTap,
    );
  }
}
