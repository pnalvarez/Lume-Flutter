import 'package:flutter/material.dart';
import 'package:lume/common/strings/trail_strings.dart';
import 'package:lume/layers/presentation/screens/games/shared/game_answer_chrome.dart';
import 'package:lume/layers/presentation/screens/games/who_am_i/who_am_i_state.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/buttons/lume_button.dart';
import 'package:lume_design_system/molecules/input_fields/input_field.dart';
import 'package:lume_design_system/organisms/game/prompt_card.dart';

class WhoAmIBody extends StatefulWidget {
  const WhoAmIBody({
    super.key,
    required this.state,
    required this.onAnswerChanged,
    required this.onRevealHint,
    required this.onSubmit,
    required this.onNext,
  });

  final WhoAmIState state;
  final ValueChanged<String> onAnswerChanged;
  final VoidCallback onRevealHint;
  final VoidCallback onSubmit;
  final VoidCallback onNext;

  @override
  State<WhoAmIBody> createState() => _WhoAmIBodyState();
}

class _WhoAmIBodyState extends State<WhoAmIBody> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.state.answer);
  }

  @override
  void didUpdateWidget(covariant WhoAmIBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state.answer != _controller.text) {
      _controller.text = widget.state.answer;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final game = state.game;
    if (game == null) return const SizedBox.shrink();

    final cs = Theme.of(context).colorScheme;
    final visibleHints = state.visibleHints;

    return GameAnswerChrome(
      answered: state.answered,
      isCorrect: state.isCorrect,
      explanation: game.explanation,
      onNext: widget.onNext,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacings.m),
          PromptCard(text: game.header, eyebrow: trailGameTypeWhoAmI),
          const SizedBox(height: AppSpacings.l),
          for (var i = 0; i < visibleHints.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacings.s),
            Text(
              '$trailGameHint ${i + 1}: ${visibleHints[i]}',
              style: typ.body3Light.copyWith(color: cs.onSurface),
            ),
          ],
          if (state.canRevealMore) ...[
            const SizedBox(height: AppSpacings.m),
            Align(
              alignment: Alignment.centerLeft,
              child: LumeButton(
                label: trailGameRevealHint,
                type: LumeButtonType.text,
                size: LumeButtonSize.sm,
                onPressed: widget.onRevealHint,
              ),
            ),
          ],
          if (!state.answered) ...[
            const SizedBox(height: AppSpacings.l),
            InputField(
              controller: _controller,
              placeholder: trailGameAnswerPlaceholder,
              isEnabled: !state.answered,
              onChanged: widget.onAnswerChanged,
            ),
            const SizedBox(height: AppSpacings.m),
            LumeButton(
              label: trailGameSubmit,
              isExpanded: true,
              isEnabled: state.canSubmit,
              onPressed: widget.onSubmit,
            ),
          ],
        ],
      ),
    );
  }
}
