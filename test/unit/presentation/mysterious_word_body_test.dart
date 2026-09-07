import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/domain/models/trail_game/trail_game.dart';
import 'package:lume/layers/presentation/screens/games/mysterious_word/mysterious_word_body.dart';
import 'package:lume/layers/presentation/screens/games/mysterious_word/mysterious_word_state.dart';
import 'package:lume_design_system/theme/lume_theme.dart';

const _game = MysteriousWordGameDomain(
  pairId: 1,
  sortOrder: 1,
  word: 'IMPERIO',
  description: 'Regime politico apos a Independencia.',
  hint: 'Dom Pedro',
  explanation: 'O Imperio durou de 1822 a 1889.',
);

void main() {
  Future<void> pumpBody(
    WidgetTester tester, {
    required Size surface,
    MysteriousWordState? state,
    ValueChanged<String>? onLetterPressed,
  }) async {
    await tester.binding.setSurfaceSize(surface);
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: lumeLightTheme(),
        home: Scaffold(
          body: MysteriousWordBody(
            state: state ?? const MysteriousWordState(game: _game),
            onLetterPressed: onLetterPressed ?? (_) {},
            onNext: () {},
          ),
        ),
      ),
    );
  }

  testWidgets('wide viewport keeps letter chips in a multi-row grid', (
    tester,
  ) async {
    await pumpBody(tester, surface: const Size(1200, 800));

    expect(tester.getSize(find.byType(Wrap)).width, lessThanOrEqualTo(388));

    final a = tester.getTopLeft(find.text('A'));
    final j = tester.getTopLeft(find.text('J'));
    final s = tester.getTopLeft(find.text('S'));
    expect(j.dy, greaterThan(a.dy));
    expect(s.dy, greaterThan(j.dy));

    final chip = find.ancestor(
      of: find.text('A'),
      matching: find.byType(SizedBox),
    );
    expect(tester.getSize(chip.first), const Size(36, 36));
  });

  testWidgets('narrow viewport still shows a wrapping letter grid', (
    tester,
  ) async {
    await pumpBody(tester, surface: const Size(360, 800));

    expect(find.text('A'), findsOneWidget);
    expect(find.text('Z'), findsOneWidget);

    final a = tester.getTopLeft(find.text('A'));
    final z = tester.getTopLeft(find.text('Z'));
    expect(z.dy, greaterThan(a.dy));
  });

  testWidgets('letter chip taps report the pressed letter', (tester) async {
    String? pressed;
    await pumpBody(
      tester,
      surface: const Size(400, 800),
      onLetterPressed: (letter) => pressed = letter,
    );

    await tester.tap(find.text('B'));
    expect(pressed, 'B');
  });
}
