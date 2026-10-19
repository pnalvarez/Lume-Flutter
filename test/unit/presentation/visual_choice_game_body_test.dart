import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume/layers/presentation/screens/games/visual_choice_game/visual_choice_game_body.dart';
import 'package:lume/layers/presentation/screens/games/visual_choice_game/visual_choice_game_state.dart';
import 'package:lume_design_system/organisms/game/artwork_prompt_card.dart';
import 'package:lume_design_system/theme/lume_theme.dart';

const _state = VisualChoiceGameState(
  prompt: 'A qual movimento esta pintura pertence?',
  imageUrl: '',
  imagePhase: ArtworkPromptImagePhase.loading,
  options: ['Impressionismo', 'Cubismo'],
);

void main() {
  Future<void> pumpBody(
    WidgetTester tester, {
    required VisualChoiceGameState state,
    required ValueChanged<String> onOptionSelected,
  }) async {
    await tester.binding.setSurfaceSize(const Size(400, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: lumeLightTheme(),
        home: Scaffold(
          body: VisualChoiceGameBody(
            state: state,
            onOptionSelected: onOptionSelected,
          ),
        ),
      ),
    );
  }

  testWidgets('an idle visual round reports the tapped choice', (tester) async {
    final taps = <String>[];
    await pumpBody(tester, state: _state, onOptionSelected: taps.add);

    await tester.tap(find.text('Cubismo'));
    await tester.pump();

    expect(taps, ['1']);
  });

  testWidgets('a submitting visual round ignores further choice taps', (
    tester,
  ) async {
    final taps = <String>[];
    await pumpBody(
      tester,
      state: const VisualChoiceGameState(
        prompt: 'A qual movimento esta pintura pertence?',
        imageUrl: '',
        imagePhase: ArtworkPromptImagePhase.error,
        options: ['Impressionismo', 'Cubismo'],
        selectedOptionId: '0',
        phase: VisualChoiceGamePhase.submitting,
      ),
      onOptionSelected: taps.add,
    );

    await tester.tap(find.byType(CircularProgressIndicator));
    await tester.tap(find.text('Cubismo'));
    await tester.pump();

    expect(taps, isEmpty);
  });

  testWidgets(
    'a submitting visual round shows a spinner on the selected option',
    (tester) async {
      await pumpBody(
        tester,
        state: const VisualChoiceGameState(
          prompt: 'A qual movimento esta pintura pertence?',
          imageUrl: '',
          imagePhase: ArtworkPromptImagePhase.error,
          options: ['Impressionismo', 'Cubismo'],
          selectedOptionId: '0',
          phase: VisualChoiceGamePhase.submitting,
        ),
        onOptionSelected: (_) {},
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Impressionismo'), findsNothing);
      expect(find.text('Cubismo'), findsOneWidget);
    },
  );
}
