import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/common/strings/achievement_strings.dart';
import 'package:lume/layers/presentation/screens/achievements/achievement_list_item.dart';
import 'package:lume/layers/presentation/screens/achievements/achievements_body.dart';
import 'package:lume/layers/presentation/screens/achievements/achievements_state.dart';
import 'package:lume_design_system/organisms/selector/selector.dart';
import 'package:lume_design_system/organisms/tabs/tab_container.dart';
import 'package:lume_design_system/theme/lume_theme.dart';

void main() {
  const completed = AchievementListItemUi(
    id: 'done',
    title: 'Primeiro passo',
    description: 'Complete 1 submódulo.',
    status: AchievementListItemStatus.completed,
    progress: 1,
    target: 1,
  );
  const locked = AchievementListItemUi(
    id: 'locked',
    title: 'Arcade 50',
    description: 'Alcance 50 pontos.',
    status: AchievementListItemStatus.locked,
    progress: 0,
    target: 50,
  );

  Widget wrap(
    AchievementsState state, {
    ValueChanged<AchievementListItemStatus>? onFilter,
  }) {
    return MaterialApp(
      theme: lumeLightTheme(),
      home: AchievementsBody(
        state: state,
        onRetry: () {},
        onFilterToggled: onFilter ?? (_) {},
        onClearFilters: () {},
      ),
    );
  }

  testWidgets('chips layout keeps every category chip', (tester) async {
    await tester.pumpWidget(
      wrap(
        const AchievementsState(
          status: AchievementsStatus.ready,
          items: [completed, locked],
        ),
      ),
    );

    expect(find.byType(TabContainer), findsNothing);
    expect(find.byType(Selector), findsNothing);
    expect(find.text(achievementsFilterCompleted), findsOneWidget);
    expect(find.text(achievementsFilterInProgress), findsOneWidget);
    expect(find.text(achievementsFilterLocked), findsOneWidget);
    expect(find.text('Primeiro passo'), findsOneWidget);
    expect(find.text('Arcade 50'), findsOneWidget);
  });

  testWidgets('tabs layout shows one category and reports the tapped tab', (
    tester,
  ) async {
    AchievementListItemStatus? selected;
    await tester.pumpWidget(
      wrap(
        const AchievementsState(
          status: AchievementsStatus.ready,
          items: [completed, locked],
          filterVariation: AchievementListFilterVariation.tabs,
          selectedStatusFilters: {AchievementListItemStatus.completed},
        ),
        onFilter: (status) => selected = status,
      ),
    );

    expect(find.byType(TabContainer), findsOneWidget);
    expect(find.text('Primeiro passo'), findsOneWidget);
    expect(find.text('Arcade 50'), findsNothing);

    await tester.tap(find.text(achievementsFilterLocked));
    await tester.pump();
    expect(selected, AchievementListItemStatus.locked);
  });

  testWidgets('selector layout opens the sheet for the selected category', (
    tester,
  ) async {
    AchievementListItemStatus? selected;
    await tester.pumpWidget(
      wrap(
        const AchievementsState(
          status: AchievementsStatus.ready,
          items: [completed, locked],
          filterVariation: AchievementListFilterVariation.selector,
          selectedStatusFilters: {AchievementListItemStatus.completed},
        ),
        onFilter: (status) => selected = status,
      ),
    );

    expect(find.byType(Selector), findsOneWidget);
    expect(find.text('Primeiro passo'), findsOneWidget);
    expect(find.text('Arcade 50'), findsNothing);

    await tester.tap(find.text(achievementsFilterCompleted));
    await tester.pumpAndSettle();
    expect(find.text(achievementsFilterSheetTitle), findsOneWidget);

    await tester.tap(find.text(achievementsFilterLocked));
    await tester.pumpAndSettle();
    expect(selected, AchievementListItemStatus.locked);
  });

  testWidgets('clear filters stays on the chips empty state', (tester) async {
    await tester.pumpWidget(
      wrap(
        const AchievementsState(
          status: AchievementsStatus.ready,
          items: [locked],
          selectedStatusFilters: {AchievementListItemStatus.completed},
        ),
      ),
    );
    expect(find.text(achievementsFilterClearFilters), findsOneWidget);

    await tester.pumpWidget(
      wrap(
        const AchievementsState(
          status: AchievementsStatus.ready,
          items: [locked],
          filterVariation: AchievementListFilterVariation.tabs,
          selectedStatusFilters: {AchievementListItemStatus.completed},
        ),
      ),
    );
    expect(find.text(achievementsFilterEmpty), findsOneWidget);
    expect(find.text(achievementsFilterClearFilters), findsNothing);
  });
}
