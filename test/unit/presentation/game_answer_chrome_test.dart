import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/common/strings/trail_strings.dart';
import 'package:lume/layers/presentation/screens/games/shared/game_answer_chrome.dart';
import 'package:lume_design_system/theme/lume_theme.dart';

void main() {
  testWidgets('clearing answered dismisses the feedback dialog', (
    tester,
  ) async {
    final host = GlobalKey<_HostState>();
    await tester.pumpWidget(_Host(key: host));
    await tester.pumpAndSettle();
    expect(find.text(trailGameCorrect), findsOneWidget);

    host.currentState!.answered = false;
    host.currentState!.rebuild();
    await tester.pumpAndSettle();
    expect(find.text(trailGameCorrect), findsNothing);

    host.currentState!.answered = true;
    host.currentState!.rebuild();
    await tester.pumpAndSettle();
    expect(find.text(trailGameCorrect), findsOneWidget);
  });

  testWidgets(
    'removing the play surface dismisses the dialog before the next one',
    (tester) async {
      final host = GlobalKey<_HostState>();
      await tester.pumpWidget(_Host(key: host));
      await tester.pumpAndSettle();
      expect(find.text(trailGameCorrect), findsOneWidget);

      host.currentState!.showChrome = false;
      host.currentState!.rebuild();
      await tester.pumpAndSettle();
      expect(find.text(trailGameCorrect), findsNothing);

      host.currentState!.showChrome = true;
      host.currentState!.answered = true;
      host.currentState!.rebuild();
      await tester.pumpAndSettle();
      expect(find.text(trailGameCorrect), findsOneWidget);
    },
  );
}

class _Host extends StatefulWidget {
  const _Host({super.key});

  @override
  State<_Host> createState() => _HostState();
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
