import 'package:flutter/material.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/organisms/tabs/tab_container.dart';
import 'package:lume_design_system/organisms/tabs/tab_container_layout_type.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

const _fixedTabs = ['Trilha', 'Jogos', 'Progresso'];

const _scrollableTabs = [
  'Trilha',
  'Jogos',
  'Progresso',
  'Conquistas',
  'Perfil',
  'Configurações',
  'Histórico',
];

@widgetbook.UseCase(
  name: 'Fixed',
  type: TabContainer,
  path: '[Lume]/[Organisms]/TabContainer',
)
Widget tabContainerFixed(BuildContext context) {
  return const _TabContainerPreview(
    tabs: _fixedTabs,
    layoutType: TabContainerLayoutType.fixed,
  );
}

@widgetbook.UseCase(
  name: 'Scrollable',
  type: TabContainer,
  path: '[Lume]/[Organisms]/TabContainer',
)
Widget tabContainerScrollable(BuildContext context) {
  return const _TabContainerPreview(
    tabs: _scrollableTabs,
    layoutType: TabContainerLayoutType.scrollable,
  );
}

class _TabContainerPreview extends StatefulWidget {
  const _TabContainerPreview({required this.tabs, required this.layoutType});

  final List<String> tabs;
  final TabContainerLayoutType layoutType;

  @override
  State<_TabContainerPreview> createState() => _TabContainerPreviewState();
}

class _TabContainerPreviewState extends State<_TabContainerPreview> {
  late String _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.tabs.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabContainer(
        tabs: widget.tabs,
        selectedTab: _selected,
        layoutType: widget.layoutType,
        onTabSelected: (tab) => setState(() => _selected = tab),
        child: Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacings.xl2),
            child: Text(_selected),
          ),
        ),
      ),
    );
  }
}
