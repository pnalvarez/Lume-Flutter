import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:flutter/material.dart';

/// Compact timer chip. The caller owns the countdown value/formatting.
class SessionTimer extends StatelessWidget {
  /// Already-formatted time string (e.g. `01:20`).
  final String display;

  /// When true, uses error/warning colors.
  final bool urgent;
  final IconData icon;

  const SessionTimer({
    super.key,
    required this.display,
    this.urgent = false,
    this.icon = Icons.timer_outlined,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final fg = urgent ? cs.error : cs.onSurface;
    final bg = urgent
        ? cs.errorContainer
        : cs.surfaceContainerLow;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacings.m,
        vertical: AppSpacings.s,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.full(36)),
        border: Border.all(color: urgent ? cs.error : cs.outline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: fg),
          const SizedBox(width: AppSpacings.xs),
          Text(
            display,
            style: typ.tagRegular.copyWith(
              color: fg,
              fontWeight: FontWeight.w700,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
