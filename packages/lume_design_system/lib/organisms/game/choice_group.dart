import 'package:lume_design_system/atoms/colors/colors.dart';
import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:flutter/material.dart';

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

/// Vertical list of tappable choice rows.
class ChoiceGroup extends StatelessWidget {
  final List<ChoiceOption> options;
  final ValueChanged<String>? onSelected;

  const ChoiceGroup({
    super.key,
    required this.options,
    this.onSelected,
  });

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
    final cs = Theme.of(context).colorScheme;
    final (Color bg, Color border, Color fg) = switch (option.state) {
      ChoiceVisualState.idle => (
          cs.surfaceContainerLowest,
          cs.outline,
          cs.onSurface,
        ),
      ChoiceVisualState.selected => (
          cs.primaryContainer,
          cs.primary,
          cs.onPrimaryContainer,
        ),
      ChoiceVisualState.positive => (
          AppColors.Success.successContainer,
          AppColors.Success.success,
          AppColors.Success.onSuccess,
        ),
      ChoiceVisualState.negative => (
          AppColors.Error.errorContainer,
          AppColors.Error.error,
          AppColors.Error.onError,
        ),
      ChoiceVisualState.disabled => (
          cs.surfaceContainerLow,
          cs.outline.withValues(alpha: 0.5),
          cs.onSurface.withValues(alpha: 0.38),
        ),
    };

    final radius = BorderRadius.circular(AppRadius.l);

    return Material(
      color: bg,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: border, width: 1.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacings.l,
            vertical: AppSpacings.m,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  option.label,
                  style: typ.body3Medium.copyWith(color: fg),
                ),
              ),
              if (option.state == ChoiceVisualState.positive)
                Icon(Icons.check_circle_rounded, color: fg, size: 20),
              if (option.state == ChoiceVisualState.negative)
                Icon(Icons.cancel_rounded, color: fg, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
