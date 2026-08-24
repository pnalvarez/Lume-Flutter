import 'package:flutter/material.dart';
import 'package:lume_design_system/molecules/loaders/shimmer_box.dart';
import 'package:shimmer/shimmer.dart';

/// Shows a shimmer that matches the laid-out size (and optional clip) of [child].
///
/// The [child] is measured invisibly so the shimmer covers the same dimensions
/// as the real content — useful when skeletoning arbitrary widgets (text, cards,
/// chips) without hard-coding widths and heights.
///
/// When [enabled] is false, [child] is shown as-is.
class DisplayAsLoader extends StatelessWidget {
  const DisplayAsLoader({
    super.key,
    required this.child,
    this.enabled = true,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
    this.baseColor,
    this.highlightColor,
  });

  /// Content whose size defines the shimmer bounds.
  final Widget child;

  /// When false, renders [child] without shimmer.
  final bool enabled;

  /// Clip for the shimmer fill when [shape] is [BoxShape.rectangle].
  final BorderRadiusGeometry? borderRadius;

  /// Use [BoxShape.circle] to cover circular children (e.g. avatars).
  final BoxShape shape;

  final Color? baseColor;

  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    final resolvedBase = baseColor ?? ShimmerBox.shimmerBaseColor(context);
    final resolvedHighlight =
        highlightColor ??
        ShimmerBox.shimmerHighlightColor(context, resolvedBase);

    return Stack(
      fit: StackFit.passthrough,
      children: [
        Visibility(
          visible: false,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: child,
        ),
        Positioned.fill(
          child: Shimmer.fromColors(
            baseColor: resolvedBase,
            highlightColor: resolvedHighlight,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: resolvedBase,
                shape: shape,
                borderRadius: shape == BoxShape.circle ? null : borderRadius,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
