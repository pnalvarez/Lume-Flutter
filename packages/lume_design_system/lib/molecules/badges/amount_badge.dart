import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:flutter/material.dart';

/// Compact bordered pill for a numeric/text amount.
///
/// All copy is provided by the caller — no unit (e.g. "XP") is baked in.
///
/// ```dart
/// AmountBadge(
///   text: '+15 XP',
///   secondaryText: 'Quiz concluído',
///   icon: Icons.bolt_rounded,
///   accentColor: AppColors.Accent.accent,
/// )
/// ```
class AmountBadge extends StatelessWidget {
  /// Primary text (e.g. `'+15 XP'` or `'1 200'`).
  final String text;

  /// Optional caption after an em dash.
  final String? secondaryText;

  final IconData? icon;

  /// Accent for icon + primary text; defaults to [ColorScheme.tertiary].
  final Color? accentColor;

  const AmountBadge({
    super.key,
    required this.text,
    this.secondaryText,
    this.icon,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final accent = accentColor ?? cs.tertiary;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacings.m,
        vertical: AppSpacings.s,
      ),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.full(40)),
        border: Border.all(color: accent.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: accent),
            const SizedBox(width: AppSpacings.xs),
          ],
          Text(
            text,
            style: typ.tagRegular.copyWith(
              color: accent,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (secondaryText != null && secondaryText!.isNotEmpty)
            Text(
              ' — $secondaryText',
              style: typ.tagS.copyWith(color: cs.onSurfaceVariant),
            ),
        ],
      ),
    );
  }
}
