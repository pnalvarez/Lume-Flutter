import 'package:flutter/material.dart';
import 'package:lume_design_system/atoms/colors/colors.dart';
import 'package:lume_design_system/atoms/spacing/radius.dart';
import 'package:shimmer/shimmer.dart';

/// Gray placeholder with a shimmer sweep for loading states.
///
/// Use for skeleton lines, cards, avatars, or list rows while content loads.
class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
    this.baseColor,
    this.highlightColor,
  });

  /// When null, expands horizontally inside flex parents.
  final double? width;

  final double height;

  /// Applied when [shape] is [BoxShape.rectangle]. Defaults to [AppRadius.s].
  final BorderRadiusGeometry? borderRadius;

  /// Use [BoxShape.circle] for avatar-style placeholders (ignores [borderRadius]).
  final BoxShape shape;

  /// Shimmer base gray; defaults to cool neutral surface greys.
  final Color? baseColor;

  /// Shimmer highlight; defaults to a lighter grey than [baseColor].
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    final resolvedBase = baseColor ?? shimmerBaseColor(context);
    final resolvedHighlight =
        highlightColor ?? shimmerHighlightColor(context, resolvedBase);

    return Shimmer.fromColors(
      baseColor: resolvedBase,
      highlightColor: resolvedHighlight,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: resolvedBase,
          shape: shape,
          borderRadius: shape == BoxShape.circle
              ? null
              : (borderRadius ?? BorderRadius.circular(AppRadius.s)),
        ),
      ),
    );
  }

  /// Cool grey base for skeleton blocks on light surfaces.
  static Color shimmerBaseColor(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (scheme.brightness == Brightness.dark) {
      return Color.lerp(scheme.surface, scheme.onSurface, 0.28)!;
    }
    // Neutral cool grey between outline and surface containers.
    return Color.lerp(
      AppColors.Surface.surfaceContainerHighest,
      AppColors.Extra.slate,
      0.35,
    )!;
  }

  /// Lighter sweep grey against [base].
  static Color shimmerHighlightColor(BuildContext context, Color base) {
    final scheme = Theme.of(context).colorScheme;
    if (scheme.brightness == Brightness.dark) {
      return Color.lerp(scheme.surface, scheme.onSurface, 0.55)!;
    }
    return Color.lerp(base, AppColors.Surface.surfaceContainerLowest, 0.72)!;
  }
}
