import 'package:lume_design_system/atoms/spacing/sizes.dart';
import 'package:flutter/material.dart';

/// Circular loader size.
enum CircularLoaderSize { sm, md, lg }

/// Spinning circular progress indicator.
///
/// Derived from [LoadingSpinner.tsx] in the Lume web app.
class CircularLoader extends StatelessWidget {
  final CircularLoaderSize size;
  final Color? color;
  final bool fullPage;

  const CircularLoader({
    super.key,
    this.size = CircularLoaderSize.md,
    this.color,
    this.fullPage = false,
  });

  double get _dimension => switch (size) {
        CircularLoaderSize.sm => AppSizes.iconS,
        CircularLoaderSize.md => AppSizes.iconL,
        CircularLoaderSize.lg => AppSizes.iconXl + 8,
      };

  double get _stroke => switch (size) {
        CircularLoaderSize.sm => 2,
        CircularLoaderSize.md => 2.5,
        CircularLoaderSize.lg => 3,
      };

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final spinner = SizedBox.square(
      dimension: _dimension,
      child: CircularProgressIndicator(
        strokeWidth: _stroke,
        valueColor: AlwaysStoppedAnimation(color ?? cs.primary),
        backgroundColor: (color ?? cs.primary).withValues(alpha: 0.2),
      ),
    );

    if (!fullPage) return spinner;

    return ColoredBox(
      color: cs.surface,
      child: Center(child: spinner),
    );
  }
}
