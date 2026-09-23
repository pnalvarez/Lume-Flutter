import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/common/strings/achievement_strings.dart';
import 'package:lume/layers/presentation/shared/achievement_snack_bar.dart';
import 'package:lume_design_system/atoms/colors/colors.dart';
import 'package:lume_design_system/organisms/feedback/lume_snack_bar.dart';
import 'package:lume_design_system/theme/lume_theme.dart';

void main() {
  test('achievementUnlockedSnackBarText formats name', () {
    expect(
      achievementUnlockedSnackBarText('Primeiro passo'),
      'Achievement unlocked: Primeiro passo',
    );
  });

  testWidgets('showAchievementUnlockedSnackBar shows brand toast', (
    tester,
  ) async {
    addTearDown(resetLumeSnackBarForTest);

    late BuildContext hostContext;
    await tester.pumpWidget(
      MaterialApp(
        theme: lumeLightTheme(),
        home: Builder(
          builder: (context) {
            hostContext = context;
            return const Scaffold(body: SizedBox());
          },
        ),
      ),
    );

    showAchievementUnlockedSnackBar(hostContext, 'Primeiro passo');
    await tester.pump();

    expect(find.text('Achievement unlocked: Primeiro passo'), findsOneWidget);
    expect(find.byIcon(Icons.emoji_events_rounded), findsOneWidget);
    expect(isLumeSnackBarVisible, isTrue);

    final icon = tester.widget<Icon>(find.byIcon(Icons.emoji_events_rounded));
    expect(icon.color, AppColors.Accent.accent);

    hideLumeSnackBar();
    await tester.pump();
  });

  testWidgets('showAchievementUnlockedSnackBar ignores blank names', (
    tester,
  ) async {
    addTearDown(resetLumeSnackBarForTest);

    late BuildContext hostContext;
    await tester.pumpWidget(
      MaterialApp(
        theme: lumeLightTheme(),
        home: Builder(
          builder: (context) {
            hostContext = context;
            return const Scaffold(body: SizedBox());
          },
        ),
      ),
    );

    showAchievementUnlockedSnackBar(hostContext, '   ');
    await tester.pump();

    expect(isLumeSnackBarVisible, isFalse);
  });
}
