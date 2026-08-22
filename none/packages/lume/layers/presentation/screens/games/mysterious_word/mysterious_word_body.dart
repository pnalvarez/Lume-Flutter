import 'package:flutter/material.dart';
import 'package:lume/common/strings/trail_strings.dart';
import 'package:lume/layers/presentation/screens/games/mysterious_word/mysterious_word_state.dart';
import 'package:lume/layers/presentation/screens/games/shared/game_answer_chrome.dart';
import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/organisms/game/prompt_card.dart';

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

  static const _alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  @override
  Widget build(BuildContext context) {
    final game = state.game;
    if (game == null) return const SizedBox.shrink();

    final cs = Theme.of(context).colorScheme;

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
          const SizedBox(height: AppSpacings.m),
          Text(
            '$trailGameHint: ${game.hint}',
            style: typ.body3Light.copyWith(color: cs.onSurfaceVariant),
          ),
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
          Text(
            '${state.livesLeft} $trailGameLivesLeft',
            textAlign: TextAlign.center,
            style: typ.tagS.copyWith(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacings.l),
          Wrap(
            spacing: AppSpacings.s,
            runSpacing: AppSpacings.s,
            alignment: WrapAlignment.center,
            children: [
              for (final letter in _alphabet.split(''))
                _LetterChip(
                  letter: letter,
                  guessed: state.guessedLetters.contains(letter),
                  inWord: state.normalizedWord.contains(letter),
                  enabled: !state.answered,
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
    required this.guessed,
    required this.inWord,
    required this.enabled,
    required this.onPressed,
  });

  final String letter;
  final bool guessed;
  final bool inWord;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final Color bg;
    final Color fg;
    final Color border;

    if (!guessed) {
      bg = cs.surfaceContainerLowest;
      fg = cs.onSurface;
      border = cs.outline;
    } else if (inWord) {
      bg = cs.primaryContainer;
      fg = cs.onPrimaryContainer;
      border = cs.primary;
    } else {
      bg = cs.surfaceContainerLow;
      fg = cs.onSurface.withValues(alpha: 0.38);
      border = cs.outline.withValues(alpha: 0.5);
    }

    final radius = BorderRadius.circular(AppRadius.m);

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
            child: Text(
              letter,
              style: typ.body3Semibold.copyWith(color: fg),
            ),
          ),
        ),
      ),
    );
  }
}
