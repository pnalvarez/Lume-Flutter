import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/app/level_up_host.dart';
import 'package:lume/common/strings/xp_strings.dart';
import 'package:lume/layers/domain/models/xp/level_up_domain.dart';
import 'package:lume/layers/presentation/shared/level_up_alert.dart';
import 'package:lume_design_system/theme/lume_theme.dart';

void main() {
  testWidgets('shows the level-up alert over the current route', (
    tester,
  ) async {
    final events = StreamController<LevelUpDomain>.broadcast();
    addTearDown(events.close);
    final navigatorKey = GlobalKey<NavigatorState>();

    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: navigatorKey,
        theme: lumeLightTheme(),
        home: const Scaffold(body: Text('home')),
        builder: (context, child) {
          return LevelUpHost(
            events: events.stream,
            navigatorKey: navigatorKey,
            child: child ?? const SizedBox.shrink(),
          );
        },
      ),
    );
    await tester.pump();

    events.add(
      const LevelUpDomain(
        level: 3,
        xpOffset: 100,
        currentXp: 103,
        xpForNextLevel: 200,
      ),
    );
    // Repeating confetti tickers never settle; pump past the dialog enter animation.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(LevelUpAlert), findsOneWidget);
    expect(find.text(xpLevelUpHeadline(3)), findsOneWidget);
    expect(find.text(xpLevelUpDescription(103, 200)), findsOneWidget);

    await tester.tap(find.text(xpLevelUpContinue));
    await tester.pumpAndSettle();

    expect(find.byType(LevelUpAlert), findsNothing);
    expect(find.text('home'), findsOneWidget);
  });
}
