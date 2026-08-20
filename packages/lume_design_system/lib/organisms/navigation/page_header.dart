import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/buttons/lume_icon_button.dart';
import 'package:flutter/material.dart';

/// Simple page header: optional back action, title, optional trailing.
class PageHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final Widget? trailing;
  final IconData backIcon;
  final String? backTooltip;

  const PageHeader({
    super.key,
    required this.title,
    this.onBack,
    this.trailing,
    this.backIcon = Icons.arrow_back_rounded,
    this.backTooltip,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: cs.surface,
      child: Padding(
        padding: const EdgeInsets.only(
          top: AppSpacings.s,
          left: AppSpacings.s,
          right: AppSpacings.l,
          bottom: AppSpacings.s,
        ),
        child: Row(
          children: [
            if (onBack != null)
              LumeIconButton(
                icon: backIcon,
                onPressed: onBack,
                size: LumeIconButtonSize.sm,
                tooltip: backTooltip,
              )
            else
              const SizedBox(width: AppSpacings.s),
            Expanded(
              child: Text(
                title,
                style: typ.subtitleM.copyWith(color: cs.onSurface),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            ?trailing,
          ],
        ),
      ),
    );
  }
}
