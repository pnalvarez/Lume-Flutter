import 'package:flutter/material.dart';
import 'package:lume_design_system/atoms/spacing/sizes.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/organisms/tabs/tab_container_layout_type.dart';

const double _kUnderlineThickness = 2;

/// Horizontal text tabs on a transparent bar, with the selected tab underlined.
///
/// [TabContainerLayoutType.fixed] gives every tab an equal share of the width.
/// [TabContainerLayoutType.scrollable] sizes tabs to their labels and scrolls
/// when they overflow.
final class TabContainer extends StatelessWidget {
  final List<String> tabs;
  final String selectedTab;
  final TabContainerLayoutType layoutType;
  final ValueChanged<String>? onTabSelected;
  final Widget child;

  const TabContainer({
    super.key,
    required this.tabs,
    required this.selectedTab,
    this.layoutType = .fixed,
    this.onTabSelected,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _TabBar(
          tabs: tabs,
          selectedTab: selectedTab,
          layoutType: layoutType,
          onTabSelected: onTabSelected,
        ),
        Expanded(child: child),
      ],
    );
  }
}

class _TabBar extends StatelessWidget {
  const _TabBar({
    required this.tabs,
    required this.selectedTab,
    required this.layoutType,
    required this.onTabSelected,
  });

  final List<String> tabs;
  final String selectedTab;
  final TabContainerLayoutType layoutType;
  final ValueChanged<String>? onTabSelected;

  @override
  Widget build(BuildContext context) {
    final options = [
      for (final tab in tabs)
        _TabOption(
          label: tab,
          selected: tab == selectedTab,
          fillWidth: layoutType == TabContainerLayoutType.fixed,
          onTap: _onTap(tab),
        ),
    ];

    return Material(
      type: MaterialType.transparency,
      child: switch (layoutType) {
        TabContainerLayoutType.fixed => Row(
          children: [for (final option in options) Expanded(child: option)],
        ),
        TabContainerLayoutType.scrollable => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: options),
        ),
      },
    );
  }

  VoidCallback? _onTap(String tab) {
    final onTabSelected = this.onTabSelected;
    if (onTabSelected == null || tab == selectedTab) return null;
    return () => onTabSelected(tab);
  }
}

class _TabOption extends StatelessWidget {
  const _TabOption({
    required this.label,
    required this.selected,
    required this.fillWidth,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool fillWidth;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final primary = colorScheme.primary;
    final labelColumn = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: (selected ? typ.body4Semibold : typ.body4Medium).copyWith(
            color: selected ? primary : colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacings.xs),
        Container(
          height: _kUnderlineThickness,
          color: selected ? primary : Colors.transparent,
        ),
      ],
    );

    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: AppSizes.touchMin),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacings.m),
          child: fillWidth ? labelColumn : IntrinsicWidth(child: labelColumn),
        ),
      ),
    );
  }
}
