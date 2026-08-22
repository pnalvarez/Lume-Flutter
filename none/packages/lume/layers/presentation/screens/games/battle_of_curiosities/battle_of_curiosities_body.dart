import 'package:flutter/material.dart';
import 'package:lume/common/strings/trail_strings.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game_values.dart';
import 'package:lume/layers/presentation/screens/games/battle_of_curiosities/battle_of_curiosities_state.dart';
import 'package:lume/layers/presentation/screens/games/shared/choice_game_body.dart';
import 'package:lume_design_system/organisms/game/choice_group.dart';

class BattleOfCuriositiesBody extends StatelessWidget {
  const BattleOfCuriositiesBody({
    super.key,
    required this.state,
    required this.onOptionSelected,
    required this.onNext,
  });

  final BattleOfCuriositiesState state;
  final ValueChanged<String> onOptionSelected;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final game = state.game;
    if (game == null) return const SizedBox.shrink();

    final criterion = game.comparisonCriterion?.trim();
    final prompt = (criterion != null && criterion.isNotEmpty)
        ? '${game.question}\n\n$criterion'
        : game.question;

    final options = [
      ChoiceOption(
        id: BattleCorrectSide.a.wireValue,
        label: game.optionA,
        state: _visualState(BattleCorrectSide.a.wireValue),
      ),
      ChoiceOption(
        id: BattleCorrectSide.b.wireValue,
        label: game.optionB,
        state: _visualState(BattleCorrectSide.b.wireValue),
      ),
    ];

    return ChoiceGameBody(
      eyebrow: trailGameTypeBattle,
      prompt: prompt,
      options: options,
      answered: state.answered,
      isCorrect: state.isCorrect,
      explanation: game.explanation,
      onOptionSelected: onOptionSelected,
      onNext: onNext,
    );
  }

  ChoiceVisualState _visualState(String id) {
    if (!state.answered) {
      return state.selectedOptionId == id
          ? ChoiceVisualState.selected
          : ChoiceVisualState.idle;
    }
    final game = state.game!;
    if (id == game.correct.wireValue) return ChoiceVisualState.positive;
    if (state.selectedOptionId == id) return ChoiceVisualState.negative;
    return ChoiceVisualState.disabled;
  }
}
