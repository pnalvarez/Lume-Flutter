import 'package:lume_design_system/organisms/game/choice_group.dart';

/// Shared mapping from selection + correctness → [ChoiceVisualState].
ChoiceVisualState choiceOptionVisualState({
  required bool answered,
  required String? selectedOptionId,
  required String optionId,
  required String correctOptionId,
}) {
  if (!answered) {
    return selectedOptionId == optionId
        ? ChoiceVisualState.selected
        : ChoiceVisualState.idle;
  }
  if (optionId == correctOptionId) return ChoiceVisualState.positive;
  if (selectedOptionId == optionId) return ChoiceVisualState.negative;
  return ChoiceVisualState.disabled;
}
