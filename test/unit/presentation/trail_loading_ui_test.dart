import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/common/strings/trail_strings.dart';
import 'package:lume/layers/presentation/screens/trail/home/home_body.dart';
import 'package:lume/layers/presentation/screens/trail/home/home_state.dart';
import 'package:lume/layers/presentation/screens/trail/trail_detail/trail_detail_body.dart';
import 'package:lume/layers/presentation/screens/trail/trail_detail/trail_detail_state.dart';
import 'package:lume_design_system/atoms/colors/colors.dart';
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

  testWidgets('completed submodule keeps brand chrome and a green check icon', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: lumeLightTheme(),
        home: Scaffold(
          body: TrailDetailSubmoduleListItem(
            submodule: const TrailDetailSubmoduleRowUi(
              id: 1,
              title: 'Completed submodule',
              gamesCount: 4,
              isCompleted: true,
            ),
            onPressed: () {},
          ),
        ),
      ),
    );

    expect(find.textContaining(trailDetailSubmoduleDone), findsOneWidget);
    final check = tester.widget<Icon>(find.byIcon(Icons.check_circle_rounded));
    expect(check.color, AppColors.Success.onSuccess);
  });

  testWidgets('retry submodule uses accent hint and trailing warning icon', (
    tester,
  ) async {
    const hint = 'Acerte pelo menos 3 de 4 jogos';
    await tester.pumpWidget(
      MaterialApp(
        theme: lumeLightTheme(),
        home: Scaffold(
          body: TrailDetailSubmoduleListItem(
            submodule: const TrailDetailSubmoduleRowUi(
              id: 2,
              title: 'Retry submodule',
              gamesCount: 4,
              isCompleted: false,
              needsRetry: true,
              unlockHint: hint,
            ),
            onPressed: () {},
          ),
        ),
      ),
    );

    expect(find.textContaining(trailDetailSubmoduleRetry), findsOneWidget);
    expect(find.text(hint), findsOneWidget);
    final warning = tester.widget<Icon>(
      find.byIcon(Icons.warning_amber_rounded),
    );
    expect(warning.color, AppColors.Accent.onAccent);
  });
}
