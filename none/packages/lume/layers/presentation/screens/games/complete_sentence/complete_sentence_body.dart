import 'package:flutter/material.dart';
import 'package:lume/common/strings/trail_strings.dart';
import 'package:lume/layers/presentation/screens/games/complete_sentence/complete_sentence_state.dart';
import 'package:lume/layers/presentation/screens/games/shared/game_answer_chrome.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/buttons/lume_button.dart';
import 'package:lume_design_system/organisms/game/choice_group.dart';
import 'package:lume_design_system/organisms/game/prompt_card.dart';

class CompleteSentenceBody extends StatelessWidget {
  const CompleteSentenceBody({
    super.key,
    required this.state,
    required this.onBlankSelected,
    required this.onSubmit,
    required this.onNext,
  });

  final CompleteSentenceState state;
  final void Function(int blankOrder, String option) onBlankSelected;
  final VoidCallback onSubmit;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final game = state.game;
    if (game == null) return const SizedBox.shrink();

    final cs = Theme.of(context).colorScheme;
    final blanks = [...game.blanks]..sort((a, b) => a.order.compareTo(b.order));
    final allSelected = blanks.every(
      (blank) => state.selections.containsKey(blank.order),
    );

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
            text: game.sentence,
            eyebrow: trailGameTypeCompleteSentence,
          ),
          const SizedBox(height: AppSpacings.l),
          for (final blank in blanks) ...[
            Text(
              '$trailGameHint ${blank.order}',
              style: typ.tagS.copyWith(color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacings.s),
            ChoiceGroup(
              options: [
                for (final option in blank.options)
                  ChoiceOption(
                    id: option,
                    label: option,
                    state: _blankOptionState(blank.order, option, blank.correct),
                  ),
              ],
              onSelected: state.answered
                  ? null
                  : (id) => onBlankSelected(blank.order, id),
            ),
            const SizedBox(height: AppSpacings.l),
          ],
          if (!state.answered)
            LumeButton(
              label: trailGameSubmit,
              isExpanded: true,
              isEnabled: allSelected,
              onPressed: onSubmit,
            ),
        ],
      ),
    );
  }

  ChoiceVisualState _blankOptionState(
    int blankOrder,
    String option,
    String correct,
  ) {
    final selected = state.selections[blankOrder];
    if (!state.answered) {
      return selected == option
          ? ChoiceVisualState.selected
          : ChoiceVisualState.idle;
    }
    if (option == correct) return ChoiceVisualState.positive;
    if (selected == option) return ChoiceVisualState.negative;
    return ChoiceVisualState.disabled;
  }
}
