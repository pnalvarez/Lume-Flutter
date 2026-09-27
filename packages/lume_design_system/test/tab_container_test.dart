import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume_design_system/organisms/tabs/tab_container.dart';
import 'package:lume_design_system/organisms/tabs/tab_container_layout_type.dart';
import 'package:lume_design_system/theme/lume_theme.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: lumeLightTheme(),
  home: Scaffold(body: child),
);

void main() {
  const tabs = ['Trilha', 'Jogos', 'Progresso'];

  testWidgets('selected tab is primary and underlined; others are muted', (
    tester,
  ) async {
    final colorScheme = lumeLightTheme().colorScheme;
    final primary = colorScheme.primary;

    await tester.pumpWidget(
      _wrap(
        const TabContainer(
          tabs: tabs,
          selectedTab: 'Jogos',
          onTabSelected: null,
          child: Text('Conteúdo'),
        ),
      ),
    );

    expect(tester.widget<Text>(find.text('Jogos')).style?.color, primary);
    for (final label in ['Trilha', 'Progresso']) {
      final text = tester.widget<Text>(find.text(label));
      expect(text.style?.color, colorScheme.onSurfaceVariant);
    }

    final underlines = tester
        .widgetList<Container>(
          find.descendant(
            of: find.byType(TabContainer),
            matching: find.byType(Container),
          ),
        )
        .toList();
    expect(underlines.map((bar) => bar.color), [
      Colors.transparent,
      primary,
      Colors.transparent,
    ]);
    expect(find.text('Conteúdo'), findsOneWidget);
  });

  testWidgets('fixed tabs share the width and report a new selection', (
    tester,
  ) async {
    String? selected;
    await tester.pumpWidget(
      _wrap(
        TabContainer(
          tabs: tabs,
          selectedTab: 'Trilha',
          onTabSelected: (tab) => selected = tab,
          child: const SizedBox.shrink(),
        ),
      ),
    );

    final width = tester.getRect(find.byType(InkWell).at(0)).width;
    expect(
      tester.getRect(find.byType(InkWell).at(1)).width,
      closeTo(width, 0.1),
    );
    expect(
      tester.getRect(find.byType(InkWell).at(2)).width,
      closeTo(width, 0.1),
    );

    await tester.tap(find.text('Trilha'));
    expect(selected, isNull);

    await tester.tap(find.text('Progresso'));
    expect(selected, 'Progresso');
  });

  testWidgets('scrollable tabs overflow and can be selected', (tester) async {
    await tester.binding.setSurfaceSize(const Size(240, 400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    String? selected;
    await tester.pumpWidget(
      _wrap(
        TabContainer(
          tabs: const [
            'Trilha',
            'Jogos',
            'Progresso',
            'Conquistas',
            'Configurações',
          ],
          selectedTab: 'Trilha',
          layoutType: TabContainerLayoutType.scrollable,
          onTabSelected: (tab) => selected = tab,
          child: const SizedBox.shrink(),
        ),
      ),
    );

    final scrollable = tester.widget<Scrollable>(find.byType(Scrollable));
    expect(scrollable.axisDirection, AxisDirection.right);

    final view = tester.widget<SingleChildScrollView>(
      find.byType(SingleChildScrollView),
    );
    expect(view.scrollDirection, Axis.horizontal);

    await tester.scrollUntilVisible(
      find.text('Configurações'),
      80,
      scrollable: find.byType(Scrollable),
    );
    await tester.tap(find.text('Configurações'));
    expect(selected, 'Configurações');
  });
}
