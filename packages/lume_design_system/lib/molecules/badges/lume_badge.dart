import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:flutter/material.dart';

/// Visual variant for [LumeBadge] when no explicit colors are provided.
enum LumeBadgeVariant { primary, secondary, destructive, outline, accent }

/// Small pill label. Copy, icon and optional custom colors come from the caller.
///
/// Prefer [variant] for theme-driven looks. Pass [backgroundColor] /
/// [foregroundColor] / [borderColor] when the feature maps a domain state to UI.
class LumeBadge extends StatelessWidget {
  final String label;
  final LumeBadgeVariant variant;
  final IconData? leadingIcon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;

  const LumeBadge({
    super.key,
    required this.label,
    this.variant = LumeBadgeVariant.primary,
    this.leadingIcon,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
  });

  static const double _minHeight = 24;
  static const double _iconSize = 12;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final themed = switch (variant) {
      LumeBadgeVariant.primary => (cs.primary, cs.onPrimary, null as Color?),
      LumeBadgeVariant.secondary => (
        cs.secondaryContainer,
        cs.onSecondaryContainer,
        null,
      ),
      LumeBadgeVariant.destructive => (cs.error, cs.onError, null),
      LumeBadgeVariant.outline => (
        Colors.transparent,
        cs.onSurface,
        cs.outline,
      ),
      LumeBadgeVariant.accent => (cs.tertiary, cs.onTertiary, null),
    };

    final bg = backgroundColor ?? themed.$1;
    final fg = foregroundColor ?? themed.$2;
    final border = borderColor ?? themed.$3;

    return Container(
      constraints: const BoxConstraints(minHeight: _minHeight),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacings.s,
        vertical: AppSpacings.xs2,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.full(_minHeight)),
        border: border == null ? null : Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leadingIcon != null) ...[
            Icon(leadingIcon, size: _iconSize, color: fg),
            const SizedBox(width: AppSpacings.xs2),
          ],
          Text(label, style: typ.tagS.copyWith(color: fg)),
        ],
      ),
    );
  }
}
