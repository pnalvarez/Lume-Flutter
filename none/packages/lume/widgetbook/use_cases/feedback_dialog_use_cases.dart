import 'package:flutter/material.dart';
import 'package:lume_design_system/atoms/colors/colors.dart';
import 'package:lume_design_system/atoms/typography/typography.dart' as typ;
import 'package:lume_design_system/molecules/buttons/lume_button.dart';
import 'package:lume_design_system/organisms/dialogs/lume_dialog.dart';
import 'package:lume_design_system/organisms/feedback/floating_notice.dart';
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
              LumeButton(
                label: 'Entendi',
                type: LumeButtonType.outlined,
                onPressed: () => Navigator.of(context).pop(),
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
