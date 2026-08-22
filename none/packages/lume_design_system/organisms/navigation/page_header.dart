import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/buttons/lume_icon_button.dart';
import 'package:flutter/material.dart';

/// Simple page header: optional back action, title (or [titleWidget]), optional
/// trailing.
///
/// Safe to use as [Scaffold.appBar]: respects the status-bar / notch inset
/// via [SafeArea]. [preferredSize] includes the top inset so Scaffold reserves
/// enough space.
class PageHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? titleWidget;
  final VoidCallback? onBack;
  final Widget? trailing;
  final IconData backIcon;
  final String? backTooltip;

  const PageHeader({
    super.key,
    this.title = '',
    this.titleWidget,
    this.onBack,
    this.trailing,
    this.backIcon = Icons.arrow_back_rounded,
    this.backTooltip,
  });

  static const double toolbarHeight = 56;

  @override
  Size get preferredSize {
    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    final topInset = view.padding.top / view.devicePixelRatio;
    return Size.fromHeight(toolbarHeight + topInset);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: cs.surface,
      elevation: 0,
      child: SafeArea(
        bottom: false,
        child: Container(
          height: toolbarHeight,
          padding: const EdgeInsets.only(
            left: AppSpacings.s,
            right: AppSpacings.l,
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: cs.outlineVariant),
            ),
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
                child: titleWidget ??
                    Text(
                      title,
                      style: typ.body3Semibold,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
              ),
              ?trailing,
            ],
          ),
        ),
      ),
    );
  }
}
