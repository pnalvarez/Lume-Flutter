import 'package:flutter/material.dart';
import 'package:lume_design_system/organisms/game/artwork_prompt_card.dart';
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

@widgetbook.UseCase(name: 'Default', type: ArtworkPromptCard)
Widget artworkPromptCardDefault(BuildContext context) {
  final url = context.knobs.string(label: 'Image URL', initialValue: '');
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: ArtworkPromptCard(
        question: context.knobs.string(
          label: 'Question',
          initialValue: 'Which movement does this painting belong to?',
        ),
        imageUrl: url.isEmpty ? null : url,
        image: url.isEmpty
            ? const AssetImage('assets/onboarding/slide-1.jpg')
            : null,
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Loading', type: ArtworkPromptCard)
Widget artworkPromptCardLoading(BuildContext context) {
  return const Scaffold(
    body: Padding(
      padding: EdgeInsets.all(24),
      child: ArtworkPromptCard(
        question: 'Which movement does this painting belong to?',
        phase: ArtworkPromptImagePhase.loading,
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Error', type: ArtworkPromptCard)
Widget artworkPromptCardError(BuildContext context) {
  return const Scaffold(
    body: Padding(
      padding: EdgeInsets.all(24),
      child: ArtworkPromptCard(
        question: 'Which movement does this painting belong to?',
        phase: ArtworkPromptImagePhase.error,
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
