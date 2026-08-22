import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:flutter/material.dart';

/// Horizontal progress bar with optional header content and percentage.
///
/// [value] must be in [0.0, 1.0]. Colors and labels are provided by the caller.
/// No animation — value updates instantly to avoid rebuild loops.
class LumeProgressBar extends StatelessWidget {
  /// Progress in [0.0, 1.0].
  final double value;

  /// Optional text label above-left of the bar.
  /// Ignored when [leading] is set.
  final String? label;

  /// Optional widget above-left (e.g. a [LumeBadge]). Takes precedence over [label].
  final Widget? leading;

  /// Show the percentage value as text above-right of the bar.
  final bool showPercentage;

  /// Bar height in logical pixels.
  final double height;

  /// Fill color; defaults to [ColorScheme.primary].
  final Color? fillColor;

  /// Track color; defaults to [ColorScheme.surfaceContainerHigh].
  final Color? trackColor;

  const LumeProgressBar({
    super.key,
    required this.value,
    this.label,
    this.leading,
    this.showPercentage = true,
    this.height = 10,
    this.fillColor,
    this.trackColor,
  }) : assert(value >= 0.0 && value <= 1.0, 'value must be in [0.0, 1.0]');

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final effectiveFill = fillColor ?? cs.primary;
    final effectiveTrack = trackColor ?? cs.surfaceContainerHigh;
    final hasHeader = leading != null || label != null || showPercentage;
    final clamped = value.clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasHeader)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (leading != null)
                  leading!
                else if (label != null)
                  Text(
                    label!,
                    style: typ.tagS.copyWith(color: cs.onSurfaceVariant),
                  )
                else
                  const SizedBox.shrink(),
                if (showPercentage)
                  Text(
                    '${(clamped * 100).round()}%',
                    style: typ.tagS.copyWith(color: cs.onSurface),
                  ),
              ],
            ),
          ),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.full(height)),
          child: LinearProgressIndicator(
            value: clamped,
            minHeight: height,
            backgroundColor: effectiveTrack,
            valueColor: AlwaysStoppedAnimation(effectiveFill),
            borderRadius: BorderRadius.circular(AppRadius.full(height)),
          ),
        ),
      ],
    );
  }
}
