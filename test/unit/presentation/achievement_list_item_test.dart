import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/common/strings/achievement_strings.dart';
import 'package:lume/layers/presentation/screens/achievements/achievement_list_item.dart';
import 'package:lume_design_system/molecules/progress/lume_progress_bar.dart';
import 'package:lume_design_system/theme/lume_theme.dart';

void main() {
  test('achievementProgressCaption formats progress over target', () {
    expect(achievementProgressCaption(3, 5), '3 / 5');
  });

  Widget wrap(Widget child, {ThemeData? theme}) => MaterialApp(
    theme: theme ?? lumeLightTheme(),
    home: Scaffold(body: child),
  );

  testWidgets('locked shows lock badge and ignores taps', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      wrap(
        AchievementListItem(
          title: 'Explorador',
          description: 'Complete 5 submódulos.',
          status: AchievementListItemStatus.locked,
          progress: 0,
          target: 5,
          onTap: () => taps++,
        ),
      ),
    );

    expect(find.text('Explorador'), findsOneWidget);
    expect(find.text('0 / 5'), findsOneWidget);
    expect(find.byIcon(Icons.lock_rounded), findsOneWidget);
    expect(find.byType(Opacity), findsNothing);

    await tester.tap(find.byType(AchievementListItem));
    await tester.pump();
    expect(taps, 0);
  });

  testWidgets('in-progress shows progress caption and forwards taps', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      wrap(
        AchievementListItem(
          title: 'Explorador',
          description: 'Complete 5 submódulos.',
          status: AchievementListItemStatus.inProgress,
          progress: 3,
          target: 5,
          onTap: () => taps++,
        ),
      ),
    );

    expect(find.text('3 / 5'), findsOneWidget);
    expect(find.byIcon(Icons.lock_rounded), findsNothing);
    expect(find.byIcon(Icons.check_circle_rounded), findsNothing);

    await tester.tap(find.byType(AchievementListItem));
    await tester.pump();
    expect(taps, 1);
  });

  testWidgets('completed shows check and a single trophy badge', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        const AchievementListItem(
          title: 'Primeiro passo',
          description: 'Complete 1 submódulo.',
          status: AchievementListItemStatus.completed,
          progress: 1,
          target: 1,
          icon: Icons.explore_rounded,
        ),
      ),
    );

    expect(find.text('1 / 1'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
    expect(find.byIcon(Icons.emoji_events_rounded), findsOneWidget);
    expect(find.byIcon(Icons.explore_rounded), findsOneWidget);
  });

  testWidgets('image leading replaces the icon', (tester) async {
    final theme = lumeLightTheme();
    await tester.pumpWidget(
      wrap(
        AchievementListItem(
          title: 'Arcade 50',
          description: 'Alcance 50 pontos.',
          status: AchievementListItemStatus.locked,
          progress: 0,
          target: 50,
          image: MemoryImage(_samplePng),
        ),
        theme: theme,
      ),
    );

    expect(find.byType(Image), findsOneWidget);
    expect(find.byIcon(Icons.emoji_events_rounded), findsNothing);
    expect(find.byIcon(Icons.lock_rounded), findsOneWidget);

    final image = tester.widget<Image>(find.byType(Image));
    expect(image.color, theme.colorScheme.onSurfaceVariant);
    expect(image.colorBlendMode, BlendMode.saturation);
  });

  testWidgets('text and track follow the dark color scheme', (tester) async {
    final theme = lumeDarkTheme();
    await tester.pumpWidget(
      wrap(
        const AchievementListItem(
          title: 'Explorador',
          description: 'Complete 5 submódulos.',
          status: AchievementListItemStatus.inProgress,
          progress: 3,
          target: 5,
        ),
        theme: theme,
      ),
    );

    final title = tester.widget<Text>(find.text('Explorador'));
    final description = tester.widget<Text>(
      find.text('Complete 5 submódulos.'),
    );
    final bar = tester.widget<LumeProgressBar>(find.byType(LumeProgressBar));
    expect(title.style?.color, theme.colorScheme.onSurface);
    expect(description.style?.color, theme.colorScheme.onSurfaceVariant);
    expect(bar.trackColor, theme.colorScheme.surfaceContainerHigh);
  });
}

/// 4×4 PNG. Contents are irrelevant; the widget only needs a decodable image.
final Uint8List _samplePng = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAQAAAAECAYAAACp8Z5+AAAAEklEQVR42mOQbrn1HxkzkC4AACd/J4ETnPSMAAAAAElFTkSuQmCC',
);
