import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/common/strings/trail_strings.dart';
import 'package:lume/layers/presentation/screens/games/games_complete_body.dart';
import 'package:lume/layers/presentation/screens/trail/submodule_session/submodule_complete_body.dart';
import 'package:lume/layers/presentation/screens/trail/submodule_session/submodule_session_state.dart';
import 'package:lume_design_system/atoms/colors/colors.dart';
import 'package:lume_design_system/theme/lume_theme.dart';

void main() {
  group('GamesCompleteStatus', () {
    test('success exposes trophy SVG and filled check badge', () {
      const status = GamesCompleteStatus.success;

      expect(status.heroSvgAsset, isNotNull);
      expect(status.heroIconData, isNull);
      expect(status.heroIconColor, AppColors.Accent.accent);
      expect(status.badgeIcon, Icons.check_rounded);
      expect(status.badgeIconColor, Colors.white);
      expect(status.badgeFillColor, AppColors.Success.onSuccess);
      expect(status.submoduleTitle, trailSessionCompleteTitle);
    });

    test('failure exposes Material sad face and filled close badge', () {
      const status = GamesCompleteStatus.failure;

      expect(status.heroSvgAsset, isNull);
      expect(status.heroIconData, Icons.sentiment_dissatisfied_rounded);
      expect(status.heroIconColor, AppColors.Extra.rose);
      expect(status.badgeIcon, Icons.close_rounded);
      expect(status.badgeIconColor, Colors.white);
      expect(status.badgeFillColor, AppColors.Extra.rose);
      expect(status.submoduleTitle, trailSessionIncompleteTitle);
    });
  });

  group('GamesCompleteBody', () {
    testWidgets('success shows trophy SVG and check badge', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: lumeLightTheme(),
          home: GamesCompleteBody(
            status: GamesCompleteStatus.success,
            title: trailSessionCompleteTitle,
            scoreText: 'Você acertou 3 de 4 jogos.',
            message: trailSessionUnlockAchieved,
            actionLabel: trailSessionBackToTrail,
            onAction: () => tapped = true,
          ),
        ),
      );

      expect(find.byType(SvgPicture), findsOneWidget);
      expect(find.byIcon(Icons.check_rounded), findsOneWidget);
      expect(find.textContaining('Você acertou 3 de 4'), findsOneWidget);
      expect(find.text(trailSessionUnlockAchieved), findsOneWidget);

      await tester.tap(find.text(trailSessionBackToTrail));
      expect(tapped, isTrue);
    });

    testWidgets('failure shows sad-face icon and close badge', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: lumeLightTheme(),
          home: GamesCompleteBody(
            status: GamesCompleteStatus.failure,
            title: trailSessionIncompleteTitle,
            scoreText: 'Você acertou 1 de 4 jogos.',
            message: trailSessionUnlockRequirement(minCorrect: 3, total: 4),
            actionLabel: trailSessionBackToTrail,
            onAction: () {},
          ),
        ),
      );

      expect(find.byIcon(Icons.sentiment_dissatisfied_rounded), findsOneWidget);
      expect(find.byIcon(Icons.close_rounded), findsOneWidget);
      expect(find.byType(SvgPicture), findsNothing);
    });

    testWidgets('omits optional message when blank', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: lumeLightTheme(),
          home: GamesCompleteBody(
            title: 'Done',
            scoreText: 'Score',
            message: '   ',
            actionLabel: 'OK',
            onAction: () {},
          ),
        ),
      );

      expect(find.textContaining('Done'), findsOneWidget);
      expect(find.textContaining('Score'), findsOneWidget);
      expect(find.text('OK'), findsOneWidget);
    });
  });

  group('SubmoduleCompleteBody', () {
    testWidgets('maps failure status into incomplete title copy', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: lumeLightTheme(),
          home: SubmoduleCompleteBody(
            status: GamesCompleteStatus.failure,
            correctCount: 1,
            total: 4,
            unlockMessage: trailSessionUnlockRequirement(
              minCorrect: 3,
              total: 4,
            ),
            onBackToTrail: () {},
          ),
        ),
      );

      expect(find.textContaining('Você não completou'), findsOneWidget);
      expect(
        find.text(trailSessionCompleteScore(correctCount: 1, total: 4)),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.sentiment_dissatisfied_rounded), findsOneWidget);
    });

    testWidgets('maps success status into complete title copy', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: lumeLightTheme(),
          home: SubmoduleCompleteBody(
            status: GamesCompleteStatus.success,
            correctCount: 3,
            total: 4,
            unlockMessage: trailSessionUnlockAchieved,
            onBackToTrail: () {},
          ),
        ),
      );

      expect(find.textContaining('Você concluiu'), findsOneWidget);
      expect(find.byType(SvgPicture), findsOneWidget);
    });
  });

  group('SubmoduleSessionState completeStatus', () {
    test('participates in equality and hashCode', () {
      const success = SubmoduleSessionState(
        completeStatus: GamesCompleteStatus.success,
      );
      const failure = SubmoduleSessionState(
        completeStatus: GamesCompleteStatus.failure,
      );

      expect(success, isNot(equals(failure)));
      expect(success.hashCode, isNot(equals(failure.hashCode)));
      expect(
        success,
        equals(
          const SubmoduleSessionState(
            completeStatus: GamesCompleteStatus.success,
          ),
        ),
      );
    });

    test('copyWith can clear completeStatus back to success', () {
      final cleared = const SubmoduleSessionState(
        completeStatus: GamesCompleteStatus.failure,
      ).copyWith(clearCompleteStatus: true);

      expect(cleared.completeStatus, GamesCompleteStatus.success);
    });
  });
}
