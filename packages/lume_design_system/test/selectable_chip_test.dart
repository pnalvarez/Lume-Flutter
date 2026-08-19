import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume_design_system/molecules/chips/selectable_chip.dart';
import 'package:lume_design_system/theme/lume_theme.dart';

void main() {
  testWidgets('SelectableChip renders label and reports taps', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: lumeLightTheme(),
        home: Scaffold(
          body: SelectableChip(
            label: 'História',
            selected: false,
            onPressed: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.text('História'), findsOneWidget);
    await tester.tap(find.text('História'));
    expect(tapped, isTrue);
  });
}
