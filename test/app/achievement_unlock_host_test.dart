import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/app/achievement_unlock_host.dart';
import 'package:lume/common/strings/achievement_strings.dart';
import 'package:lume/layers/domain/models/achievement/achievement_unlock_domain.dart';
import 'package:lume_design_system/organisms/feedback/lume_snack_bar.dart';
import 'package:lume_design_system/theme/lume_theme.dart';

void main() {
  tearDown(resetLumeSnackBarForTest);

  testWidgets('shows the unlock snackbar over the current route', (
    tester,
  ) async {
    final events = StreamController<AchievementUnlockDomain>.broadcast();
    addTearDown(events.close);
    final navigatorKey = GlobalKey<NavigatorState>();
    const toastDuration = Duration(milliseconds: 50);

    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: navigatorKey,
        theme: lumeLightTheme(),
        home: const Scaffold(body: Text('home')),
        builder: (context, child) {
          return AchievementUnlockHost(
            events: events.stream,
            navigatorKey: navigatorKey,
            toastDuration: toastDuration,
            child: child ?? const SizedBox.shrink(),
          );
        },
      ),
    );
    await tester.pump();

    events.add(
      const AchievementUnlockDomain(
        achievementId: 'ach-1',
        code: 'first_step',
        name: 'Primeiro passo',
      ),
    );
    // OverlayEntry from [showLumeSnackBar] builds on the following frame.
    await tester.pump();
    await tester.pump();

    expect(
      find.text(achievementUnlockedSnackBarText('Primeiro passo')),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.emoji_events_rounded), findsOneWidget);
    expect(isLumeSnackBarVisible, isTrue);
    expect(find.text('home'), findsOneWidget);

    await tester.pump(toastDuration);
    hideLumeSnackBar();
    await tester.pump();
  });

  testWidgets('queues unlocks and shows them sequentially', (tester) async {
    final events = StreamController<AchievementUnlockDomain>.broadcast();
    addTearDown(events.close);
    final navigatorKey = GlobalKey<NavigatorState>();
    const toastDuration = Duration(milliseconds: 100);

    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: navigatorKey,
        theme: lumeLightTheme(),
        home: const Scaffold(body: Text('home')),
        builder: (context, child) {
          return AchievementUnlockHost(
            events: events.stream,
            navigatorKey: navigatorKey,
            toastDuration: toastDuration,
            child: child ?? const SizedBox.shrink(),
          );
        },
      ),
    );
    await tester.pump();

    events
      ..add(
        const AchievementUnlockDomain(
          achievementId: 'ach-1',
          code: 'first',
          name: 'Primeira',
        ),
      )
      ..add(
        const AchievementUnlockDomain(
          achievementId: 'ach-2',
          code: 'second',
          name: 'Segunda',
        ),
      );
    await tester.pump();
    await tester.pump();

    expect(
      find.text(achievementUnlockedSnackBarText('Primeira')),
      findsOneWidget,
    );
    expect(find.text(achievementUnlockedSnackBarText('Segunda')), findsNothing);

    await tester.pump(toastDuration);
    await tester.pump();

    expect(
      find.text(achievementUnlockedSnackBarText('Primeira')),
      findsNothing,
    );
    expect(
      find.text(achievementUnlockedSnackBarText('Segunda')),
      findsOneWidget,
    );

    await tester.pump(toastDuration);
    hideLumeSnackBar();
    await tester.pump();
  });
}
