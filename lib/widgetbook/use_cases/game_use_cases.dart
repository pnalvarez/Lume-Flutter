import 'package:flutter/material.dart';
import 'package:lume_design_system/organisms/game/choice_group.dart';
import 'package:lume_design_system/organisms/game/prompt_card.dart';
import 'package:lume_design_system/organisms/game/session_timer.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: PromptCard)
Widget promptCardDefault(BuildContext context) {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: PromptCard(
        eyebrow: context.knobs.string(label: 'Eyebrow', initialValue: 'Prompt'),
        text: context.knobs.string(
          label: 'Text',
          initialValue: 'Which statement is true?',
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'States', type: ChoiceGroup)
Widget choiceGroupStates(BuildContext context) {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: ChoiceGroup(
        onSelected: (_) {},
        options: const [
          ChoiceOption(
            id: '1',
            label: 'Idle option',
            state: ChoiceVisualState.idle,
          ),
          ChoiceOption(
            id: '2',
            label: 'Selected',
            state: ChoiceVisualState.selected,
          ),
          ChoiceOption(
            id: '3',
            label: 'Positive',
            state: ChoiceVisualState.positive,
          ),
          ChoiceOption(
            id: '4',
            label: 'Negative',
            state: ChoiceVisualState.negative,
          ),
          ChoiceOption(
            id: '5',
            label: 'Disabled',
            state: ChoiceVisualState.disabled,
          ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Interactive', type: SessionTimer)
Widget sessionTimerInteractive(BuildContext context) {
  final display = context.knobs.string(label: 'Display', initialValue: '00:45');
  final urgent = context.knobs.boolean(label: 'Urgent', initialValue: false);
  return Scaffold(
    body: Center(
      child: SessionTimer(display: display, urgent: urgent),
    ),
  );
}
