import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume_design_system/molecules/chips/badge_chip.dart';
import 'package:lume_design_system/theme/lume_theme.dart';

void main() {
  testWidgets('BadgeChip shows label and optional badge', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: lumeLightTheme(),
        home: Scaffold(
          body: BadgeChip(
            label: 'Classificação',
            backgroundColor: Colors.white,
            borderColor: Colors.grey,
            foregroundColor: Colors.black,
            badgeLabel: '2',
            onTap: () {},
          ),
        ),
      ),
    );

    expect(find.text('Classificação'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
  });

  testWidgets('BadgeChip hides badge when label is null', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: lumeLightTheme(),
        home: Scaffold(
          body: BadgeChip(
            label: 'Previsão',
            backgroundColor: Colors.white,
            borderColor: Colors.grey,
            foregroundColor: Colors.black,
            onTap: () {},
          ),
        ),
      ),
    );

    expect(find.text('Previsão'), findsOneWidget);
    expect(find.text('1'), findsNothing);
  });
}
