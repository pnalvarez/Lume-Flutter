import 'package:flutter/material.dart';
import 'package:lume/common/strings/trail_strings.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game_values.dart';
import 'package:lume/layers/presentation/screens/games/shared/choice_game_body.dart';
import 'package:lume/layers/presentation/screens/games/true_or_myth/true_or_myth_state.dart';
import 'package:lume_design_system/organisms/game/choice_group.dart';

class TrueOrMythBody extends StatelessWidget {
  const TrueOrMythBody({
    super.key,
    required this.state,
    required this.onOptionSelected,
    required this.onNext,
  });

  final TrueOrMythState state;
  final ValueChanged<String> onOptionSelected;
  final VoidCallback onNext;

  static const _options = [
    (TrueOrMythVerdict.truth, trailGameTrue),
    (TrueOrMythVerdict.myth, trailGameMyth),
    (TrueOrMythVerdict.partial, trailGamePartial),
  ];

  @override
  Widget build(BuildContext context) {
    final game = state.game;
    if (game == null) return const SizedBox.shrink();

    final options = [
      for (final (verdict, label) in _options)
        ChoiceOption(
          id: verdict.wireValue,
          label: label,
          state: _visualState(verdict.wireValue),
        ),
    ];

    return ChoiceGameBody(
      eyebrow: trailGameTypeTrueOrMyth,
      prompt: game.text,
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
    if (id == game.verdict.wireValue) return ChoiceVisualState.positive;
    if (state.selectedOptionId == id) return ChoiceVisualState.negative;
    return ChoiceVisualState.disabled;
  }
}
