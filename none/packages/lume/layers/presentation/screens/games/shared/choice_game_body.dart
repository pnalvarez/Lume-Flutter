import 'package:flutter/material.dart';
import 'package:lume/layers/presentation/screens/games/shared/game_answer_chrome.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/organisms/game/choice_group.dart';
import 'package:lume_design_system/organisms/game/prompt_card.dart';

/// Shared chrome for multiple-choice trail games. No Bloc/GetIt/AutoRoute.
class ChoiceGameBody extends StatelessWidget {
  const ChoiceGameBody({
    super.key,
    required this.eyebrow,
    required this.prompt,
    required this.options,
    required this.answered,
    required this.isCorrect,
    this.explanation,
    required this.onOptionSelected,
    required this.onNext,
  });

  final String eyebrow;
  final String prompt;
  final List<ChoiceOption> options;
  final bool answered;
  final bool isCorrect;
  final String? explanation;
  final ValueChanged<String> onOptionSelected;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return GameAnswerChrome(
      answered: answered,
      isCorrect: isCorrect,
      explanation: explanation,
      onNext: onNext,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacings.m),
          PromptCard(text: prompt, eyebrow: eyebrow),
          const SizedBox(height: AppSpacings.l),
          ChoiceGroup(
            options: options,
            onSelected: answered ? null : onOptionSelected,
          ),
        ],
      ),
    );
  }
}
