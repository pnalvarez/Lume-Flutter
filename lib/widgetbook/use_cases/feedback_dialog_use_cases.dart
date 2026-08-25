import 'package:flutter/material.dart';
import 'package:lume_design_system/atoms/colors/colors.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/buttons/lume_button.dart';
import 'package:lume_design_system/organisms/dialogs/lume_dialog.dart';
import 'package:lume_design_system/organisms/feedback/floating_notice.dart';
import 'package:lume_design_system/organisms/feedback/lume_loading_overlay.dart';
import 'package:lume_design_system/organisms/feedback/lume_snack_bar.dart';
import 'package:lume_design_system/organisms/feedback/result_banner.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Tones', type: ResultBanner)
Widget resultBannerTones(BuildContext context) {
  final tone = context.knobs.object.dropdown(
    label: 'Tone',
    options: ResultBannerTone.values,
    labelBuilder: (t) => t.name,
    initialOption: ResultBannerTone.positive,
  );
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: ResultBanner(
        tone: tone,
        title: 'Headline',
        subtitle: 'Optional subtitle',
        bodyTitle: 'Detail',
        bodyText: 'Supporting explanation goes here.',
        footnote: 'Optional footnote.',
        amountChip: ResultBanner.amount(
          text: '+10',
          accentColor: AppColors.Accent.accent,
        ),
        actionLabel: 'Continue',
        onAction: () {},
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Dialog tones', type: CelebrationDialog)
Widget lumeDialogTones(BuildContext context) {
  final tone = context.knobs.object.dropdown(
    label: 'Tone',
    options: LumeDialogTone.values,
    labelBuilder: (t) => t.name,
    initialOption: LumeDialogTone.positive,
  );

  return Scaffold(
    body: Center(
      child: LumeButton(
        label: 'Abrir diálogo (${tone.name})',
        trait: buttonTraitForDialogTone(tone),
        onPressed: () {
          showLumeDialog<void>(
            context: context,
            tone: tone,
            title: switch (tone) {
              LumeDialogTone.neutral => 'Atenção',
              LumeDialogTone.positive => 'Acertou!',
              LumeDialogTone.negative => 'Não foi dessa vez',
            },
            content: Text(
              'Explicação de exemplo para o tom ${tone.name}.',
              style: typ.body4Light,
            ),
            actions: [
              Builder(
                builder: (dialogContext) => LumeButton(
                  label: 'Entendi',
                  type: LumeButtonType.outlined,
                  onPressed: () => Navigator.of(dialogContext).pop(),
                ),
              ),
            ],
          );
        },
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Amount', type: FloatingNotice)
Widget floatingNoticeAmount(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        const Center(child: Text('Page content')),
        FloatingNotice.amount(
          text: context.knobs.string(label: 'Text', initialValue: '+15 pts'),
          secondaryText: context.knobs.string(
            label: 'Secondary',
            initialValue: 'Bonus',
          ),
          accentColor: AppColors.Accent.accent,
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(name: 'Celebration', type: CelebrationDialog)
Widget celebrationDialogDefault(BuildContext context) {
  return Scaffold(
    body: Center(
      child: CelebrationDialog(
        icon: Icons.auto_awesome,
        title: context.knobs.string(
          label: 'Title',
          initialValue: 'You reached level 5',
        ),
        subtitle: context.knobs.string(
          label: 'Subtitle',
          initialValue: 'Keep going.',
        ),
        actionLabel: 'Continue',
        onAction: () {},
        onClose: () {},
      ),
    ),
  );
}

const _snackBarIconOptions = <(String, IconData)>[
  ('Check', Icons.check_circle_rounded),
  ('Warning', Icons.warning_amber_rounded),
  ('Error', Icons.error_outline_rounded),
  ('Info', Icons.info_outline_rounded),
  ('Bolt', Icons.bolt_rounded),
  ('Star', Icons.star_rounded),
  ('Close', Icons.close_rounded),
];

IconData _snackBarIconKnob(BuildContext context) {
  final option = context.knobs.object.dropdown(
    label: 'Icon',
    options: _snackBarIconOptions,
    labelBuilder: (entry) => entry.$1,
    initialOption: _snackBarIconOptions.first,
  );
  return option.$2;
}

@widgetbook.UseCase(name: 'All traits', type: LumeSnackBar)
Widget lumeSnackBarAllTraits(BuildContext context) {
  final icon = _snackBarIconKnob(context);
  final hasCloseButton = context.knobs.boolean(
    label: 'Has close button',
    initialValue: true,
  );
  final text = context.knobs.string(
    label: 'Text',
    initialValue: 'Mensagem de exemplo do snack bar.',
  );

  return Scaffold(
    body: ListView(
      padding: const EdgeInsets.all(AppSpacings.xl2),
      children: [
        for (final trait in LumeSnackBarTrait.values) ...[
          Text(trait.name, style: typ.body3Semibold),
          const SizedBox(height: AppSpacings.s),
          LumeSnackBar(
            icon: icon,
            text: text,
            trait: trait,
            hasCloseButton: hasCloseButton,
            onClose: () {},
          ),
          const SizedBox(height: AppSpacings.l),
        ],
      ],
    ),
  );
}

@widgetbook.UseCase(name: 'Interactive toast', type: LumeSnackBar)
Widget lumeSnackBarInteractive(BuildContext context) {
  final trait = context.knobs.object.dropdown(
    label: 'Trait',
    options: LumeSnackBarTrait.values,
    labelBuilder: (t) => t.name,
    initialOption: LumeSnackBarTrait.success,
  );
  final icon = _snackBarIconKnob(context);
  final hasCloseButton = context.knobs.boolean(
    label: 'Has close button',
    initialValue: true,
  );
  final text = context.knobs.string(
    label: 'Text',
    initialValue: 'Salvo com sucesso.',
  );

  return Scaffold(
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacings.xl2),
        child: LumeButton(
          label: 'Mostrar snack bar (${trait.name})',
          isExpanded: true,
          onPressed: () {
            showLumeSnackBar(
              context,
              icon: icon,
              text: text,
              trait: trait,
              hasCloseButton: hasCloseButton,
            );
          },
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(name: 'Inline', type: LumeLoadingOverlay)
Widget lumeLoadingOverlayInline(BuildContext context) {
  return const Scaffold(
    body: Stack(
      fit: StackFit.expand,
      children: [
        Center(child: Text('Page content')),
        LumeLoadingOverlay(),
      ],
    ),
  );
}

@widgetbook.UseCase(name: 'Global', type: LumeLoadingOverlay)
Widget lumeLoadingOverlayGlobal(BuildContext context) {
  return Scaffold(
    body: Center(
      child: LumeButton(
        label: 'Mostrar overlay global',
        onPressed: () {
          showLumeLoadingOverlay(context);
          Future<void>.delayed(const Duration(seconds: 2), () {
            hideLumeLoadingOverlay();
          });
        },
      ),
    ),
  );
}
