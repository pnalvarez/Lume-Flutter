import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/presentation/screens/trail/home/home_body.dart';
import 'package:lume/layers/presentation/screens/trail/home/home_state.dart';
import 'package:lume/layers/presentation/screens/trail/trail_detail/trail_detail_body.dart';
import 'package:lume/layers/presentation/screens/trail/trail_detail/trail_detail_state.dart';
import 'package:lume_design_system/molecules/loaders/display_as_loader.dart';
import 'package:lume_design_system/theme/lume_theme.dart';

void main() {
  testWidgets('trail home loading shows section title and 4 trail shimmers', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: lumeLightTheme(),
        home: HomeBody(
          state: const HomeState(),
          onRetry: () {},
          onTrailPressed: (_) {},
        ),
      ),
    );

    expect(find.byType(HomeLoadingList), findsOneWidget);
    // Section title + 4 trail cards.
    expect(find.byType(DisplayAsLoader), findsNWidgets(5));
  });

  testWidgets('trail detail loading shows 5 submodule shimmers', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: lumeLightTheme(),
        home: TrailDetailBody(
          state: const TrailDetailState(trailId: 1, title: 'História'),
          onBack: () {},
          onRetry: () {},
          onSubmodulePressed: (_) {},
        ),
      ),
    );

    expect(find.byType(TrailDetailLoadingList), findsOneWidget);
    expect(find.byType(DisplayAsLoader), findsNWidgets(5));
  });
}
