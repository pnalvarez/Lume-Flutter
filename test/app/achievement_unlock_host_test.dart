import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/app/achievement_unlock_host.dart';
import 'package:lume/app/app_root_overlay.dart';
import 'package:lume/common/strings/achievement_strings.dart';
import 'package:lume/common/strings/xp_strings.dart';
import 'package:lume/layers/domain/models/achievement/achievement_unlock_domain.dart';
import 'package:lume/layers/presentation/shared/xp_snack_bar.dart';
import 'package:lume_design_system/organisms/feedback/lume_snack_bar.dart';
import 'package:lume_design_system/theme/lume_theme.dart';

Widget _shell({
  required Stream<AchievementUnlockDomain> events,
  required StreamController<void> authChanges,
  required String? Function() authUserId,
  required GlobalKey<NavigatorState> navigatorKey,
  Duration toastDuration = const Duration(milliseconds: 50),
  Widget home = const Scaffold(body: Text('home')),
}) {
  return MaterialApp(
    navigatorKey: navigatorKey,
    theme: lumeLightTheme(),
    home: home,
    builder: (context, child) {
      return AppRootOverlay(
        child: AchievementUnlockHost(
          events: events,
          authSessionChanges: authChanges.stream,
          authUserId: authUserId,
          toastDuration: toastDuration,
          child: child ?? const SizedBox.shrink(),
        ),
      );
    },
  );
}

void main() {
  tearDown(resetLumeSnackBarForTest);

  testWidgets('shows the unlock snackbar over the current route', (
    tester,
  ) async {
    final events = StreamController<AchievementUnlockDomain>.broadcast();
    final authChanges = StreamController<void>.broadcast();
    addTearDown(events.close);
    addTearDown(authChanges.close);
    final navigatorKey = GlobalKey<NavigatorState>();
    const toastDuration = Duration(milliseconds: 50);
    String? userId = 'user-1';

    await tester.pumpWidget(
      _shell(
        events: events.stream,
        authChanges: authChanges,
        authUserId: () => userId,
        navigatorKey: navigatorKey,
        toastDuration: toastDuration,
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
    await tester.pump();
    await tester.pump();

    expect(
      find.text(achievementUnlockedSnackBarText('Primeiro passo')),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.emoji_events_rounded), findsOneWidget);
    expect(find.text('home'), findsOneWidget);

    await tester.pump(toastDuration);
    await tester.pump();
  });

  testWidgets('queues unlocks and shows them sequentially', (tester) async {
    final events = StreamController<AchievementUnlockDomain>.broadcast();
    final authChanges = StreamController<void>.broadcast();
    addTearDown(events.close);
    addTearDown(authChanges.close);
    final navigatorKey = GlobalKey<NavigatorState>();
    const toastDuration = Duration(milliseconds: 100);
    String? userId = 'user-1';

    await tester.pumpWidget(
      _shell(
        events: events.stream,
        authChanges: authChanges,
        authUserId: () => userId,
        navigatorKey: navigatorKey,
        toastDuration: toastDuration,
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
    await tester.pump();
  });

  testWidgets('unlock toast stays visible above a dialog opened afterward', (
    tester,
  ) async {
    final events = StreamController<AchievementUnlockDomain>.broadcast();
    final authChanges = StreamController<void>.broadcast();
    addTearDown(events.close);
    addTearDown(authChanges.close);
    final navigatorKey = GlobalKey<NavigatorState>();
    String? userId = 'user-1';

    await tester.pumpWidget(
      _shell(
        events: events.stream,
        authChanges: authChanges,
        authUserId: () => userId,
        navigatorKey: navigatorKey,
        toastDuration: const Duration(milliseconds: 200),
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
    await tester.pump();
    await tester.pump();

    expect(
      find.text(achievementUnlockedSnackBarText('Primeiro passo')),
      findsOneWidget,
    );

    final navContext = navigatorKey.currentContext!;
    final dialog = showDialog<void>(
      context: navContext,
      builder: (_) => const AlertDialog(title: Text('Level up')),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Level up'), findsOneWidget);
    expect(
      find.text(achievementUnlockedSnackBarText('Primeiro passo')),
      findsOneWidget,
    );

    Navigator.of(navContext, rootNavigator: true).pop();
    await dialog;
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
  });

  testWidgets('XP toast does not dismiss an unlock toast in the host slot', (
    tester,
  ) async {
    final events = StreamController<AchievementUnlockDomain>.broadcast();
    final authChanges = StreamController<void>.broadcast();
    addTearDown(events.close);
    addTearDown(authChanges.close);
    final navigatorKey = GlobalKey<NavigatorState>();
    String? userId = 'user-1';

    await tester.pumpWidget(
      _shell(
        events: events.stream,
        authChanges: authChanges,
        authUserId: () => userId,
        navigatorKey: navigatorKey,
        toastDuration: const Duration(milliseconds: 200),
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
    await tester.pump();
    await tester.pump();

    showXpAwardedSnackBar(navigatorKey.currentContext!, 40);
    await tester.pump();
    await tester.pump();

    expect(find.text(xpAwardedSnackBarText(40)), findsOneWidget);
    expect(
      find.text(achievementUnlockedSnackBarText('Primeiro passo')),
      findsOneWidget,
    );

    hideLumeSnackBar();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
  });

  testWidgets('sign-out clears pending unlocks and dismisses the toast', (
    tester,
  ) async {
    final events = StreamController<AchievementUnlockDomain>.broadcast();
    final authChanges = StreamController<void>.broadcast();
    addTearDown(events.close);
    addTearDown(authChanges.close);
    final navigatorKey = GlobalKey<NavigatorState>();
    String? userId = 'user-1';

    await tester.pumpWidget(
      _shell(
        events: events.stream,
        authChanges: authChanges,
        authUserId: () => userId,
        navigatorKey: navigatorKey,
        toastDuration: const Duration(milliseconds: 200),
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

    userId = null;
    authChanges.add(null);
    await tester.pump();
    await tester.pump();

    expect(
      find.text(achievementUnlockedSnackBarText('Primeira')),
      findsNothing,
    );
    expect(find.text(achievementUnlockedSnackBarText('Segunda')), findsNothing);
  });

  testWidgets(
    'user switch clears the previous user queue while still signed in',
    (tester) async {
      final events = StreamController<AchievementUnlockDomain>.broadcast();
      final authChanges = StreamController<void>.broadcast();
      addTearDown(events.close);
      addTearDown(authChanges.close);
      final navigatorKey = GlobalKey<NavigatorState>();
      String? userId = 'user-1';

      await tester.pumpWidget(
        _shell(
          events: events.stream,
          authChanges: authChanges,
          authUserId: () => userId,
          navigatorKey: navigatorKey,
          toastDuration: const Duration(milliseconds: 200),
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

      // Session stays present; only the user id changes (no signed-out gap).
      userId = 'user-2';
      authChanges.add(null);
      await tester.pump();
      await tester.pump();

      expect(
        find.text(achievementUnlockedSnackBarText('Primeira')),
        findsNothing,
      );
      expect(
        find.text(achievementUnlockedSnackBarText('Segunda')),
        findsNothing,
      );
    },
  );

  testWidgets('token refresh with the same user id keeps the unlock toast', (
    tester,
  ) async {
    final events = StreamController<AchievementUnlockDomain>.broadcast();
    final authChanges = StreamController<void>.broadcast();
    addTearDown(events.close);
    addTearDown(authChanges.close);
    final navigatorKey = GlobalKey<NavigatorState>();
    String? userId = 'user-1';

    await tester.pumpWidget(
      _shell(
        events: events.stream,
        authChanges: authChanges,
        authUserId: () => userId,
        navigatorKey: navigatorKey,
        toastDuration: const Duration(milliseconds: 200),
      ),
    );
    await tester.pump();

    events.add(
      const AchievementUnlockDomain(
        achievementId: 'ach-1',
        code: 'first',
        name: 'Primeira',
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(
      find.text(achievementUnlockedSnackBarText('Primeira')),
      findsOneWidget,
    );

    // Same user id — e.g. token refresh — must not clear the toast.
    authChanges.add(null);
    await tester.pump();
    await tester.pump();

    expect(
      find.text(achievementUnlockedSnackBarText('Primeira')),
      findsOneWidget,
    );

    await tester.pump(const Duration(milliseconds: 200));
  });
}
