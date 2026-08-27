import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume_design_system/atoms/colors/colors.dart';
import 'package:lume_design_system/molecules/badges/amount_badge.dart';
import 'package:lume_design_system/molecules/badges/lume_badge.dart';
import 'package:lume_design_system/molecules/badges/sparkling_badge.dart';
import 'package:lume_design_system/molecules/buttons/lume_button.dart';
import 'package:lume_design_system/molecules/buttons/lume_icon_button.dart';
import 'package:lume_design_system/molecules/chips/chip_picker.dart';
import 'package:lume_design_system/molecules/chips/selectable_chip.dart';
import 'package:lume_design_system/molecules/chips/stat_chip.dart';
import 'package:lume_design_system/molecules/chips/status_chip.dart';
import 'package:lume_design_system/molecules/input_fields/input_field.dart';
import 'package:lume_design_system/molecules/loaders/circular_loader.dart';
import 'package:lume_design_system/molecules/progress/lume_progress_bar.dart';
import 'package:lume_design_system/molecules/progress/step_progress_bar.dart';
import 'package:lume_design_system/molecules/tiles/feedback_tile.dart';
import 'package:lume_design_system/molecules/tiles/score_tile.dart';
import 'package:lume_design_system/molecules/tiles/stat_tile.dart';
import 'package:lume_design_system/theme/lume_theme.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: lumeLightTheme(),
  home: Scaffold(body: Center(child: child)),
);

void main() {
  group('LumeButton', () {
    testWidgets('renders label', (tester) async {
      await tester.pumpWidget(
        _wrap(LumeButton(label: 'Continuar', onPressed: () {})),
      );
      expect(find.text('Continuar'), findsOneWidget);
    });

    testWidgets('shows spinner when loading', (tester) async {
      await tester.pumpWidget(
        _wrap(LumeButton(label: 'Loading', isLoading: true, onPressed: () {})),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('loading keeps enabled look and blocks taps', (tester) async {
      await tester.pumpWidget(
        _wrap(
          LumeButton(label: 'Continuar', isLoading: true, onPressed: () {}),
        ),
      );
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNotNull);
      expect(
        button.style?.backgroundColor?.resolve({}),
        lumeLightTheme().colorScheme.primary,
      );
      expect(find.byType(IgnorePointer), findsWidgets);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Continuar'), findsNothing);
    });

    testWidgets('link type underlines the label', (tester) async {
      await tester.pumpWidget(
        _wrap(
          LumeButton(
            label: 'O que é o Lume?',
            type: LumeButtonType.link,
            trait: LumeButtonTrait.secondary,
            onPressed: () {},
          ),
        ),
      );
      expect(find.text('O que é o Lume?'), findsOneWidget);
      final button = tester.widget<TextButton>(find.byType(TextButton));
      expect(
        button.style?.textStyle?.resolve({})?.decoration,
        TextDecoration.underline,
      );
    });

    testWidgets('success trait uses success fill', (tester) async {
      await tester.pumpWidget(
        _wrap(
          LumeButton(
            label: 'Confirmar',
            trait: LumeButtonTrait.success,
            onPressed: () {},
          ),
        ),
      );
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(
        button.style?.backgroundColor?.resolve({}),
        AppColors.Success.success,
      );
    });

    testWidgets('defaults to brand elevated', (tester) async {
      await tester.pumpWidget(
        _wrap(LumeButton(label: 'Continuar', onPressed: () {})),
      );
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('isEnabled false blocks taps', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _wrap(
          LumeButton(
            label: 'Continuar',
            isEnabled: false,
            onPressed: () => tapped = true,
          ),
        ),
      );
      await tester.tap(find.text('Continuar'));
      expect(tapped, isFalse);
      expect(
        tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed,
        isNull,
      );
    });

    testWidgets('isExpanded fills available width', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: lumeLightTheme(),
          home: const Scaffold(
            body: SizedBox(
              width: 400,
              child: LumeButton(label: 'Go', isExpanded: true, onPressed: null),
            ),
          ),
        ),
      );
      expect(tester.getSize(find.byType(ElevatedButton)).width, 400);
    });

    testWidgets('isExpanded false hugs content', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: lumeLightTheme(),
          home: const Scaffold(
            body: SizedBox(
              width: 400,
              child: LumeButton(label: 'Go', onPressed: null),
            ),
          ),
        ),
      );
      expect(tester.getSize(find.byType(ElevatedButton)).width, lessThan(400));
    });
  });

  group('LumeIconButton', () {
    testWidgets('renders icon and responds to tap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _wrap(
          LumeIconButton(
            icon: Icons.close_rounded,
            onPressed: () => tapped = true,
          ),
        ),
      );
      await tester.tap(find.byIcon(Icons.close_rounded));
      expect(tapped, isTrue);
    });
  });

  group('InputField', () {
    testWidgets('renders label and accepts input', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        _wrap(
          InputField(
            label: 'Email',
            controller: controller,
            placeholder: 'voce@email.com',
            onChanged: (_) {},
          ),
        ),
      );
      expect(find.text('Email'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'a@b.com');
      expect(controller.text, 'a@b.com');
    });

    testWidgets('shows error message', (tester) async {
      await tester.pumpWidget(
        _wrap(
          InputField(
            controller: TextEditingController(),
            errorMessage: 'Campo obrigatório',
            onChanged: (_) {},
          ),
        ),
      );
      expect(find.text('Campo obrigatório'), findsOneWidget);
    });
  });

  group('Badges', () {
    testWidgets('LumeBadge renders label', (tester) async {
      await tester.pumpWidget(_wrap(const LumeBadge(label: 'Novo')));
      expect(find.text('Novo'), findsOneWidget);
    });

    testWidgets('LumeBadge accepts custom colors and icon', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const LumeBadge(
            label: 'Custom',
            leadingIcon: Icons.star_rounded,
            backgroundColor: Color(0xFFFFF9ED),
            foregroundColor: Color(0xFF6B5020),
          ),
        ),
      );
      expect(find.text('Custom'), findsOneWidget);
      expect(find.byIcon(Icons.star_rounded), findsOneWidget);
    });

    testWidgets('AmountBadge renders caller-provided copy', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AmountBadge(
            text: '+15 pts',
            secondaryText: 'Bonus',
            icon: Icons.bolt_rounded,
          ),
        ),
      );
      expect(find.text('+15 pts'), findsOneWidget);
      expect(find.textContaining('Bonus'), findsOneWidget);
    });

    testWidgets('SparklingBadge renders title and description', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const SparklingBadge(
            title: 'Dias seguidos',
            description: '0 dias',
            variant: SparklingBadgeVariant.warm,
            leadingIcon: SparklingBadgeIcon.flame,
          ),
        ),
      );
      expect(find.text('DIAS SEGUIDOS'), findsOneWidget);
      expect(find.text('0 dias'), findsOneWidget);
      expect(find.byIcon(Icons.local_fire_department_outlined), findsOneWidget);
    });

    testWidgets('SparklingBadge maps icon enum', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const SparklingBadge(
            title: 'XP',
            description: '10',
            variant: SparklingBadgeVariant.accent,
            leadingIcon: SparklingBadgeIcon.bolt,
          ),
        ),
      );
      expect(find.byIcon(Icons.bolt_rounded), findsOneWidget);
    });
  });

  group('Chips', () {
    testWidgets('StatChip renders parts', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const StatChip(
            icon: Icons.bolt_rounded,
            label: 'Score',
            value: '100',
          ),
        ),
      );
      expect(find.text('Score'), findsOneWidget);
      expect(find.text('100'), findsOneWidget);
    });

    testWidgets('StatusChip renders label', (tester) async {
      await tester.pumpWidget(
        _wrap(const StatusChip(label: 'Ativo', state: StatusChipState.success)),
      );
      expect(find.text('Ativo'), findsOneWidget);
    });

    testWidgets('ChipPicker selects item', (tester) async {
      var selected = 0;
      await tester.pumpWidget(
        _wrap(
          ChipPicker(
            items: const ['A', 'B', 'C'],
            selectedIndex: selected,
            onSelected: (i) => selected = i,
          ),
        ),
      );
      await tester.tap(find.text('B'));
      expect(selected, 1);
    });

    testWidgets('SelectableChip renders label', (tester) async {
      await tester.pumpWidget(
        _wrap(
          SelectableChip(label: 'História', selected: true, onPressed: () {}),
        ),
      );
      expect(find.text('História'), findsOneWidget);
    });
  });

  group('Progress', () {
    testWidgets('LumeProgressBar shows percentage', (tester) async {
      await tester.pumpWidget(_wrap(const LumeProgressBar(value: 0.5)));
      expect(find.text('50%'), findsOneWidget);
    });

    testWidgets('LumeProgressBar accepts leading widget', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const LumeProgressBar(
            value: 0.65,
            leading: LumeBadge(label: 'Status'),
            fillColor: Color(0xFF6B5020),
            trackColor: Color(0xFFFFF9ED),
          ),
        ),
      );
      expect(find.text('Status'), findsOneWidget);
      expect(find.text('65%'), findsOneWidget);
    });

    testWidgets('StepProgressBar shows current/total', (tester) async {
      await tester.pumpWidget(
        _wrap(const StepProgressBar(currentValue: 2, totalValue: 5)),
      );
      expect(find.text('2/5'), findsOneWidget);
    });
  });

  group('Tiles & loader', () {
    testWidgets('StatTile renders uppercase label and value', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const StatTile(
            icon: Icons.star_outline_rounded,
            label: 'XP Total',
            value: '341',
          ),
        ),
      );
      expect(find.text('XP TOTAL'), findsOneWidget);
      expect(find.text('341'), findsOneWidget);
    });

    testWidgets('ScoreTile renders score', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const ScoreTile(icon: Icons.star_rounded, score: 42, label: 'Hits'),
        ),
      );
      expect(find.text('42'), findsOneWidget);
      expect(find.text('Hits'), findsOneWidget);
    });

    testWidgets('FeedbackTile renders title', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const FeedbackTile(
            state: FeedbackTileState.success,
            title: 'Done',
            subtitle: '+10',
          ),
        ),
      );
      expect(find.text('Done'), findsOneWidget);
    });

    testWidgets('CircularLoader renders indicator', (tester) async {
      await tester.pumpWidget(_wrap(const CircularLoader()));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
