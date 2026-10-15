import 'package:flutter/material.dart';
import 'package:lume/layers/presentation/screens/games/knowledge_gallery/knowledge_gallery_body.dart';
import 'package:lume/layers/presentation/screens/games/knowledge_gallery/knowledge_gallery_state.dart';
import 'package:lume_design_system/organisms/game/artwork_prompt_card.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

void _noopString(String _) {}

const _prompt = 'A qual movimento esta pintura pertence?';

const _options = ['Impressionismo', 'Cubismo', 'Barroco', 'Romantismo'];

const _image = AssetImage('assets/onboarding/slide-1.jpg');

const _playing = KnowledgeGalleryState(
  prompt: _prompt,
  imageUrl: '',
  image: _image,
  options: _options,
);

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Knowledge Gallery',
  name: 'Playing',
  type: KnowledgeGalleryBody,
)
Widget knowledgeGalleryPlaying(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: KnowledgeGalleryBody(state: _playing, onOptionSelected: _noopString),
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Knowledge Gallery',
  name: 'Submitting',
  type: KnowledgeGalleryBody,
)
Widget knowledgeGallerySubmitting(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: KnowledgeGalleryBody(
      state: const KnowledgeGalleryState(
        prompt: _prompt,
        imageUrl: '',
        image: _image,
        options: _options,
        selectedOptionId: '0',
        phase: KnowledgeGalleryPhase.submitting,
      ),
      onOptionSelected: _noopString,
    ),
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Knowledge Gallery',
  name: 'Answered correct',
  type: KnowledgeGalleryBody,
)
Widget knowledgeGalleryAnsweredCorrect(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: KnowledgeGalleryBody(
      state: const KnowledgeGalleryState(
        prompt: _prompt,
        imageUrl: '',
        image: _image,
        options: _options,
        selectedOptionId: '0',
        correctOptionId: '0',
        phase: KnowledgeGalleryPhase.correct,
      ),
      onOptionSelected: _noopString,
    ),
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Knowledge Gallery',
  name: 'Answered wrong',
  type: KnowledgeGalleryBody,
)
Widget knowledgeGalleryAnsweredWrong(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: KnowledgeGalleryBody(
      state: const KnowledgeGalleryState(
        prompt: _prompt,
        imageUrl: '',
        image: _image,
        options: _options,
        selectedOptionId: '1',
        correctOptionId: '0',
        phase: KnowledgeGalleryPhase.incorrect,
      ),
      onOptionSelected: _noopString,
    ),
  );
}

@widgetbook.UseCase(
  path: '[Lume]/[Screens]/Knowledge Gallery',
  name: 'Image failed',
  type: KnowledgeGalleryBody,
)
Widget knowledgeGalleryImageFailed(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: KnowledgeGalleryBody(
      state: const KnowledgeGalleryState(
        prompt: _prompt,
        imageUrl: '',
        imagePhase: ArtworkPromptImagePhase.error,
        options: _options,
      ),
      onOptionSelected: _noopString,
    ),
  );
}
