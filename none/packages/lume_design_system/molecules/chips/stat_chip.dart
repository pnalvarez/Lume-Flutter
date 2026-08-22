import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:flutter/material.dart';

/// Compact info chip displaying an icon, label and value.
///
/// Based on [StatChip.tsx] in the Lume web app.
///
/// ```dart
/// StatChip(
///   icon: Icons.bolt_rounded,
///   label: 'XP',
///   value: '1 200',
/// )
/// ```
class StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  /// Override the icon color; defaults to [ColorScheme.primary].
  final Color? iconColor;

  const StatChip({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final effectiveIconColor = iconColor ?? cs.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.m),
        border: Border.all(color: cs.outline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: effectiveIconColor),
          const SizedBox(width: 6),
          Text(label, style: typ.tagS.copyWith(color: cs.onSurfaceVariant)),
          const SizedBox(width: 6),
          Text(value, style: typ.tagS.copyWith(color: cs.onSurface)),
        ],
      ),
    );
  }
}
