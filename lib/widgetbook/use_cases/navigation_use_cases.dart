import 'package:flutter/material.dart';
import 'package:lume_design_system/organisms/navigation/bottom_nav_bar.dart';
import 'package:lume_design_system/organisms/navigation/page_header.dart';
import 'package:lume_design_system/organisms/navigation/screen_header.dart';
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
        BottomNavItem(icon: Icons.home_rounded, label: 'Trilha'),
        BottomNavItem(icon: Icons.sports_esports_rounded, label: 'Jogos'),
        BottomNavItem(icon: Icons.bar_chart_rounded, label: 'Progresso'),
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

@widgetbook.UseCase(name: 'Default', type: ScreenHeader)
Widget screenHeaderDefault(BuildContext context) {
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Recuperação de senha',
  );
  return Scaffold(
    body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ScreenHeader(title: title, onBack: () {}),
          const Expanded(child: SizedBox.shrink()),
        ],
      ),
    ),
  );
}
