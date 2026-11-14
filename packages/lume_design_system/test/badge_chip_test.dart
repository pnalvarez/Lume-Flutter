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

  group('BadgeChip.custom', () {
    test('tryParseHex accepts 6 and 8 digit values with or without #', () {
      expect(BadgeChip.tryParseHex('#8E44AD'), const Color(0xFF8E44AD));
      expect(BadgeChip.tryParseHex('8e44ad'), const Color(0xFF8E44AD));
      expect(BadgeChip.tryParseHex('#808E44AD'), const Color(0x808E44AD));
    });

    test('tryParseHex rejects invalid values', () {
      expect(BadgeChip.tryParseHex(''), isNull);
      expect(BadgeChip.tryParseHex('#12345'), isNull);
      expect(BadgeChip.tryParseHex('#GGGGGG'), isNull);
    });

    testWidgets('paints hex background with black content', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: lumeLightTheme(),
          home: Scaffold(
            body: BadgeChip.custom(
              label: 'Roma',
              hex: '#F4A261',
              badgeLabel: '3',
              onTap: () {},
            ),
          ),
        ),
      );

      final material = tester.widget<Material>(
        find.descendant(
          of: find.byType(BadgeChip),
          matching: find.byType(Material),
        ),
      );
      expect(material.color, const Color(0xFFF4A261));

      final label = tester.widget<Text>(find.text('Roma'));
      expect(label.style?.color, Colors.black);
      final badge = tester.widget<Text>(find.text('3'));
      expect(badge.style?.color, Colors.black);
    });

    test('invalid hex asserts in debug', () {
      expect(
        () => BadgeChip.custom(label: 'x', hex: 'nope'),
        throwsAssertionError,
      );
    });
  });
}
