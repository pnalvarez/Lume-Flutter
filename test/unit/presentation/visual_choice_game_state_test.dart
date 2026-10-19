import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/presentation/screens/games/visual_choice_game/visual_choice_game_state.dart';
import 'package:lume_design_system/organisms/game/choice_group.dart';

void main() {
  const base = VisualChoiceGameState(
    prompt: 'Prompt',
    imageUrl: '',
    options: ['A', 'B', 'C', 'D'],
  );

  test('submitting maps the selected option to loading', () {
    final state = base.copyWith(
      selectedOptionId: '1',
      phase: VisualChoiceGamePhase.submitting,
    );

    expect(state.visualStateFor('1'), ChoiceVisualState.loading);
    expect(state.visualStateFor('0'), ChoiceVisualState.disabled);
    expect(state.visualStateFor('2'), ChoiceVisualState.disabled);
    expect(state.canSelect, isFalse);
  });
}
