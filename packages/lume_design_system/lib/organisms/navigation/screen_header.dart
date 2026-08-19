import 'package:lume_design_system/atoms/spacing/sizes.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/buttons/lume_icon_button.dart';
import 'package:flutter/material.dart';

/// Stacked screen header: back control on the first row, title below.
class ScreenHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;
  final Widget? trailing;
  final IconData backIcon;
  final String? backTooltip;

  const ScreenHeader({
    super.key,
    required this.title,
    this.onBack,
    this.trailing,
    this.backIcon = Icons.arrow_back_rounded,
    this.backTooltip,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacings.s,
        AppSpacings.s,
        AppSpacings.xl2,
        AppSpacings.m,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (onBack != null)
                LumeIconButton(
                  icon: backIcon,
                  onPressed: onBack,
                  size: LumeIconButtonSize.sm,
                  tooltip: backTooltip,
                )
              else
                const SizedBox(height: AppSizes.touchMin * 0.75),
              const Spacer(),
              ?trailing,
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacings.l,
              AppSpacings.s,
              0,
              0,
            ),
            child: Text(
              title,
              style: typ.headlineXs.copyWith(color: cs.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}
