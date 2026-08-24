import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume_design_system/organisms/dialogs/lume_dialog.dart';
import 'package:lume_design_system/organisms/feedback/floating_notice.dart';
import 'package:lume_design_system/organisms/feedback/result_banner.dart';
import 'package:lume_design_system/organisms/game/choice_group.dart';
import 'package:lume_design_system/organisms/game/prompt_card.dart';
import 'package:lume_design_system/organisms/game/session_timer.dart';
import 'package:lume_design_system/organisms/navigation/bottom_nav_bar.dart';
import 'package:lume_design_system/organisms/navigation/page_header.dart';
import 'package:lume_design_system/organisms/navigation/screen_header.dart';
import 'package:lume_design_system/organisms/list_item/list_item.dart';
import 'package:lume_design_system/organisms/trail/content_card.dart';
import 'package:lume_design_system/organisms/trail/path_node.dart';
import 'package:lume_design_system/theme/lume_theme.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: lumeLightTheme(),
  home: Scaffold(body: child),
);

void main() {
  group('Navigation', () {
    testWidgets('BottomNavBar selects tab', (tester) async {
      var index = 0;
      await tester.pumpWidget(
        _wrap(
          BottomNavBar(
            items: const [
              BottomNavItem(icon: Icons.home, label: 'Home'),
              BottomNavItem(icon: Icons.games, label: 'Play'),
            ],
            selectedIndex: index,
            onSelected: (i) => index = i,
          ),
        ),
      );
      await tester.tap(find.text('Play'));
      expect(index, 1);
    });

    testWidgets('PageHeader shows title and back', (tester) async {
      var back = false;
      await tester.pumpWidget(
        _wrap(PageHeader(title: 'Quiz', onBack: () => back = true)),
      );
      expect(find.text('Quiz'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      expect(back, isTrue);
    });

    testWidgets('PageHeader prefers titleWidget over title', (tester) async {
      await tester.pumpWidget(
        _wrap(
          PageHeader(
            title: 'Hidden',
            titleWidget: const Text('Custom slot'),
            onBack: () {},
          ),
        ),
      );
      expect(find.text('Custom slot'), findsOneWidget);
      expect(find.text('Hidden'), findsNothing);
    });

    testWidgets('ScreenHeader shows title below back', (tester) async {
      var back = false;
      await tester.pumpWidget(
        _wrap(
          ScreenHeader(
            title: 'Recuperação de senha',
            onBack: () => back = true,
          ),
        ),
      );
      expect(find.text('Recuperação de senha'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      expect(back, isTrue);
    });
  });

  group('Trail', () {
    testWidgets('ContentCard renders title and action', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _wrap(
          ContentCard(
            title: 'Module',
            description: 'Desc',
            actionLabel: 'Start',
            onAction: () => tapped = true,
          ),
        ),
      );
      expect(find.text('Module'), findsOneWidget);
      await tester.tap(find.text('Start'));
      expect(tapped, isTrue);
    });

    testWidgets('PathNode renders label', (tester) async {
      await tester.pumpWidget(
        _wrap(const PathNode(state: PathNodeState.active, label: 'Level 1')),
      );
      expect(find.text('Level 1'), findsOneWidget);
    });
  });

  group('ListItem', () {
    testWidgets('renders title and handles tap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _wrap(
          ListItem(
            onTap: () => tapped = true,
            input: IconTitleDescriptionInput(
              leadingIcon: Icons.star,
              title: 'Row title',
              description: 'Row body',
            ),
          ),
        ),
      );
      expect(find.text('Row title'), findsOneWidget);
      expect(find.text('Row body'), findsOneWidget);
      await tester.tap(find.text('Row title'));
      expect(tapped, isTrue);
    });

    testWidgets('disabled ignores tap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _wrap(
          ListItem(
            isEnabled: false,
            onTap: () => tapped = true,
            input: TextInput(text: 'Disabled row'),
          ),
        ),
      );
      await tester.tap(find.text('Disabled row'));
      expect(tapped, isFalse);
    });

    testWidgets('header children nests submodule rows', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _wrap(
          ListItem(
            padding: EdgeInsets.zero,
            input: HeaderChildrenInput(
              title: 'Level',
              children: [
                ListItem(
                  onTap: () => tapped = true,
                  input: TitleCaptionTrailingInput(
                    title: 'Child',
                    caption: '4 games',
                    trailingIcon: Icons.chevron_right_rounded,
                    showAccentBar: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      expect(find.text('Level'), findsOneWidget);
      expect(find.text('Child'), findsOneWidget);
      await tester.tap(find.text('Child'));
      expect(tapped, isTrue);
    });

    testWidgets('leading caption progress shows bar caption', (tester) async {
      await tester.pumpWidget(
        _wrap(
          ListItem(
            trait: ListItemTrait.brand,
            input: LeadingTitleCaptionInput(
              leading: const Text('🧠'),
              title: 'Trail',
              caption: '1/4',
              progress: 0.25,
            ),
          ),
        ),
      );
      expect(find.text('Trail'), findsOneWidget);
      expect(find.text('1/4'), findsOneWidget);
    });
  });

  group('Game', () {
    testWidgets('PromptCard shows text', (tester) async {
      await tester.pumpWidget(
        _wrap(const PromptCard(eyebrow: 'Q1', text: 'What is 2+2?')),
      );
      expect(find.text('What is 2+2?'), findsOneWidget);
    });

    testWidgets('ChoiceGroup selects option', (tester) async {
      String? id;
      await tester.pumpWidget(
        _wrap(
          ChoiceGroup(
            options: const [
              ChoiceOption(id: 'a', label: 'Three'),
              ChoiceOption(id: 'b', label: 'Four'),
            ],
            onSelected: (v) => id = v,
          ),
        ),
      );
      await tester.tap(find.text('Four'));
      expect(id, 'b');
    });

    testWidgets('SessionTimer shows display', (tester) async {
      await tester.pumpWidget(_wrap(const SessionTimer(display: '01:20')));
      expect(find.text('01:20'), findsOneWidget);
    });
  });

  group('Feedback & dialogs', () {
    testWidgets('ResultBanner renders title', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const ResultBanner(
            tone: ResultBannerTone.positive,
            title: 'Correct!',
            bodyText: 'Well done',
          ),
        ),
      );
      expect(find.text('Correct!'), findsOneWidget);
      expect(find.text('Well done'), findsOneWidget);
    });

    testWidgets('FloatingNotice shows child', (tester) async {
      await tester.pumpWidget(_wrap(FloatingNotice.amount(text: '+10 pts')));
      expect(find.text('+10 pts'), findsOneWidget);
    });

    testWidgets('CelebrationDialog renders title', (tester) async {
      await tester.pumpWidget(
        _wrap(
          CelebrationDialog(
            title: 'Level up',
            actionLabel: 'Continue',
            onAction: () {},
            icon: Icons.auto_awesome,
          ),
        ),
      );
      expect(find.text('Level up'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
    });
  });
}
