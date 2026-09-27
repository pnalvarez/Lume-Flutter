import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume_design_system/organisms/selector/selector.dart';
import 'package:lume_design_system/theme/lume_theme.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: lumeLightTheme(),
  home: Scaffold(body: child),
);

void main() {
  const options = ['História', 'Ciência'];

  testWidgets('button is white and shows a trailing chevron when asked', (
    tester,
  ) async {
    final white = lumeLightTheme().colorScheme.surfaceContainerLowest;

    await tester.pumpWidget(
      _wrap(
        Selector(
          bottomsheetTitle: 'Escolha uma categoria',
          selectedOption: 'História',
          hasChevronDown: true,
          options: options,
          onSelectOption: (_) {},
        ),
      ),
    );

    final material = tester.widget<Material>(
      find.descendant(
        of: find.byType(Selector),
        matching: find.byType(Material),
      ),
    );
    expect(material.color, white);
    expect(find.text('História'), findsOneWidget);
    expect(find.byIcon(Icons.keyboard_arrow_down_rounded), findsOneWidget);
  });

  testWidgets('hides the chevron when hasChevronDown is false', (tester) async {
    await tester.pumpWidget(
      _wrap(
        Selector(
          bottomsheetTitle: 'Escolha uma categoria',
          selectedOption: 'História',
          hasChevronDown: false,
          options: options,
          onSelectOption: (_) {},
        ),
      ),
    );

    expect(find.byIcon(Icons.keyboard_arrow_down_rounded), findsNothing);
  });

  testWidgets('selecting a sheet option reports it and closes the sheet', (
    tester,
  ) async {
    String? selected;
    await tester.pumpWidget(
      _wrap(
        Selector(
          bottomsheetTitle: 'Escolha uma categoria',
          selectedOption: 'História',
          hasChevronDown: true,
          options: options,
          onSelectOption: (option) => selected = option,
        ),
      ),
    );

    await tester.tap(find.text('História').first);
    await tester.pumpAndSettle();

    expect(find.text('Escolha uma categoria'), findsOneWidget);
    expect(find.text('História'), findsNWidgets(2));
    expect(find.text('Ciência'), findsOneWidget);

    await tester.tap(find.text('Ciência'));
    await tester.pumpAndSettle();

    expect(selected, 'Ciência');
    expect(find.text('Escolha uma categoria'), findsNothing);
  });
}
