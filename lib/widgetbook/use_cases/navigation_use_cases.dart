import 'package:flutter/material.dart';
import 'package:lume_design_system/organisms/navigation/bottom_nav_bar.dart';
import 'package:lume_design_system/organisms/navigation/page_header.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Interactive', type: BottomNavBar)
Widget bottomNavInteractive(BuildContext context) {
  final selected = context.knobs.int.slider(
    label: 'Selected',
    initialValue: 0,
    min: 0,
    max: 2,
  );
  return Scaffold(
    body: const Center(child: Text('Content')),
    bottomNavigationBar: BottomNavBar(
      selectedIndex: selected,
      onSelected: (_) {},
      items: const [
        BottomNavItem(icon: Icons.route_rounded, label: 'Path'),
        BottomNavItem(icon: Icons.sports_esports_rounded, label: 'Play'),
        BottomNavItem(icon: Icons.bar_chart_rounded, label: 'Stats'),
      ],
    ),
  );
}

@widgetbook.UseCase(name: 'Default', type: PageHeader)
Widget pageHeaderDefault(BuildContext context) {
  final title = context.knobs.string(label: 'Title', initialValue: 'Session');
  return Scaffold(
    appBar: PageHeader(title: title, onBack: () {}),
    body: const SizedBox.shrink(),
  );
}
