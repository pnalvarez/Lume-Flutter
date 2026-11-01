import 'package:flutter/material.dart';
import 'package:lume/layers/presentation/screens/games/visual_choice_game/visual_choice_game_state.dart';
import 'package:lume/layers/presentation/screens/games/shared/game_answer_chrome.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/organisms/game/artwork_prompt_card.dart';
import 'package:lume_design_system/organisms/game/choice_group.dart';

/// Visual-choice play surface. No Bloc, GetIt, or router.
class VisualChoiceGameBody extends StatelessWidget {
  const VisualChoiceGameBody({
    super.key,
    required this.state,
    required this.onOptionSelected,
    this.onNext,
    this.onImageFailed,
  });

  final VisualChoiceGameState state;
  final ValueChanged<String> onOptionSelected;

  /// Shown after an answer when the caller is playing a sequence.
  final VoidCallback? onNext;

  /// Artwork failed to load. Optional so trail/arcade hosts stay silent.
  final VoidCallback? onImageFailed;

  @override
  Widget build(BuildContext context) {
    final options = [
      for (var i = 0; i < state.options.length; i++)
        ChoiceOption(
          id: '$i',
          label: state.options[i],
          state: state.visualStateFor('$i'),
        ),
    ];
    final prompt = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ArtworkPromptCard(
          question: state.prompt,
          imageUrl: state.image == null ? state.imageUrl : null,
          image: state.image,
          phase: state.imagePhase,
          onImageFailed: onImageFailed,
        ),
        const SizedBox(height: AppSpacings.l),
        ChoiceGroup(
          options: options,
          onSelected: state.canSelect ? onOptionSelected : null,
        ),
      ],
    );

    final next = onNext;
    if (next == null) {
      return SingleChildScrollView(child: prompt);
    }

    return GameAnswerChrome(
      answered: state.answered,
      isCorrect: state.isCorrect,
      explanation: state.explanation,
      onNext: next,
      child: prompt,
    );
  }
}
