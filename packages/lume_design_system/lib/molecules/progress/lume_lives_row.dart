import 'package:flutter/material.dart';
import 'package:lume_design_system/atoms/colors/colors.dart';
import 'package:lume_design_system/atoms/spacing/sizes.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';

/// Remaining attempts as a row of hearts: [remaining] filled, the rest outlined.
class LumeLivesRow extends StatelessWidget {
  const LumeLivesRow({
    super.key,
    required this.total,
    required this.remaining,
    this.size = AppSizes.iconS,
    this.mainAxisAlignment = MainAxisAlignment.center,
  });

  final int total;
  final int remaining;
  final double size;
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final filled = remaining.clamp(0, total);

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: mainAxisAlignment,
      children: [
        for (var i = 0; i < total; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacings.xs),
          Icon(
            i < filled ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            size: size,
            color: AppColors.Extra.pinkDeep,
          ),
        ],
      ],
    );
  }
}
