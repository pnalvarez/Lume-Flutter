import 'package:flutter/material.dart';
import 'package:lume/layers/presentation/screens/games/visual_choice_game/visual_choice_game_body.dart';
import 'package:lume/layers/presentation/screens/games/visual_choice_game/visual_choice_game_state.dart';
import 'package:lume_design_system/organisms/game/artwork_prompt_card.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

void _noopString(String _) {}

const _prompt = 'A qual movimento esta pintura pertence?';

const _options = ['Impressionismo', 'Cubismo', 'Barroco', 'Romantismo'];

const _image = AssetImage('assets/onboarding/slide-1.jpg');

const _playing = VisualChoiceGameState(
  prompt: _prompt,
  imageUrl: '',
  image: _image,
  options: _options,
);

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Visual Choice Game',
  name: 'Playing',
  type: VisualChoiceGameBody,
)
Widget visualChoiceGamePlaying(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: VisualChoiceGameBody(state: _playing, onOptionSelected: _noopString),
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Visual Choice Game',
  name: 'Submitting',
  type: VisualChoiceGameBody,
)
Widget knowledgeVisualSubmitting(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: VisualChoiceGameBody(
      state: const VisualChoiceGameState(
        prompt: _prompt,
        imageUrl: '',
        image: _image,
        options: _options,
        selectedOptionId: '0',
        phase: VisualChoiceGamePhase.submitting,
      ),
      onOptionSelected: _noopString,
    ),
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Visual Choice Game',
  name: 'Answered correct',
  type: VisualChoiceGameBody,
)
Widget visualChoiceGameAnsweredCorrect(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: VisualChoiceGameBody(
      state: const VisualChoiceGameState(
        prompt: _prompt,
        imageUrl: '',
        image: _image,
        options: _options,
        selectedOptionId: '0',
        correctOptionId: '0',
        phase: VisualChoiceGamePhase.correct,
      ),
      onOptionSelected: _noopString,
    ),
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Visual Choice Game',
  name: 'Answered wrong',
  type: VisualChoiceGameBody,
)
Widget visualChoiceGameAnsweredWrong(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: VisualChoiceGameBody(
      state: const VisualChoiceGameState(
        prompt: _prompt,
        imageUrl: '',
        image: _image,
        options: _options,
        selectedOptionId: '1',
        correctOptionId: '0',
        phase: VisualChoiceGamePhase.incorrect,
      ),
      onOptionSelected: _noopString,
    ),
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Visual Choice Game',
  name: 'Image failed',
  type: VisualChoiceGameBody,
)
Widget visualChoiceGameImageFailed(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: VisualChoiceGameBody(
      state: const VisualChoiceGameState(
        prompt: _prompt,
        imageUrl: '',
        imagePhase: ArtworkPromptImagePhase.error,
        options: _options,
      ),
      onOptionSelected: _noopString,
    ),
  );
}
