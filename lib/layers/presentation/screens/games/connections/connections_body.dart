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

  /// Column : gap : column width ratio (5 : 2 : 5).
  static const int _columnFlex = 5;
  static const int _gapFlex = 2;

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
                flex: _columnFlex,
                child: Column(
                  children: [
                    for (final item in game.leftColumn) ...[
                      _DraggableLeftChip(
                        leftId: item.id,
                        dragHex: state.dragHexForLeft(item.id),
                        canDrag: state.canDrag,
                        onDragStarted: () => onLeftSelected(item.id),
                        chip: _ConnectionsBadgeChip(
                          label: item.text,
                          visual: state.leftVisual(item.id),
                          pairNumber: state.pairNumberForLeft(item.id),
                          pairHex: state.pairHexForLeft(item.id),
                          onTap: state.answered
                              ? null
                              : () => onLeftSelected(item.id),
                        ),
                        label: item.text,
                      ),
                      const SizedBox(height: AppSpacings.s),
                    ],
                  ],
                ),
              ),
              // Empty lane between the columns: room to drag a left item onto
              // a right item without covering the other chips.
              const Spacer(flex: _gapFlex),
              Expanded(
                flex: _columnFlex,
                child: Column(
                  children: [
                    for (final item in game.rightColumn) ...[
                      _DropTargetRightChip(
                        canAccept: !state.answered,
                        onDropped: () => onRightSelected(item.id),
                        chip: _ConnectionsBadgeChip(
                          label: item.text,
                          visual: state.rightVisual(item.id),
                          pairNumber: state.pairNumberForRight(item.id),
                          pairHex: state.pairHexForRight(item.id),
                          onTap: state.canSelectRight
                              ? () => onRightSelected(item.id)
                              : null,
                        ),
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

/// Left-column chip that can be dragged onto a right-column chip.
///
/// Starting the drag selects the item (same callback as tapping it), so the
/// bloc already holds the selection and its color when the drop happens.
class _DraggableLeftChip extends StatelessWidget {
  const _DraggableLeftChip({
    required this.leftId,
    required this.label,
    required this.dragHex,
    required this.canDrag,
    required this.onDragStarted,
    required this.chip,
  });

  final String leftId;
  final String label;
  final String dragHex;
  final bool canDrag;
  final VoidCallback onDragStarted;
  final Widget chip;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Draggable<String>(
          data: leftId,
          maxSimultaneousDrags: canDrag ? 1 : 0,
          onDragStarted: onDragStarted,
          feedback: Material(
            type: MaterialType.transparency,
            child: SizedBox(
              width: constraints.maxWidth,
              child: BadgeChip.custom(label: label, hex: dragHex),
            ),
          ),
          childWhenDragging: Opacity(opacity: 0.35, child: chip),
          child: chip,
        );
      },
    );
  }
}

/// Right-column chip that accepts a dragged left item.
class _DropTargetRightChip extends StatelessWidget {
  const _DropTargetRightChip({
    required this.canAccept,
    required this.onDropped,
    required this.chip,
  });

  final bool canAccept;
  final VoidCallback onDropped;
  final Widget chip;

  @override
  Widget build(BuildContext context) {
    return DragTarget<String>(
      onWillAcceptWithDetails: (_) => canAccept,
      onAcceptWithDetails: (_) => onDropped(),
      builder: (context, candidates, rejected) {
        return AnimatedScale(
          scale: candidates.isNotEmpty ? 1.06 : 1,
          duration: const Duration(milliseconds: 120),
          child: chip,
        );
      },
    );
  }
}

class _ConnectionsBadgeChip extends StatelessWidget {
  const _ConnectionsBadgeChip({
    required this.label,
    required this.visual,
    required this.pairNumber,
    required this.pairHex,
    required this.onTap,
  });

  final String label;
  final ConnectionsChipVisual visual;
  final int? pairNumber;

  /// Pair color; when set the chip is painted with it instead of [visual].
  final String? pairHex;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final hex = pairHex;
    if (hex != null) {
      return BadgeChip.custom(
        label: label,
        hex: hex,
        badgeLabel: pairNumber?.toString(),
        onTap: onTap,
      );
    }

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
