import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/common/strings/trail_strings.dart';
import 'package:lume/layers/presentation/screens/trail/submodule_session/submodule_preview_body.dart';
import 'package:lume_design_system/molecules/progress/slide_dots_indicator.dart';

void main() {
  const slides = ['Intro text', 'Elaboration text', 'Conclusion text'];

  Widget host({
    List<String> slides = slides,
    int index = 0,
    bool showIndicator = true,
    String preview = 'Whole preview',
    VoidCallback? onContinue,
    VoidCallback? onBack,
    ValueChanged<int>? onSlideChanged,
  }) {
    return MaterialApp(
      home: SubmodulePreviewBody(
        isLoading: false,
        title: 'Title',
        preview: preview,
        slides: slides,
        currentSlideIndex: index,
        showSlideIndicator: showIndicator,
        onBack: onBack ?? () {},
        onContinue: onContinue ?? () {},
        onRetry: () {},
        onSlideChanged: onSlideChanged,
      ),
    );
  }

  testWidgets('shows only the current slide text and the indicator', (
    tester,
  ) async {
    await tester.pumpWidget(host(index: 1));
    await tester.pumpAndSettle();

    expect(find.text('Elaboration text'), findsOneWidget);
    expect(find.text('Intro text'), findsNothing);
    expect(find.byType(SlideDotsIndicator), findsOneWidget);
    final indicator = tester.widget<SlideDotsIndicator>(
      find.byType(SlideDotsIndicator),
    );
    expect(indicator.count, 3);
    expect(indicator.currentIndex, 1);
    expect(
      indicator.semanticsLabel,
      trailPreviewSlideLabel(current: 2, total: 3),
    );
  });

  testWidgets('follows the state index when it changes', (tester) async {
    await tester.pumpWidget(host(index: 0));
    await tester.pumpAndSettle();
    expect(find.text('Intro text'), findsOneWidget);

    await tester.pumpWidget(host(index: 2));
    await tester.pumpAndSettle();
    expect(find.text('Conclusion text'), findsOneWidget);
    expect(find.text('Intro text'), findsNothing);
  });

  testWidgets('swiping reports the new slide index', (tester) async {
    final changes = <int>[];
    await tester.pumpWidget(host(onSlideChanged: changes.add));
    await tester.pumpAndSettle();

    await tester.fling(find.text('Intro text'), const Offset(-400, 0), 1000);
    await tester.pumpAndSettle();

    expect(changes, [1]);
  });

  testWidgets('continue calls the callback', (tester) async {
    var continued = 0;
    await tester.pumpWidget(host(onContinue: () => continued++));
    await tester.pumpAndSettle();

    await tester.tap(find.text(trailPreviewContinue));
    expect(continued, 1);
  });

  testWidgets('without slides shows the single preview and no indicator', (
    tester,
  ) async {
    await tester.pumpWidget(host(slides: const [], showIndicator: false));
    await tester.pumpAndSettle();

    expect(find.text('Whole preview'), findsOneWidget);
    expect(find.byType(SlideDotsIndicator), findsNothing);
    expect(find.byType(PageView), findsNothing);
  });

  testWidgets('a single slide hides the indicator', (tester) async {
    await tester.pumpWidget(host(slides: const ['Only'], showIndicator: false));
    await tester.pumpAndSettle();

    expect(find.text('Only'), findsOneWidget);
    expect(find.byType(SlideDotsIndicator), findsNothing);
  });
}
