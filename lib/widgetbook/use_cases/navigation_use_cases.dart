import 'package:flutter/material.dart';
import 'package:lume_design_system/molecules/buttons/lume_icon_button.dart';
import 'package:lume_design_system/organisms/navigation/bottom_nav_bar.dart';
import 'package:lume_design_system/organisms/navigation/brand_header.dart';
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

@widgetbook.UseCase(name: 'Stacked title', type: PageHeader)
Widget pageHeaderStackedTitle(BuildContext context) {
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'O que você quer aprender?',
  );
  return Scaffold(
    appBar: PageHeader(
      title: title,
      onBack: () {},
      titleLayout: PageHeaderTitleLayout.stacked,
    ),
    body: const SizedBox.shrink(),
  );
}

@widgetbook.UseCase(name: 'Progress with close', type: PageHeader)
Widget pageHeaderProgressWithClose(BuildContext context) {
  return Scaffold(
    appBar: PageHeader(
      titleWidget: const Padding(
        padding: EdgeInsets.only(right: 8),
        child: LinearProgressIndicator(value: 0.4, minHeight: 8),
      ),
      trailing: LumeIconButton(
        icon: Icons.close_rounded,
        onPressed: () {},
        size: LumeIconButtonSize.sm,
      ),
    ),
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

@widgetbook.UseCase(name: 'Default', type: BrandHeader)
Widget brandHeaderDefault(BuildContext context) {
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Olá, Ana',
  );
  final subtitle = context.knobs.string(
    label: 'Subtitle',
    initialValue: 'Vamos aprender algo novo hoje?',
  );
  return Scaffold(
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BrandHeader(title: title, subtitle: subtitle),
        const Expanded(child: SizedBox.shrink()),
      ],
    ),
  );
}

@widgetbook.UseCase(name: 'Title only', type: BrandHeader)
Widget brandHeaderTitleOnly(BuildContext context) {
  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Olá, Ana',
  );
  return Scaffold(
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BrandHeader(title: title),
        const Expanded(child: SizedBox.shrink()),
      ],
    ),
  );
}
