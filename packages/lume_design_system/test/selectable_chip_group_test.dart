import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume_design_system/molecules/chips/selectable_chip_group.dart';
import 'package:lume_design_system/theme/lume_theme.dart';

void main() {
  const options = [
    SelectableChipOption(id: '1', label: 'História'),
    SelectableChipOption(id: '2', label: 'Ciência'),
  ];

  testWidgets('renders options and reports toggles', (tester) async {
    String? toggled;
    await tester.pumpWidget(
      MaterialApp(
        theme: lumeLightTheme(),
        home: Scaffold(
          body: SelectableChipGroup<String>(
            options: options,
            selectedIds: const {'1'},
            onToggle: (id) => toggled = id,
          ),
        ),
      ),
    );

    expect(find.text('História'), findsOneWidget);
    expect(find.text('Ciência'), findsOneWidget);
    expect(find.byType(Checkbox), findsNothing);

    await tester.tap(find.text('Ciência'));
    expect(toggled, '2');
  });

  testWidgets('select-all row toggles when provided', (tester) async {
    var selectAllTapped = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: lumeLightTheme(),
        home: Scaffold(
          body: SelectableChipGroup<String>(
            options: options,
            selectedIds: const {'1', '2'},
            onToggle: (_) {},
            selectAllLabel: 'Selecionar todas',
            onSelectAllToggled: () => selectAllTapped = true,
          ),
        ),
      ),
    );

    expect(find.text('Selecionar todas'), findsOneWidget);
    expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, isTrue);

    await tester.tap(find.text('Selecionar todas'));
    expect(selectAllTapped, isTrue);
  });
}
