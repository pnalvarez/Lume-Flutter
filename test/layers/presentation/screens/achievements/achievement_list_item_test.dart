import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/common/strings/achievement_strings.dart';
import 'package:lume/layers/presentation/screens/achievements/achievement_list_item.dart';
import 'package:lume_design_system/theme/lume_theme.dart';

void main() {
  test('achievementProgressCaption formats progress over target', () {
    expect(achievementProgressCaption(3, 5), '3 / 5');
  });

  Widget wrap(Widget child) => MaterialApp(
    theme: lumeLightTheme(),
    home: Scaffold(body: child),
  );

  testWidgets('locked shows lock badge and dimmed content', (tester) async {
    await tester.pumpWidget(
      wrap(
        const AchievementListItem(
          title: 'Explorador',
          description: 'Complete 5 submódulos.',
          status: AchievementListItemStatus.locked,
          progress: 0,
          target: 5,
        ),
      ),
    );

    expect(find.text('Explorador'), findsOneWidget);
    expect(find.text('0 / 5'), findsOneWidget);
    expect(find.byIcon(Icons.lock_rounded), findsOneWidget);
  });

  testWidgets('in-progress shows progress caption', (tester) async {
    await tester.pumpWidget(
      wrap(
        const AchievementListItem(
          title: 'Explorador',
          description: 'Complete 5 submódulos.',
          status: AchievementListItemStatus.inProgress,
          progress: 3,
          target: 5,
        ),
      ),
    );

    expect(find.text('3 / 5'), findsOneWidget);
    expect(find.byIcon(Icons.lock_rounded), findsNothing);
    expect(find.byIcon(Icons.check_circle_rounded), findsNothing);
  });

  testWidgets('completed shows check and trophy affordance', (tester) async {
    await tester.pumpWidget(
      wrap(
        const AchievementListItem(
          title: 'Primeiro passo',
          description: 'Complete 1 submódulo.',
          status: AchievementListItemStatus.completed,
          progress: 1,
          target: 1,
        ),
      ),
    );

    expect(find.text('1 / 1'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
    expect(find.byIcon(Icons.emoji_events_rounded), findsWidgets);
  });
}
