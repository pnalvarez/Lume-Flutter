import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume_design_system/molecules/buttons/lume_icon_button.dart';
import 'package:lume_design_system/molecules/loaders/circular_loader.dart';
import 'package:lume_design_system/organisms/dialogs/lume_dialog.dart';
import 'package:lume_design_system/organisms/feedback/floating_notice.dart';
import 'package:lume_design_system/organisms/feedback/lume_loading_overlay.dart';
import 'package:lume_design_system/organisms/feedback/lume_snack_bar.dart';
import 'package:lume_design_system/organisms/feedback/result_banner.dart';
import 'package:lume_design_system/organisms/game/choice_group.dart';
import 'package:lume_design_system/organisms/game/prompt_card.dart';
import 'package:lume_design_system/organisms/game/session_timer.dart';
import 'package:lume_design_system/organisms/navigation/bottom_nav_bar.dart';
import 'package:lume_design_system/organisms/navigation/brand_header.dart';
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

    testWidgets('BrandHeader shows title and subtitle', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const BrandHeader(
            title: 'Olá, Ana',
            subtitle: 'Vamos aprender algo novo hoje?',
          ),
        ),
      );
      expect(find.text('Olá, Ana'), findsOneWidget);
      expect(find.text('Vamos aprender algo novo hoje?'), findsOneWidget);
    });

    testWidgets('BrandHeader omits subtitle when null', (tester) async {
      await tester.pumpWidget(_wrap(const BrandHeader(title: 'Olá, Ana')));
      expect(find.text('Olá, Ana'), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('PageHeader stacked title sits below back', (tester) async {
      var back = false;
      await tester.pumpWidget(
        _wrap(
          PageHeader(
            title: 'O que você quer aprender?',
            onBack: () => back = true,
            titleLayout: PageHeaderTitleLayout.stacked,
          ),
        ),
      );
      expect(find.text('O que você quer aprender?'), findsOneWidget);
      final backCenter = tester.getCenter(
        find.byIcon(Icons.arrow_back_rounded),
      );
      final titleCenter = tester.getCenter(
        find.text('O que você quer aprender?'),
      );
      expect(titleCenter.dy, greaterThan(backCenter.dy));
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

    testWidgets('PageHeader shows progress title and close trailing', (
      tester,
    ) async {
      var closed = false;
      await tester.pumpWidget(
        _wrap(
          PageHeader(
            titleWidget: const LinearProgressIndicator(value: 0.5),
            trailing: LumeIconButton(
              icon: Icons.close_rounded,
              onPressed: () => closed = true,
              size: LumeIconButtonSize.sm,
            ),
          ),
        ),
      );
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      expect(find.byIcon(Icons.close_rounded), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_rounded), findsNothing);
      await tester.tap(find.byIcon(Icons.close_rounded));
      expect(closed, isTrue);
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

    testWidgets('LumeSnackBar renders text and optional close', (tester) async {
      var closed = false;
      await tester.pumpWidget(
        _wrap(
          LumeSnackBar(
            icon: Icons.check_circle_rounded,
            text: 'Saved',
            trait: LumeSnackBarTrait.success,
            hasCloseButton: true,
            onClose: () => closed = true,
          ),
        ),
      );
      expect(find.text('Saved'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
      await tester.tap(find.byIcon(Icons.close_rounded));
      expect(closed, isTrue);
    });

    testWidgets('showLumeSnackBar inserts top overlay entry', (tester) async {
      addTearDown(resetLumeSnackBarForTest);

      late BuildContext hostContext;
      await tester.pumpWidget(
        MaterialApp(
          theme: lumeLightTheme(),
          home: Builder(
            builder: (context) {
              hostContext = context;
              return const Scaffold(body: SizedBox());
            },
          ),
        ),
      );

      showLumeSnackBar(
        hostContext,
        icon: Icons.info_outline_rounded,
        text: 'Tip',
        trait: LumeSnackBarTrait.neutral,
        hasCloseButton: true,
      );
      await tester.pump();

      expect(find.text('Tip'), findsOneWidget);
      expect(isLumeSnackBarVisible, isTrue);

      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pump();

      expect(find.text('Tip'), findsNothing);
      expect(isLumeSnackBarVisible, isFalse);
    });

    testWidgets('showLumeSnackBar can anchor to the bottom', (tester) async {
      addTearDown(resetLumeSnackBarForTest);

      late BuildContext hostContext;
      await tester.pumpWidget(
        MaterialApp(
          theme: lumeLightTheme(),
          home: Builder(
            builder: (context) {
              hostContext = context;
              return const Scaffold(body: SizedBox());
            },
          ),
        ),
      );

      showLumeSnackBar(
        hostContext,
        icon: Icons.info_outline_rounded,
        text: 'Bottom tip',
        trait: LumeSnackBarTrait.neutral,
        position: LumeSnackBarPosition.bottom,
      );
      await tester.pump();

      final positioned = tester.widget<Positioned>(find.byType(Positioned));
      expect(positioned.bottom, 0);
      expect(positioned.top, isNull);
      expect(find.text('Bottom tip'), findsOneWidget);

      hideLumeSnackBar();
      await tester.pump();
    });

    testWidgets('LumeLoadingOverlay shows loader', (tester) async {
      await tester.pumpWidget(_wrap(const LumeLoadingOverlay()));
      expect(find.byType(CircularLoader), findsOneWidget);
    });

    testWidgets('showLumeLoadingOverlay inserts root overlay entry', (
      tester,
    ) async {
      addTearDown(resetLumeLoadingOverlayForTest);

      late BuildContext hostContext;
      await tester.pumpWidget(
        MaterialApp(
          theme: lumeLightTheme(),
          home: Builder(
            builder: (context) {
              hostContext = context;
              return const Scaffold(body: SizedBox());
            },
          ),
        ),
      );

      showLumeLoadingOverlay(hostContext);
      await tester.pump();

      expect(find.byType(LumeLoadingOverlay), findsOneWidget);
      expect(isLumeLoadingOverlayVisible, isTrue);

      hideLumeLoadingOverlay();
      await tester.pump();

      expect(find.byType(LumeLoadingOverlay), findsNothing);
      expect(isLumeLoadingOverlayVisible, isFalse);
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
