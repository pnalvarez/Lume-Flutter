import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume_design_system/atoms/colors/colors.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/spacing/sizes.dart';
import 'package:lume_design_system/molecules/buttons/lume_icon_button.dart';
import 'package:lume_design_system/molecules/loaders/circular_loader.dart';
import 'package:lume_design_system/organisms/dialogs/lume_dialog.dart';
import 'package:lume_design_system/organisms/feedback/floating_notice.dart';
import 'package:lume_design_system/organisms/feedback/lume_loading_overlay.dart';
import 'package:lume_design_system/organisms/feedback/lume_snack_bar.dart';
import 'package:lume_design_system/organisms/feedback/result_banner.dart';
import 'package:lume_design_system/organisms/game/artwork_prompt_card.dart';
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

    testWidgets('ArtworkPromptCard places the question above the image', (
      tester,
    ) async {
      const question = 'Which movement does this painting belong to?';
      await tester.pumpWidget(
        _wrap(
          SingleChildScrollView(
            child: ArtworkPromptCard(
              question: question,
              image: MemoryImage(_samplePng),
            ),
          ),
        ),
      );

      expect(find.text(question), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
      expect(
        tester.getTopLeft(find.text(question)).dy,
        lessThan(tester.getTopLeft(find.byType(Image)).dy),
      );
      expect(
        tester.widget<AspectRatio>(find.byType(AspectRatio)).aspectRatio,
        ArtworkPromptCard.aspectRatio,
      );
    });

    testWidgets('ArtworkPromptCard shows a loading well', (tester) async {
      const question = 'Which movement does this painting belong to?';
      await tester.pumpWidget(
        _wrap(
          const SingleChildScrollView(
            child: ArtworkPromptCard(
              question: question,
              phase: ArtworkPromptImagePhase.loading,
            ),
          ),
        ),
      );

      expect(find.text(question), findsOneWidget);
      expect(find.byType(CircularLoader), findsOneWidget);
      expect(find.byIcon(Icons.image_not_supported_outlined), findsNothing);
    });

    testWidgets('ArtworkPromptCard shows an error well', (tester) async {
      const question = 'Which movement does this painting belong to?';
      await tester.pumpWidget(
        _wrap(
          const SingleChildScrollView(
            child: ArtworkPromptCard(
              question: question,
              phase: ArtworkPromptImagePhase.error,
            ),
          ),
        ),
      );

      expect(find.text(question), findsOneWidget);
      expect(find.byIcon(Icons.image_not_supported_outlined), findsOneWidget);
      expect(find.byType(CircularLoader), findsNothing);
    });

    testWidgets('ArtworkPromptCard keeps a pending image in the loading well', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const SingleChildScrollView(
            child: ArtworkPromptCard(
              question: 'Pending artwork',
              image: _PendingImage(),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Pending artwork'), findsOneWidget);
      expect(find.byType(CircularLoader), findsOneWidget);
    });

    testWidgets('ArtworkPromptCard shows the error well when the image fails', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const SingleChildScrollView(
            child: ArtworkPromptCard(
              question: 'Broken artwork',
              image: _FailingImage(),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Broken artwork'), findsOneWidget);
      expect(find.byIcon(Icons.image_not_supported_outlined), findsOneWidget);
    });

    testWidgets('ArtworkPromptCard shows the error well without an image', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const SingleChildScrollView(
            child: ArtworkPromptCard(question: 'Missing artwork'),
          ),
        ),
      );

      expect(find.text('Missing artwork'), findsOneWidget);
      expect(find.byIcon(Icons.image_not_supported_outlined), findsOneWidget);
    });

    testWidgets('ArtworkPromptCard reports a missing image once', (
      tester,
    ) async {
      var failed = 0;
      await tester.pumpWidget(
        _wrap(
          SingleChildScrollView(
            child: ArtworkPromptCard(
              question: 'Missing artwork',
              onImageFailed: () => failed++,
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(failed, 1);
    });

    testWidgets('ArtworkPromptCard does not report an explicit error phase', (
      tester,
    ) async {
      var failed = 0;
      await tester.pumpWidget(
        _wrap(
          SingleChildScrollView(
            child: ArtworkPromptCard(
              question: 'Pinned error',
              phase: ArtworkPromptImagePhase.error,
              onImageFailed: () => failed++,
            ),
          ),
        ),
      );
      await tester.pump();

      expect(failed, 0);
    });

    testWidgets('ArtworkPromptCard shows the error well for a blank url', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const SingleChildScrollView(
            child: ArtworkPromptCard(question: 'Blank artwork', imageUrl: '  '),
          ),
        ),
      );

      expect(find.byIcon(Icons.image_not_supported_outlined), findsOneWidget);
    });

    testWidgets('ArtworkPromptCard shows the error well when the url fails', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const SingleChildScrollView(
            child: ArtworkPromptCard(
              question: 'Remote artwork',
              imageUrl: 'https://example.invalid/art.png',
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Remote artwork'), findsOneWidget);
      expect(find.byIcon(Icons.image_not_supported_outlined), findsOneWidget);
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

    testWidgets('ChoiceGroup loading shows spinner and blocks taps', (
      tester,
    ) async {
      String? id;
      await tester.pumpWidget(
        _wrap(
          ChoiceGroup(
            options: const [
              ChoiceOption(
                id: 'a',
                label: 'Loading',
                state: ChoiceVisualState.loading,
              ),
              ChoiceOption(
                id: 'b',
                label: 'Disabled',
                state: ChoiceVisualState.disabled,
              ),
            ],
            onSelected: (v) => id = v,
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading'), findsNothing);

      await tester.tap(find.byType(CircularProgressIndicator));
      await tester.tap(find.text('Disabled'));
      await tester.pump();

      expect(id, isNull);
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

    test('LumeSnackBarTrait.brand resolves primary brand tokens', () {
      final style = LumeSnackBarTraitStyle.resolve(LumeSnackBarTrait.brand);
      expect(style.backgroundColor, AppColors.Primary.primaryContainer);
      expect(style.foregroundColor, AppColors.Primary.onPrimaryContainer);
      expect(
        style.borderColor,
        AppColors.Primary.primary.withValues(alpha: 0.7),
      );
      expect(style.borderWidth, 1.5);
    });

    testWidgets('LumeSnackBar renders brand trait', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const LumeSnackBar(
            icon: Icons.emoji_events_rounded,
            text: 'Brand toast',
            trait: LumeSnackBarTrait.brand,
          ),
        ),
      );
      expect(find.text('Brand toast'), findsOneWidget);
      expect(find.byIcon(Icons.emoji_events_rounded), findsOneWidget);
    });

    testWidgets('LumeSnackBar applies iconColor override', (tester) async {
      const gold = Color(0xFFE8C87A);
      await tester.pumpWidget(
        _wrap(
          const LumeSnackBar(
            icon: Icons.emoji_events_rounded,
            text: 'Gold icon',
            trait: LumeSnackBarTrait.brand,
            iconColor: gold,
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.emoji_events_rounded));
      expect(icon.color, gold);
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

      final safeArea = tester.widget<SafeArea>(find.byType(SafeArea));
      expect(safeArea.minimum.top, AppSpacings.l);

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

      final safeArea = tester.widget<SafeArea>(find.byType(SafeArea));
      expect(safeArea.minimum.bottom, AppSpacings.l);

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

    testWidgets('CelebrationDialog caps width on wide viewports', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      addTearDown(() async {
        await tester.binding.setSurfaceSize(null);
      });

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

      final card = find.descendant(
        of: find.byType(CelebrationDialog),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is ConstrainedBox &&
              widget.constraints.maxWidth == AppSizes.dialogMaxWidth,
        ),
      );
      expect(card, findsOneWidget);
      expect(
        tester.getSize(card).width,
        lessThanOrEqualTo(AppSizes.dialogMaxWidth),
      );
    });
  });
}

/// 4×4 PNG. Contents are irrelevant; the card only needs a decodable image.
final Uint8List _samplePng = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAQAAAAECAYAAACp8Z5+AAAAEklEQVR42mOQbrn1HxkzkC4AACd/J4ETnPSMAAAAAElFTkSuQmCC',
);

class _PendingImage extends ImageProvider<_PendingImage> {
  const _PendingImage();

  @override
  Future<_PendingImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture(this);
  }

  @override
  ImageStreamCompleter loadImage(
    _PendingImage key,
    ImageDecoderCallback decode,
  ) {
    return OneFrameImageStreamCompleter(Completer<ImageInfo>().future);
  }
}

class _FailingImage extends ImageProvider<_FailingImage> {
  const _FailingImage();

  @override
  Future<_FailingImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture(this);
  }

  @override
  ImageStreamCompleter loadImage(
    _FailingImage key,
    ImageDecoderCallback decode,
  ) {
    return OneFrameImageStreamCompleter(
      Future<ImageInfo>.error(StateError('decode failed')),
    );
  }
}
