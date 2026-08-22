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

    final options = [
      ChoiceOption(
        id: BattleCorrectSide.a.wireValue,
        label: game.optionA,
        state: state.visualStateFor(BattleCorrectSide.a.wireValue),
      ),
      ChoiceOption(
        id: BattleCorrectSide.b.wireValue,
        label: game.optionB,
        state: state.visualStateFor(BattleCorrectSide.b.wireValue),
      ),
    ];

    return ChoiceGameBody(
      eyebrow: trailGameTypeBattle,
      prompt: state.prompt,
      options: options,
      answered: state.answered,
      isCorrect: state.isCorrect,
      explanation: game.explanation,
      onOptionSelected: onOptionSelected,
      onNext: onNext,
    );
  }
}
