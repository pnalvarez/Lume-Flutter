import 'package:flutter/material.dart';
import 'package:lume/layers/presentation/shared/achievement_snack_bar.dart';
import 'package:lume_design_system/atoms/spacing/spacings.dart';
import 'package:lume_design_system/molecules/buttons/lume_button.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  path: '[Lume]/[Shared]/Achievement snack bar',
  name: 'Unlock toast',
  type: LumeButton,
)
Widget achievementUnlockedSnackBarDemo(BuildContext context) {
  final name = context.knobs.string(
    label: 'Achievement name',
    initialValue: 'Primeiro passo',
  );

  return Scaffold(
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacings.xl2),
        child: LumeButton(
          label: 'Show unlock snack bar',
          isExpanded: true,
          onPressed: () {
            showAchievementUnlockedSnackBar(context, name);
          },
        ),
      ),
    ),
  );
}
