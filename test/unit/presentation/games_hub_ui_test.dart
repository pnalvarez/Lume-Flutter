import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/common/strings/games_hub_strings.dart';
import 'package:lume/layers/presentation/screens/games/games_hub_body.dart';
import 'package:lume/layers/presentation/screens/games/games_hub_state.dart';
import 'package:lume/layers/presentation/screens/games/games_hub_ui.dart';
import 'package:lume_design_system/molecules/loaders/display_as_loader.dart';
import 'package:lume_design_system/theme/lume_theme.dart';

void main() {
  test('parseHexColor accepts RRGGBB', () {
    expect(parseHexColor('#F5A623'), const Color(0xFFF5A623));
  });

  test('parseHexColor rejects invalid values', () {
    expect(parseHexColor('F5A623'), isNull);
    expect(parseHexColor('#GGG'), isNull);
    expect(parseHexColor(''), isNull);
  });

  testWidgets('initial loading shows section and arcade shimmers', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: lumeLightTheme(),
        home: GamesHubBody(
          state: const GamesHubState(),
          onRetry: () {},
          onGamePressed: (_) {},
          onArcadePressed: () {},
        ),
      ),
    );

    expect(find.byType(GamesHubLoadingList), findsOneWidget);
    expect(find.byType(DisplayAsLoader), findsNWidgets(7));
  });

  testWidgets('empty state centers alert and message', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: lumeLightTheme(),
        home: GamesHubBody(
          state: const GamesHubState(isInitialLoading: false),
          onRetry: () {},
          onGamePressed: (_) {},
          onArcadePressed: () {},
        ),
      ),
    );

    expect(find.byType(GamesHubEmptyState), findsOneWidget);
    expect(find.text(gamesHubEmpty), findsOneWidget);
  });
}
