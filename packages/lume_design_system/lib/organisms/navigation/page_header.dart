import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/buttons/lume_icon_button.dart';
import 'package:flutter/material.dart';

/// How [PageHeader] places its title relative to the back control.
enum PageHeaderTitleLayout {
  /// Title sits on the same row as the back button (default toolbar).
  inline,

  /// Larger title sits below the back button row.
  stacked,
}

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
  final PageHeaderTitleLayout titleLayout;

  /// Content height under the status-bar inset.
  ///
  /// Defaults to [defaultToolbarHeight] for [PageHeaderTitleLayout.inline]
  /// and [stackedToolbarHeight] for [PageHeaderTitleLayout.stacked].
  final double? toolbarHeight;

  const PageHeader({
    super.key,
    this.title = '',
    this.titleWidget,
    this.onBack,
    this.trailing,
    this.backIcon = Icons.arrow_back_rounded,
    this.backTooltip,
    this.titleLayout = PageHeaderTitleLayout.inline,
    this.toolbarHeight,
  });

  static const double defaultToolbarHeight = 56;

  /// Fits the back row plus up to two lines of [typ.headlineM].
  static const double stackedToolbarHeight = 140;

  double get _resolvedToolbarHeight =>
      toolbarHeight ??
      (titleLayout == PageHeaderTitleLayout.stacked
          ? stackedToolbarHeight
          : defaultToolbarHeight);

  @override
  Size get preferredSize {
    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    final topInset = view.padding.top / view.devicePixelRatio;
    return Size.fromHeight(_resolvedToolbarHeight + topInset);
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
          height: _resolvedToolbarHeight,
          padding: EdgeInsets.only(
            left: AppSpacings.s,
            right: AppSpacings.l,
            bottom: titleLayout == PageHeaderTitleLayout.stacked
                ? AppSpacings.m
                : 0,
          ),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: cs.outlineVariant)),
          ),
          child: switch (titleLayout) {
            PageHeaderTitleLayout.inline => _InlineRow(
              title: title,
              titleWidget: titleWidget,
              onBack: onBack,
              trailing: trailing,
              backIcon: backIcon,
              backTooltip: backTooltip,
            ),
            PageHeaderTitleLayout.stacked => _StackedColumn(
              title: title,
              titleWidget: titleWidget,
              onBack: onBack,
              trailing: trailing,
              backIcon: backIcon,
              backTooltip: backTooltip,
            ),
          },
        ),
      ),
    );
  }
}

class _InlineRow extends StatelessWidget {
  const _InlineRow({
    required this.title,
    required this.titleWidget,
    required this.onBack,
    required this.trailing,
    required this.backIcon,
    required this.backTooltip,
  });

  final String title;
  final Widget? titleWidget;
  final VoidCallback? onBack;
  final Widget? trailing;
  final IconData backIcon;
  final String? backTooltip;

  @override
  Widget build(BuildContext context) {
    return Row(
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
          child:
              titleWidget ??
              Text(
                title,
                style: typ.body3Semibold,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
        ),
        ?trailing,
      ],
    );
  }
}

class _StackedColumn extends StatelessWidget {
  const _StackedColumn({
    required this.title,
    required this.titleWidget,
    required this.onBack,
    required this.trailing,
    required this.backIcon,
    required this.backTooltip,
  });

  final String title;
  final Widget? titleWidget;
  final VoidCallback? onBack;
  final Widget? trailing;
  final IconData backIcon;
  final String? backTooltip;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hasTitle = titleWidget != null || title.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
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
              const SizedBox(height: AppSpacings.xl5),
            const Spacer(),
            ?trailing,
          ],
        ),
        if (hasTitle) ...[
          const SizedBox(height: AppSpacings.s),
          Padding(
            padding: const EdgeInsets.only(left: AppSpacings.l),
            child:
                titleWidget ??
                Text(
                  title,
                  style: typ.headlineM.copyWith(color: cs.onSurface),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
          ),
        ],
      ],
    );
  }
}
