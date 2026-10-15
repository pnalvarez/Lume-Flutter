import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/common/strings/trail_strings.dart';
import 'package:lume/layers/presentation/screens/games/shared/game_answer_chrome.dart';
import 'package:lume_design_system/theme/lume_theme.dart';

void main() {
  testWidgets('clearing answered dismisses the feedback dialog', (
    tester,
  ) async {
    final host = _Host();
    await tester.pumpWidget(host);
    await tester.pumpAndSettle();
    expect(find.text(trailGameCorrect), findsOneWidget);

    host.state.answered = false;
    host.state.rebuild();
    await tester.pumpAndSettle();
    expect(find.text(trailGameCorrect), findsNothing);

    host.state.answered = true;
    host.state.rebuild();
    await tester.pumpAndSettle();
    expect(find.text(trailGameCorrect), findsOneWidget);
  });

  testWidgets(
    'removing the play surface dismisses the dialog before the next one',
    (tester) async {
      final host = _Host();
      await tester.pumpWidget(host);
      await tester.pumpAndSettle();
      expect(find.text(trailGameCorrect), findsOneWidget);

      host.state.showChrome = false;
      host.state.rebuild();
      await tester.pumpAndSettle();
      expect(find.text(trailGameCorrect), findsNothing);

      host.state.showChrome = true;
      host.state.answered = true;
      host.state.rebuild();
      await tester.pumpAndSettle();
      expect(find.text(trailGameCorrect), findsOneWidget);
    },
  );
}

class _Host extends StatefulWidget {
  _Host();

  final _HostState state = _HostState();

  @override
  State<_Host> createState() => state;
}

class _HostState extends State<_Host> {
  var answered = true;
  var showChrome = true;

  void rebuild() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lumeLightTheme(),
      home: Scaffold(
        body: showChrome
            ? GameAnswerChrome(
                answered: answered,
                isCorrect: true,
                onNext: () {},
                child: const SizedBox.shrink(),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
