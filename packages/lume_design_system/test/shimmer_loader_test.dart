import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume_design_system/molecules/loaders/display_as_loader.dart';
import 'package:lume_design_system/molecules/loaders/shimmer_box.dart';
import 'package:lume_design_system/theme/lume_theme.dart';
import 'package:shimmer/shimmer.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: lumeLightTheme(),
  home: Scaffold(body: Center(child: child)),
);

void main() {
  group('ShimmerBox', () {
    testWidgets('builds with explicit size', (tester) async {
      await tester.pumpWidget(
        _wrap(const ShimmerBox(width: 120, height: 24)),
      );

      expect(find.byType(ShimmerBox), findsOneWidget);
      expect(find.byType(Shimmer), findsOneWidget);

      final box = tester.getSize(find.byType(ShimmerBox));
      expect(box.width, 120);
      expect(box.height, 24);
    });

    testWidgets('expands when width is null', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const SizedBox(
            width: 200,
            child: ShimmerBox(height: 10),
          ),
        ),
      );

      final box = tester.getSize(find.byType(ShimmerBox));
      expect(box.width, 200);
      expect(box.height, 10);
    });

    testWidgets('supports circle shape', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const ShimmerBox(
            width: 40,
            height: 40,
            shape: BoxShape.circle,
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(ShimmerBox),
          matching: find.byType(Container),
        ),
      );
      expect(container.decoration, isA<BoxDecoration>());
      expect((container.decoration! as BoxDecoration).shape, BoxShape.circle);
    });
  });

  group('DisplayAsLoader', () {
    testWidgets('matches child size', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const DisplayAsLoader(
            child: SizedBox(width: 160, height: 48, child: Text('Hidden')),
          ),
        ),
      );

      expect(find.byType(DisplayAsLoader), findsOneWidget);
      expect(find.byType(Shimmer), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (w) => w is Visibility && w.visible == false,
        ),
        findsOneWidget,
      );

      final size = tester.getSize(find.byType(DisplayAsLoader));
      expect(size.width, 160);
      expect(size.height, 48);
    });

    testWidgets('shows child when disabled', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const DisplayAsLoader(
            enabled: false,
            child: Text('Ready'),
          ),
        ),
      );

      expect(find.text('Ready'), findsOneWidget);
      expect(find.byType(Shimmer), findsNothing);
    });
  });
}
