import 'package:flutter/material.dart';
import 'package:lume/common/strings/trail_strings.dart';
import 'package:lume/layers/presentation/screens/games/mysterious_word/mysterious_word_state.dart';
import 'package:lume/layers/presentation/screens/games/shared/game_answer_chrome.dart';
import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/progress/lume_lives_row.dart';
import 'package:lume_design_system/organisms/game/prompt_card.dart';
import 'package:lume_design_system/organisms/list_item/list_item.dart';

class MysteriousWordBody extends StatelessWidget {
  const MysteriousWordBody({
    super.key,
    required this.state,
    required this.onLetterPressed,
    required this.onNext,
  });

  final MysteriousWordState state;
  final ValueChanged<String> onLetterPressed;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final game = state.game;
    if (game == null) return const SizedBox.shrink();

    final cs = Theme.of(context).colorScheme;
    final hint = game.hint.trim();

    return GameAnswerChrome(
      answered: state.answered,
      isCorrect: state.isCorrect,
      explanation: game.explanation,
      onNext: onNext,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacings.m),
          PromptCard(
            text: game.description,
            eyebrow: trailGameTypeMysteriousWord,
          ),
          if (hint.isNotEmpty) ...[
            const SizedBox(height: AppSpacings.m),
            ListItem(
              trait: ListItemTrait.neutral,
              isExpanded: true,
              input: TextInput(label: '$trailGameHint: ', text: hint),
            ),
          ],
          const SizedBox(height: AppSpacings.l),
          Text(
            state.maskedWord,
            textAlign: TextAlign.center,
            style: typ.body1Semibold.copyWith(
              color: cs.onSurface,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: AppSpacings.m),
          LumeLivesRow(
            total: MysteriousWordState.maxWrong,
            remaining: state.livesLeft,
          ),
          const SizedBox(height: AppSpacings.l),
          Wrap(
            spacing: AppSpacings.s,
            runSpacing: AppSpacings.s,
            alignment: WrapAlignment.center,
            children: [
              for (final letter in MysteriousWordState.alphabet.split(''))
                _LetterChip(
                  letter: letter,
                  visual: state.letterVisual(letter),
                  enabled: state.lettersEnabled,
                  onPressed: () => onLetterPressed(letter),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LetterChip extends StatelessWidget {
  const _LetterChip({
    required this.letter,
    required this.visual,
    required this.enabled,
    required this.onPressed,
  });

  final String letter;
  final MysteriousLetterVisual visual;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final (Color bg, Color fg, Color border) = switch (visual) {
      MysteriousLetterVisual.idle => (
        cs.surfaceContainerLowest,
        cs.onSurface,
        cs.outline,
      ),
      MysteriousLetterVisual.correct => (
        cs.primaryContainer,
        cs.onPrimaryContainer,
        cs.primary,
      ),
      MysteriousLetterVisual.missed => (
        cs.surfaceContainerLow,
        cs.onSurface.withValues(alpha: 0.38),
        cs.outline.withValues(alpha: 0.5),
      ),
    };

    final radius = BorderRadius.circular(AppRadius.m);
    final guessed = visual != MysteriousLetterVisual.idle;

    return Material(
      color: bg,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: enabled && !guessed ? onPressed : null,
        borderRadius: radius,
        child: SizedBox(
          width: 36,
          height: 36,
          child: Center(
            child: Text(letter, style: typ.body3Semibold.copyWith(color: fg)),
          ),
        ),
      ),
    );
  }
}
