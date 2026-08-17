import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:flutter/material.dart';

/// Metric card: icon + large score + caption.
class ScoreTile extends StatelessWidget {
  final IconData icon;
  final int score;
  final String label;
  final Color? iconColor;

  const ScoreTile({
    super.key,
    required this.icon,
    required this.score,
    required this.label,
    this.iconColor,
  });

  static const double _iconSize = 28;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final accent = iconColor ?? cs.primary;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacings.xl,
        vertical: AppSpacings.l,
      ),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.xl2),
        border: Border.all(color: cs.outline.withValues(alpha: 0.6)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: _iconSize, color: accent),
          const SizedBox(height: AppSpacings.s),
          Text('$score', style: typ.headlineS.copyWith(color: cs.onSurface)),
          const SizedBox(height: AppSpacings.xs),
          Text(
            label,
            textAlign: TextAlign.center,
            style: typ.body4Light.copyWith(color: cs.onSurfaceVariant),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
