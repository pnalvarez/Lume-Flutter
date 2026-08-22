import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:flutter/material.dart';

/// Thin progress bar with `current/total` caption.
class StepProgressBar extends StatelessWidget {
  final int currentValue;
  final int totalValue;
  final double barHeight;
  final bool showLabel;

  const StepProgressBar({
    super.key,
    required this.currentValue,
    required this.totalValue,
    this.barHeight = 4,
    this.showLabel = true,
  }) : assert(barHeight > 0);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final safeTotal = totalValue <= 0 ? 0 : totalValue;
    final current = safeTotal == 0 ? 0 : currentValue.clamp(0, safeTotal);
    final fraction = safeTotal == 0 ? 0.0 : current / safeTotal;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(barHeight / 2),
          child: LinearProgressIndicator(
            value: fraction,
            minHeight: barHeight,
            backgroundColor: cs.surfaceContainerHighest,
            color: cs.primary,
          ),
        ),
        if (showLabel) ...[
          const SizedBox(height: AppSpacings.xs),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              safeTotal == 0 ? '0/0' : '$current/$safeTotal',
              style: typ.tagS.copyWith(color: cs.onSurfaceVariant),
            ),
          ),
        ],
      ],
    );
  }
}
