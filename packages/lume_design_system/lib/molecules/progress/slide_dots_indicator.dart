import 'package:flutter/material.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;

/// Row of [count] dots; the dot at [currentIndex] is larger and shows its
/// 1-based number.
class SlideDotsIndicator extends StatelessWidget {
  static const double currentDotSize = 28;
  static const double dotSize = 8;
  static const Duration animationDuration = Duration(milliseconds: 250);

  final int count;
  final int currentIndex;

  /// Accessibility label (e.g. "Slide 2 of 3"). Supplied by the caller so the
  /// design system stays copy-free.
  final String? semanticsLabel;

  const SlideDotsIndicator({
    super.key,
    this.count = 3,
    required this.currentIndex,
    this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();
    final cs = Theme.of(context).colorScheme;
    final current = currentIndex.clamp(0, count - 1);

    final row = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacings.s),
          _Dot(
            key: ValueKey('slide-dot-$i'),
            number: i + 1,
            isCurrent: i == current,
            isPast: i < current,
            colorScheme: cs,
          ),
        ],
      ],
    );

    return Semantics(
      label: semanticsLabel,
      container: true,
      excludeSemantics: semanticsLabel != null,
      child: row,
    );
  }
}

class _Dot extends StatelessWidget {
  final int number;
  final bool isCurrent;
  final bool isPast;
  final ColorScheme colorScheme;

  const _Dot({
    super.key,
    required this.number,
    required this.isCurrent,
    required this.isPast,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final size = isCurrent
        ? SlideDotsIndicator.currentDotSize
        : SlideDotsIndicator.dotSize;
    final color = isCurrent
        ? colorScheme.primary
        : isPast
        ? colorScheme.primary.withValues(alpha: 0.5)
        : colorScheme.surfaceContainerHighest;

    return AnimatedContainer(
      duration: SlideDotsIndicator.animationDuration,
      curve: Curves.easeOut,
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: isCurrent
          ? Text(
              '$number',
              style: typ.labelS.copyWith(color: colorScheme.onPrimary),
            )
          : null,
    );
  }
}
