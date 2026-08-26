import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:flutter/material.dart';

/// Theme-driven color pair for [SparklingBadge].
enum SparklingBadgeVariant {
  /// Warm peach fill (error container) with brown accent.
  warm,

  /// Gold accent container.
  accent,

  /// Brand primary container.
  primary,

  /// Secondary blue container.
  secondary,
}

/// Leading glyph for [SparklingBadge].
enum SparklingBadgeIcon { sparkle, flame, bolt }

/// Pill badge with a leading icon, uppercase [title], and [description].
///
/// Colors and icon come from [variant] and [leadingIcon] enums; all copy is
/// provided by the caller.
///
/// ```dart
/// SparklingBadge(
///   title: 'Dias seguidos',
///   description: '0 dias',
///   variant: SparklingBadgeVariant.warm,
///   leadingIcon: SparklingBadgeIcon.flame,
/// )
/// ```
class SparklingBadge extends StatelessWidget {
  /// Small uppercase caption above the description (e.g. `'Dias seguidos'`).
  final String title;

  /// Primary value line under the title (e.g. `'0 dias'`).
  final String description;

  /// Color theme; defaults to [SparklingBadgeVariant.warm].
  final SparklingBadgeVariant variant;

  /// Leading glyph; defaults to [SparklingBadgeIcon.sparkle].
  final SparklingBadgeIcon leadingIcon;

  const SparklingBadge({
    super.key,
    required this.title,
    required this.description,
    this.variant = SparklingBadgeVariant.warm,
    this.leadingIcon = SparklingBadgeIcon.sparkle,
  });

  static const double _iconSize = 18;
  static const double _minHeight = 40;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final (bg, accent) = switch (variant) {
      SparklingBadgeVariant.warm => (cs.errorContainer, cs.onError),
      SparklingBadgeVariant.accent => (cs.tertiaryContainer, cs.onTertiary),
      SparklingBadgeVariant.primary => (
        cs.primaryContainer,
        cs.onPrimaryContainer,
      ),
      SparklingBadgeVariant.secondary => (
        cs.secondaryContainer,
        cs.onSecondaryContainer,
      ),
    };
    final iconData = switch (leadingIcon) {
      SparklingBadgeIcon.sparkle => Icons.auto_awesome_rounded,
      SparklingBadgeIcon.flame => Icons.local_fire_department_outlined,
      SparklingBadgeIcon.bolt => Icons.bolt_rounded,
    };

    return Container(
      constraints: const BoxConstraints(minHeight: _minHeight),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacings.m,
        vertical: AppSpacings.s,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.full(_minHeight)),
        border: Border.all(color: accent.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.06),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(iconData, size: _iconSize, color: accent),
          const SizedBox(width: AppSpacings.s),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.toUpperCase(),
                style: typ.tagXS.copyWith(
                  color: accent,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                description,
                style: typ.tagRegular.copyWith(
                  color: accent,
                  fontWeight: FontWeight.w700,
                  height: 1.15,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
