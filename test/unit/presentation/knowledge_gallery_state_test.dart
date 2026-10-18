import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/presentation/screens/games/knowledge_gallery/knowledge_gallery_state.dart';
import 'package:lume_design_system/organisms/game/choice_group.dart';

void main() {
  const base = KnowledgeGalleryState(
    prompt: 'Prompt',
    imageUrl: '',
    options: ['A', 'B', 'C', 'D'],
  );

  test('submitting maps the selected option to loading', () {
    final state = base.copyWith(
      selectedOptionId: '1',
      phase: KnowledgeGalleryPhase.submitting,
    );

    expect(state.visualStateFor('1'), ChoiceVisualState.loading);
    expect(state.visualStateFor('0'), ChoiceVisualState.disabled);
    expect(state.visualStateFor('2'), ChoiceVisualState.disabled);
    expect(state.canSelect, isFalse);
  });
}
