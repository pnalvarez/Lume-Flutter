import 'package:flutter/material.dart';
import 'package:lume/common/strings/trail_strings.dart';
import 'package:lume/layers/presentation/screens/games/lightning_quiz/lightning_quiz_state.dart';
import 'package:lume/layers/presentation/screens/games/shared/choice_game_body.dart';
import 'package:lume_design_system/organisms/game/choice_group.dart';

class LightningQuizBody extends StatelessWidget {
  const LightningQuizBody({
    super.key,
    required this.state,
    required this.onOptionSelected,
    required this.onNext,
  });

  final LightningQuizState state;
  final ValueChanged<String> onOptionSelected;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final game = state.game;
    if (game == null) return const SizedBox.shrink();

    final options = [
      for (var i = 0; i < game.options.length; i++)
        ChoiceOption(
          id: '$i',
          label: game.options[i],
          state: _visualState(i),
        ),
    ];

    return ChoiceGameBody(
      eyebrow: trailGameTypeLightningQuiz,
      prompt: game.prompt,
      options: options,
      answered: state.answered,
      isCorrect: state.isCorrect,
      explanation: game.explanation,
      onOptionSelected: onOptionSelected,
      onNext: onNext,
    );
  }

  ChoiceVisualState _visualState(int index) {
    if (!state.answered) {
      return state.selectedOptionId == '$index'
          ? ChoiceVisualState.selected
          : ChoiceVisualState.idle;
    }
    final game = state.game!;
    if (index == game.correctIndex) return ChoiceVisualState.positive;
    if (state.selectedOptionId == '$index') return ChoiceVisualState.negative;
    return ChoiceVisualState.disabled;
  }
}
