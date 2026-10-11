import 'package:flutter/material.dart';
import 'package:lume/layers/presentation/screens/games/knowledge_gallery/knowledge_gallery_state.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/organisms/game/artwork_prompt_card.dart';
import 'package:lume_design_system/organisms/game/choice_group.dart';

/// Knowledge Gallery play surface. No Bloc, GetIt, or router.
class KnowledgeGalleryBody extends StatelessWidget {
  const KnowledgeGalleryBody({
    super.key,
    required this.state,
    required this.onOptionSelected,
  });

  final KnowledgeGalleryState state;
  final ValueChanged<String> onOptionSelected;

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

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ArtworkPromptCard(
            question: state.prompt,
            imageUrl: state.image == null ? state.imageUrl : null,
            image: state.image,
            phase: state.imagePhase,
          ),
          const SizedBox(height: AppSpacings.l),
          ChoiceGroup(
            options: options,
            onSelected: state.answered ? null : onOptionSelected,
          ),
        ],
      ),
    );
  }
}
