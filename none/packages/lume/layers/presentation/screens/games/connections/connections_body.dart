import 'package:flutter/material.dart';
import 'package:lume/common/strings/trail_strings.dart';
import 'package:lume/layers/presentation/screens/games/connections/connections_state.dart';
import 'package:lume/layers/presentation/screens/games/shared/game_answer_chrome.dart';
import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/buttons/lume_button.dart';
import 'package:lume_design_system/organisms/game/prompt_card.dart';

class ConnectionsBody extends StatelessWidget {
  const ConnectionsBody({
    super.key,
    required this.state,
    required this.onLeftSelected,
    required this.onRightSelected,
    required this.onSubmit,
    required this.onNext,
  });

  final ConnectionsState state;
  final ValueChanged<String> onLeftSelected;
  final ValueChanged<String> onRightSelected;
  final VoidCallback onSubmit;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final game = state.game;
    if (game == null) return const SizedBox.shrink();

    final allLinked = state.links.length >= game.leftColumn.length;

    return GameAnswerChrome(
      answered: state.answered,
      isCorrect: state.isCorrect,
      onNext: onNext,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacings.m),
          const PromptCard(
            text: trailGameTypeConnections,
            eyebrow: trailGameTypeConnections,
          ),
          const SizedBox(height: AppSpacings.l),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    for (final item in game.leftColumn) ...[
                      _ConnectionChip(
                        label: item.text,
                        visual: _leftVisual(item.id),
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
                      _ConnectionChip(
                        label: item.text,
                        visual: _rightVisual(item.id),
                        onTap: state.answered || state.selectedLeftId == null
                            ? null
                            : () => onRightSelected(item.id),
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
              label: trailGameSubmit,
              isExpanded: true,
              isEnabled: allLinked,
              onPressed: onSubmit,
            ),
          ],
        ],
      ),
    );
  }

  _ChipVisual _leftVisual(String id) {
    if (state.answered) {
      final linkedRight = state.links[id];
      String? expected;
      for (final pair in state.game!.pairs) {
        if (pair.leftId == id) {
          expected = pair.rightId;
          break;
        }
      }
      if (linkedRight != null && linkedRight == expected) {
        return _ChipVisual.positive;
      }
      return _ChipVisual.negative;
    }
    if (state.selectedLeftId == id) return _ChipVisual.selected;
    if (state.links.containsKey(id)) return _ChipVisual.linked;
    return _ChipVisual.idle;
  }

  _ChipVisual _rightVisual(String id) {
    if (state.answered) {
      String? expectedLeft;
      for (final pair in state.game!.pairs) {
        if (pair.rightId == id) {
          expectedLeft = pair.leftId;
          break;
        }
      }
      if (expectedLeft == null) return _ChipVisual.idle;
      if (state.links[expectedLeft] == id) return _ChipVisual.positive;
      if (state.links.values.contains(id)) return _ChipVisual.negative;
      return _ChipVisual.idle;
    }
    if (state.links.values.contains(id)) return _ChipVisual.linked;
    return _ChipVisual.idle;
  }
}

enum _ChipVisual { idle, selected, linked, positive, negative }

class _ConnectionChip extends StatelessWidget {
  const _ConnectionChip({
    required this.label,
    required this.visual,
    required this.onTap,
  });

  final String label;
  final _ChipVisual visual;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final (Color bg, Color border, Color fg) = switch (visual) {
      _ChipVisual.idle => (cs.surfaceContainerLowest, cs.outline, cs.onSurface),
      _ChipVisual.selected => (
        cs.primaryContainer,
        cs.primary,
        cs.onPrimaryContainer,
      ),
      _ChipVisual.linked => (
        cs.secondaryContainer,
        cs.secondary,
        cs.onSecondaryContainer,
      ),
      _ChipVisual.positive => (
        cs.primaryContainer,
        cs.primary,
        cs.onPrimaryContainer,
      ),
      _ChipVisual.negative => (
        cs.errorContainer,
        cs.error,
        cs.onErrorContainer,
      ),
    };

    final radius = BorderRadius.circular(AppRadius.l);

    return Material(
      color: bg,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: border, width: 1.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacings.m,
            vertical: AppSpacings.m,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: typ.body3Medium.copyWith(color: fg),
          ),
        ),
      ),
    );
  }
}
