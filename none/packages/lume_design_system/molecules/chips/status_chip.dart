import 'package:lume_design_system/atoms/colors/colors.dart';
import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:flutter/material.dart';

/// Semantic state for [StatusChip].
enum StatusChipState { success, neutral, error, warning, primary }

/// Pill with optional colored status dot.
class StatusChip extends StatelessWidget {
  final String label;
  final StatusChipState state;
  final bool hasDot;

  const StatusChip({
    super.key,
    required this.label,
    required this.state,
    this.hasDot = true,
  });

  static const double _minHeight = 32;
  static const double _dotSize = 6;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final accent = _accent(state, cs);
    final borderColor =
        Color.lerp(cs.outline.withValues(alpha: 0.65), accent, 0.42) ??
        cs.outline;

    return Container(
      constraints: const BoxConstraints(minHeight: _minHeight),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacings.m,
        vertical: AppSpacings.xs,
      ),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.full(_minHeight)),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasDot) ...[
            Container(
              width: _dotSize,
              height: _dotSize,
              decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
            ),
            const SizedBox(width: AppSpacings.xs),
          ],
          Text(label, style: typ.tagS.copyWith(color: cs.onSurfaceVariant)),
        ],
      ),
    );
  }

  Color _accent(StatusChipState state, ColorScheme cs) => switch (state) {
    StatusChipState.success => AppColors.Success.success,
    StatusChipState.neutral => cs.onSurfaceVariant,
    StatusChipState.error => AppColors.Error.onError,
    StatusChipState.warning => AppColors.Accent.accent,
    StatusChipState.primary => cs.primary,
  };
}
