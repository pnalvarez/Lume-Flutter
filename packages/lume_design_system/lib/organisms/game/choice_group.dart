import 'package:flutter/material.dart';
import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/organisms/list_item/list_item.dart';

/// Visual state for a choice row (no domain meaning).
enum ChoiceVisualState { idle, selected, positive, negative, disabled }

/// Single selectable option.
class ChoiceOption {
  final String id;
  final String label;
  final ChoiceVisualState state;

  const ChoiceOption({
    required this.id,
    required this.label,
    this.state = ChoiceVisualState.idle,
  });
}

/// Vertical list of tappable choice rows, each backed by [ListItem].
class ChoiceGroup extends StatelessWidget {
  final List<ChoiceOption> options;
  final ValueChanged<String>? onSelected;

  const ChoiceGroup({super.key, required this.options, this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < options.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacings.s),
          _ChoiceRow(
            option: options[i],
            onTap: options[i].state == ChoiceVisualState.disabled
                ? null
                : () => onSelected?.call(options[i].id),
          ),
        ],
      ],
    );
  }
}

class _ChoiceRow extends StatelessWidget {
  final ChoiceOption option;
  final VoidCallback? onTap;

  const _ChoiceRow({required this.option, this.onTap});

  @override
  Widget build(BuildContext context) {
    final (trait, isSelected, isEnabled, trailing) = switch (option.state) {
      ChoiceVisualState.idle => (
        ListItemTrait.neutral,
        false,
        true,
        null,
      ),
      ChoiceVisualState.selected => (
        ListItemTrait.brand,
        true,
        true,
        null,
      ),
      ChoiceVisualState.positive => (
        ListItemTrait.success,
        false,
        true,
        Icons.check_circle_rounded,
      ),
      ChoiceVisualState.negative => (
        ListItemTrait.destructive,
        false,
        true,
        Icons.cancel_rounded,
      ),
      ChoiceVisualState.disabled => (
        ListItemTrait.neutral,
        false,
        false,
        null,
      ),
    };

    return ListItem(
      trait: trait,
      isSelected: isSelected,
      isEnabled: isEnabled,
      isExpanded: true,
      borderRadius: AppRadius.l,
      onTap: onTap,
      input: TextInput(text: option.label, trailingIcon: trailing),
    );
  }
}
